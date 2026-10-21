Deep Bhattacharjee and Ushashi Bhattacharya, *A graph with three card types and five vertex orbits*.

The paper answers part (b) of Problem 20.71 of the Kourovka Notebook (J. Lauri) in the
affirmative: the Cayley graph of the Suzuki 2-group of order 64 on F_8 x F_8 with connection set
{(a,0), (a,a^3) : a != 0}, minus the identity, is a connected graph on 63 vertices with exactly
three isomorphism types of vertex-deleted subgraphs and five orbits of its automorphism group.

Lean 4 with Mathlib checks the whole statement (K2071.main_theorem: 63 vertices, connected,
3 card types, 5 orbits); it depends only on propext, Classical.choice and Quot.sound. Programs in
Python, Julia, C and C++ check the graph, the orbits and the card types. This release runs all of
them, Lean included.

Version 2.1.0 is the journal version for Discrete Mathematics: it cites this release instead of a DOI and leaves out the footnotes unrelated to the proof. The paper is also in `paper/paper1/` and its LaTeX source zip in `paper/paper2/`.

Files: the paper (`Kourovka2071b_final2.pdf`), its LaTeX source with the figures as PNG
(`Kourovka2071b_final2-tex.zip`) and the arXiv tarball (`Kourovka2071b_final2-arxiv.tar.gz`). The
archive of the tag holds the Lean project, the check programs and the master zip
`MasterKourovka2071b_masterzipfinal2.zip`.
