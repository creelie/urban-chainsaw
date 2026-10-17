# Hexagon submission fields

Title: A graph with three card types and five vertex orbits

Abstract: We prove that the answer to part (b) of Problem 20.71 of the Kourovka Notebook is yes: there is a connected graph on 63 vertices with exactly three isomorphism types of vertex-deleted subgraphs whose automorphism group has five orbits on the vertices. The graph is a Cayley graph of a Suzuki 2-group of order 64 with one vertex removed.

Primary subject: math.CO (Combinatorics)
Cross-list subjects: math.GR (Group Theory)
Tags: vertex-deleted subgraph, pseudosimilar vertices, Cayley graph, Suzuki 2-group, divisible design graph
MSC2020: 05C60 Isomorphism problems in graph theory (reconstruction conjecture, etc.) and homomorphisms (subgraph embedding, etc.); 05C25 Graphs and abstract algebra (groups, rings, fields, etc.); 20D15 Finite nilpotent groups, p-groups; 68V15 Theorem proving (automated and interactive theorem provers, deduction, resolution, etc.)

Contributor 1 (submitting): Deep Bhattacharjee; ORCID 0000-0003-0466-750X; affiliation: Formerly, Electro-Gravitational Space Propulsion Laboratory (EGSPL), Bhubaneswar, Odisha 751030, India; formerly, University of Calcutta, Senate House, 87/1 College Street, Kolkata 700073, West Bengal, India; itsdeep@live.com (second address d.bhattacharjee@erl-forschung.de)
Contributor 2: Ushashi Bhattacharya; ORCID 0009-0002-2254-3914; affiliation: Formerly, National Taiwan University, Taipei 106319, Taiwan; rai.bhattacharya.in@gmail.com

Text of the contribution: A mix of human-written and AI-generated.
Human understanding: "All parts" only after both authors have read every proof; otherwise "Some parts, but not all".

Provenance statement: The construction of the graph, the proofs, the text, the figures, the Lean 4 formalization and the Python, Julia, C, C++ and shell programs were carried out by Deep Bhattacharjee with the help of AI assistance (Claude, Anthropic) in the Claude Code environment. The graph is the Cayley graph of the Suzuki 2-group of order 64 with the identity removed; it is a divisible design graph in the sense of Haemers, Kharaghani and Meulenberg, and its five orbits are separated by a Fano plane carried by the cosets of the centre. The theorem is proved in Lean 4 with Mathlib (K2071.main_theorem and K2071.kourovka_20_71b), depending only on the axioms propext, Classical.choice and Quot.sound, with no sorry, native_decide or added axiom; the finite checks are made by the kernel, and four programs in exact integer arithmetic recompute the graph, its orbits and its card types. No statement rests on a floating-point computation. Part (a) of Problem 20.71 (k = 2) is not treated and stays open; part (c) was answered earlier by J. Prajapati. Both authors approved the final version.

Tools used: Anthropic - Claude (Claude Code); Lean community - Lean 4 (v4.34.1) with Mathlib; Python; Julia; C; C++; shell.
arXiv identifier: none (not posted on arXiv).
Formalization: https://github.com/creelie/urban-chainsaw/blob/main/lean/Kourovka2071.lean (archived at Zenodo, release v2.0.0: https://doi.org/10.5281/zenodo.23384197)

Source files or ZIP: Kourovka2071b_final2-tex.zip (the folder Kourovka2071b_final2-tex/ with main.tex, elsarticle.cls and figures/ as PNG; seven entries; compiles with latexmk -pdf main.tex, no BibTeX pass, all fonts embedded). Do not upload the master zip or the Lean files here.
AI provenance files: AI_PROVENANCE_Kourovka2071b.md
License: CC BY 4.0

Data availability (in the paper): LaTeX source, the Lean 4 formalization and the programs archived at Zenodo under doi:10.5281/zenodo.23384197 (release v2.0.0; all versions 10.5281/zenodo.23339830); repository https://github.com/creelie/urban-chainsaw; the folder preprintKourovka2071b holds the PDF only.
AI disclosure (in the paper, Data and code availability): Deep Bhattacharjee carried out the computations and the Lean, Julia, C, C++, Python and shell verifications, and the proofs and the text were drafted, with AI assistance (Claude, Anthropic); both authors approved the final version. No separate AI declaration.
Funding: none. Competing interests: none.
Device folder: D:\Hexagon\03 Kourovka2071b.
