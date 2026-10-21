# AI provenance: A graph with three card types and five vertex orbits

Authors: Deep Bhattacharjee (corresponding author, ORCID 0000-0003-0466-750X)
and Ushashi Bhattacharya (ORCID 0009-0002-2254-3914).

- Paper: https://github.com/creelie/urban-chainsaw/blob/main/preprintKourovka2071b/Kourovka2071b.pdf
- Lean formalisation and code: release v2.1.0, https://github.com/creelie/urban-chainsaw/releases/tag/v2.1.0
- Repository: https://github.com/creelie/urban-chainsaw

## Result

Part (b) of Problem 20.71 of the Kourovka Notebook (posed by J. Lauri) asks
whether a connected graph with exactly three isomorphism types of cards can
have more than three vertex orbits under its automorphism group. The paper
answers yes. The graph is X = Y − e: Y is the Cayley graph of the Suzuki
2-group of order 64 on F_8 × F_8, and e is its identity vertex. The graph X is
connected, has 63 vertices, has exactly 3 card types and has 5 vertex orbits.

## Who did what

Deep Bhattacharjee chose the problem, directed the work, set the format and
the target journal, and ran the computations. Claude (Anthropic), used through
Claude Code under his direction, produced the following:

- the construction of the graph;
- the proofs;
- the Lean 4 formalisation;
- the four checking programs in Python, Julia, C and C++;
- the figures;
- the LaTeX text of the paper.

No other AI system took part. The paper uses no unproved result from other
work.

## How the result is checked

- **Lean 4.34.1 with Mathlib.**
  - `K2071.main_theorem` states that there are a finite type V with 63
    elements and a simple graph G on V such that G is connected, has exactly
    3 isomorphism classes of vertex-deleted subgraphs, and has exactly 5
    automorphism orbits.
  - `K2071.kourovka_20_71b` states the answer to part (b): 3 card types and
    more than 3 orbits.
  - The proof gives the automorphisms and the card isomorphisms explicitly.
    The finite checks are made by `decide +kernel`.
  - Both theorems depend only on the standard axioms propext, Classical.choice
    and Quot.sound. There is no `sorry`, `native_decide` or added axiom.
- **Independent programs.** Four programs (`checks/`) recompute the graph,
  the orbits and the card types in exact integer arithmetic.
- **Release workflow.** It builds the Lean proof and runs every program before
  publishing.

## What is not claimed

Parts (a) and (c) of Problem 20.71 are not treated: (a) is open, and (c) was
answered by J. Prajapati (2026). The Notebook lists part (b) as open in
version 48 (6 October 2026). The authors checked this again on 15 October
2026 and on 17 October 2026 and found no other answer on arXiv, on the
Kourovka Notebook site or on the web.

## Text and references

The paper is written in one analytical flow, with the references in the
LaTeX source itself. The bibliography carries the works it builds on;
every entry was checked
against its Crossref record or its source page, and none comes from
TechRxiv, Qeios, Authorea or EasyChair.
