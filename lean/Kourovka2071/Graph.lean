import Mathlib.Combinatorics.SimpleGraph.Maps
import Mathlib.Combinatorics.SimpleGraph.Finite

/-!
# The graph `Γ`

`F₈ = F₂[t]/(t³ + t + 1)`; the element `x₀ + x₁t + x₂t²` is coded by the natural number
`x₀ + 2x₁ + 4x₂ < 8`, so that addition is `Nat.xor`. The vertex set of `Γ` is
`F₈ × F₈ ∖ {(0, 0)}`, the pair `(a, b)` being coded by `8a + b ∈ [1, 63]`; the vertex
`k : Fin 63` is the pair with code `k + 1`. Two pairs `(a, b)` and `(c, d)` are adjacent when
`a ≠ c` and `b + d ∈ {a(a + c)², c(a + c)²}`.
-/

namespace K2071

/-- Multiplication in `F₈ = F₂[t]/(t³ + t + 1)` on codes `< 8`. -/
def gmul (x y : ℕ) : ℕ :=
  let p := (if y.testBit 0 then x else 0) ^^^ (if y.testBit 1 then 2 * x else 0) ^^^
    (if y.testBit 2 then 4 * x else 0)
  let p := if p.testBit 4 then p ^^^ 22 else p
  if p.testBit 3 then p ^^^ 11 else p

/-- Adjacency of the pairs with codes `u` and `v`. -/
def adjCode (u v : ℕ) : Bool :=
  let a := u / 8
  let b := u % 8
  let c := v / 8
  let d := v % 8
  let s := gmul (a ^^^ c) (a ^^^ c)
  a != c && ((b ^^^ d) == gmul a s || (b ^^^ d) == gmul c s)

theorem adjCode_comm (u v : ℕ) : adjCode u v = adjCode v u := by
  unfold adjCode
  simp only [Nat.xor_comm (u / 8) (v / 8), Nat.xor_comm (u % 8) (v % 8), bne_comm]
  cases (v / 8 != u / 8) <;> simp [Bool.or_comm]

theorem adjCode_self (u : ℕ) : adjCode u u = false := by
  simp [adjCode]

/-- The graph `Γ` on `F₈ × F₈ ∖ {(0, 0)}`; the vertex `k` is the pair with code `k + 1`. -/
def Γ : SimpleGraph (Fin 63) where
  Adj i j := adjCode (i.val + 1) (j.val + 1) = true
  symm := ⟨fun i j h => by rw [adjCode_comm]; exact h⟩
  loopless := ⟨fun i h => by rw [adjCode_self] at h; exact Bool.false_ne_true h⟩

instance : DecidableRel Γ.Adj := fun i j =>
  inferInstanceAs (Decidable (adjCode (i.val + 1) (j.val + 1) = true))

/-- The map of vertices given by a map `f` of codes, written as a function of `(a, b)`. -/
def ofCode (f : ℕ → ℕ → ℕ) (k : Fin 63) : Fin 63 :=
  ⟨(f ((k.val + 1) / 8) ((k.val + 1) % 8) + 62) % 63, Nat.mod_lt _ (by decide)⟩

end K2071
