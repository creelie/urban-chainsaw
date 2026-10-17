# A graph with three card types and five vertex orbits

Deep Bhattacharjee (corresponding author; Formerly, Electro-Gravitational
Space Propulsion Laboratory (EGSPL), Bhubaneswar, Odisha 751030, India, and
Formerly, University of Calcutta, Senate House, 87/1 College Street, Kolkata
700073, West Bengal, India; itsdeep@live.com, d.bhattacharjee@erl-forschung.de; ORCID 0000-0003-0466-750X)
and Ushashi Bhattacharya (Formerly, National Taiwan University, Taipei 106319,
Taiwan; rai.bhattacharya.in@gmail.com; ORCID 0009-0002-2254-3914).

- Paper: [`preprintKourovka2071b/Kourovka2071b.pdf`](preprintKourovka2071b/Kourovka2071b.pdf)
- Lean 4 formalization on Zenodo: doi:[10.5281/zenodo.23384197](https://doi.org/10.5281/zenodo.23384197) (release v2.0.0; all versions: doi:[10.5281/zenodo.23339830](https://doi.org/10.5281/zenodo.23339830))
- Master zip: [`MasterKourovka2071b_masterzipfinal2.zip`](https://github.com/creelie/urban-chainsaw/raw/main/MasterKourovka2071b_masterzipfinal2.zip)
- Target journal: Discrete Mathematics (`journal/JOURNAL.md`)
- MSC 2020: Primary 05C60; Secondary 05C25, 20D15, 68V15

This repository answers part (b) of Problem 20.71 of the Kourovka Notebook
([arXiv:1401.0300v48](https://arxiv.org/abs/1401.0300)), posed by J. Lauri:

> A card of a finite simple undirected graph G of order n = |V(G)| is an
> induced subgraph of order n - 1. For a connected graph G with k isomorphism
> types of cards, can Aut(G) have more than k orbits on the vertex set V(G)
> a) for k = 2? b) for k = 3? c) for k = 4?

Part (c) was answered by J. Prajapati (2026) with a graph on 9 vertices, who
also showed that an example for k = 2 or k = 3 needs at least 13 vertices.
Part (a) remains open. Part (b) is listed as open in version 48 of the
Notebook (6 October 2026); this was checked again on 15 October 2026 against
the Notebook's site, arXiv and the web, and no other answer was found.

## Result

**Theorem.** There is a connected graph X on 63 vertices with exactly 3
isomorphism types of cards whose automorphism group has 5 orbits on the
vertices.

Let F = F_8 = F_2[t]/(t^3 + t + 1) and let H be the Suzuki 2-group of order 64
on F x F with product (a, b)(c, d) = (a + c, b + d + a c^2). Let Y be the
Cayley graph of H with connection set S = {(a, 0), (a, a^3) : a != 0}, so that
(a, b) ~ (c, d) if and only if a != c and b + d is a(a + c)^2 or c(a + c)^2.
Then X = Y - (0, 0) (434 edges).

- Any two distinct vertices of Y have 2 common neighbours if they lie in the
  same coset of the centre Z = {(0, b)}, and 3 otherwise.
- The orbits of Aut(X) are P = Z \ {(0,0)}, O0 = {(a, 0) : a != 0},
  O1 = {(a, a^3) : a != 0},
  O2 = {(a, a^3 b) : a != 0, Tr b = 0, b != 0} and
  O3 = {(a, a^3 b) : a != 0, Tr b = 1, b != 1},
  of sizes 7, 7, 7, 21, 21. The maps (a, b) -> (t a, t^3 b) and
  (a, b) -> (a^2, b^2) act transitively on each; O0 and O1 are told apart by a
  Fano plane on the cosets of Z defined by the graph, and O2, O3 by their
  numbers of neighbours in O0 and O1.
- Left multiplication by x^-1 maps X - x onto X - x^-1, and inversion exchanges
  O0 with O1 and O2 with O3. The cards at P, at O0 and O1, and at O2 and O3
  have 24, 20 and 22 vertices of degree 13, so there are exactly 3 card types.

## Contents

| Path | Contents |
|---|---|
| `paper/` | LaTeX source (`main.tex` with the references in the source, Elsevier `elsarticle` class, `figures/` as PNG) |
| `figures/` | TikZ sources of the three figures and `make_figures.sh`, which writes them to `paper/figures/` |
| `lean/` | Lean 4 + Mathlib formalization; `Kourovka2071/Main.lean` holds `K2071.main_theorem` and `K2071.kourovka_20_71b` |
| `checks/python/`, `checks/julia/`, `checks/c/`, `checks/cpp/` | four independent programs checking the graph, the orbits and the card types |
| `run_all.sh` | runs the Lean build, the axiom check and all programs |
| `make_dist.sh` | builds `dist/`, the preprint folder and the master zip |
| `journal/JOURNAL.md` | target journal, format rules and AI policy |
| `dist/` | `Kourovka2071b_final2.pdf`, `Kourovka2071b_final2-tex.zip` (source with PNG figures) and `Kourovka2071b_final2-arxiv.tar.gz` |
| `preprintKourovka2071b/` | the paper as a PDF, and nothing else |
| `MasterKourovka2071b_masterzipfinal2.zip` | every tracked file of the repository with `dist/` |

## Lean statement

```lean
theorem main_theorem :
    ∃ (V : Type) (_ : Fintype V) (G : SimpleGraph V),
      Nat.card V = 63 ∧ G.Connected ∧ Nat.card (Quotient (cardSetoid G)) = 3 ∧
        Nat.card (Quotient (orbitSetoid G)) = 5

theorem kourovka_20_71b :
    ∃ (V : Type) (_ : Fintype V) (G : SimpleGraph V),
      G.Connected ∧ Nat.card (Quotient (cardSetoid G)) = 3 ∧
        3 < Nat.card (Quotient (orbitSetoid G))
```

Here `cardSetoid G` relates v and w when `G.induce {u | u ≠ v}` and
`G.induce {u | u ≠ w}` are isomorphic, and `orbitSetoid G` relates v and w when
an automorphism of G maps v to w. The proof gives the two automorphisms and the
card isomorphisms explicitly and separates the five orbits by a counting
invariant; the finite checks are made by `decide +kernel`.
`#print axioms` reports `[propext, Classical.choice, Quot.sound]` for both
theorems; there is no `sorry`, `admit`, `native_decide` or added axiom.

## Running the checks

Requirements: elan (Lean 4.34.1, fetched from `lean/lean-toolchain`),
python3, julia, a C compiler and a C++17 compiler. The Lean build needs about
6 GB of memory.

    ./run_all.sh            # Lean build (with the Mathlib cache), axiom check, all programs
    ./run_all.sh --no-lean  # programs only

Each program prints ten PASS lines and `orbits of Aut(X): 5, card types: 3`.

To build the paper and the release files: `./make_dist.sh` (needs latexmk,
zip and tar; `figures/make_figures.sh` redraws the figures).

## Archive

| Release | Zenodo DOI |
|---|---|
| v2.0.0 (two authors, journal format) | [10.5281/zenodo.23384197](https://doi.org/10.5281/zenodo.23384197) |
| v1.0.0 | [10.5281/zenodo.23339831](https://doi.org/10.5281/zenodo.23339831) |
| all versions | [10.5281/zenodo.23339830](https://doi.org/10.5281/zenodo.23339830) |
