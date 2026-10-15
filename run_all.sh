#!/usr/bin/env bash
# Runs the Lean build and the four independent checks.
# Requirements: elan (Lean 4), python3, julia, a C compiler, a C++17 compiler.
# Usage: ./run_all.sh            (all steps)
#        ./run_all.sh --no-lean  (skip the Lean build)
# The Lean build needs about 6 GB of memory: each decide +kernel check of the
# invariants is a separate theorem.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT
CC_BIN="${CC:-cc}"
CXX_BIN="${CXX:-c++}"

step() { printf '\n=== %s\n' "$1"; }

for tool in python3 julia "$CC_BIN" "$CXX_BIN"; do
  command -v "$tool" >/dev/null 2>&1 || { echo "missing tool: $tool" >&2; exit 2; }
done

if [ "${1:-}" != "--no-lean" ]; then
  command -v lake >/dev/null 2>&1 || { echo "missing tool: lake (install elan)" >&2; exit 2; }
  step "Lean 4: lake build"
  ( cd "$ROOT/lean" && lake exe cache get >/dev/null 2>&1 || true )
  ( cd "$ROOT/lean" && lake build 2>&1 | tee "$BUILD/lean.log" | grep -E "error|Build completed|depends on axioms" ) || true
  if ! grep -q "Build completed successfully" "$BUILD/lean.log" || grep -q "error" "$BUILD/lean.log"; then
    echo "Lean build failed" >&2; exit 1
  fi
  step "Lean 4: axioms of the main theorems"
  for thm in main_theorem kourovka_20_71b orbits_eq card_types_eq connected; do
    line="$(grep "'K2071.$thm' depends on axioms" "$BUILD/lean.log" || true)"
    echo "$line"
    case "$line" in
      *"'K2071.$thm' depends on axioms: [propext, Classical.choice, Quot.sound]") ;;
      *) echo "unexpected axioms for $thm" >&2; exit 1 ;;
    esac
  done
  if grep -rnwE "sorry|admit|native_decide|bv_decide" "$ROOT/lean/Kourovka2071" "$ROOT/lean/Kourovka2071.lean"; then
    echo "sorry, admit, native_decide or bv_decide found" >&2; exit 1
  fi
  if grep -rnE "^[[:space:]]*axiom[[:space:]]" "$ROOT/lean/Kourovka2071" "$ROOT/lean/Kourovka2071.lean"; then
    echo "axiom declaration found" >&2; exit 1
  fi
  echo "no sorry, admit, native_decide, bv_decide or axiom declarations"
fi

step "Python"
python3 -I "$ROOT/checks/python/check.py"

step "Julia"
julia --startup-file=no "$ROOT/checks/julia/check.jl"

step "C"
"$CC_BIN" -O2 -std=c99 -o "$BUILD/check_c" "$ROOT/checks/c/check.c"
"$BUILD/check_c"

step "C++"
"$CXX_BIN" -O2 -std=c++17 -o "$BUILD/check_cpp" "$ROOT/checks/cpp/check.cpp"
"$BUILD/check_cpp"

printf '\nAll steps passed.\n'
