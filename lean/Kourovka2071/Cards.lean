import Mathlib.Combinatorics.SimpleGraph.Maps
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.SetTheory.Cardinal.Finite

/-!
# Cards, card types and orbits

A card of `G` is the subgraph `G.induce {u | u ≠ v}` induced on all vertices but one.
Two vertices are card-equivalent when their cards are isomorphic, and orbit-equivalent when an
automorphism of `G` maps one to the other. The number of isomorphism types of cards and the
number of orbits of `Aut(G)` are the numbers of classes of these two equivalence relations.
-/

namespace K2071

open SimpleGraph

variable {V : Type*}

/-- `v ≈ w` when the cards of `G` at `v` and at `w` are isomorphic. -/
def cardSetoid (G : SimpleGraph V) : Setoid V where
  r v w := Nonempty (G.induce {u | u ≠ v} ≃g G.induce {u | u ≠ w})
  iseqv := ⟨fun _ => ⟨Iso.refl⟩, fun ⟨e⟩ => ⟨e.symm⟩, fun ⟨e⟩ ⟨f⟩ => ⟨e.trans f⟩⟩

/-- `v ≈ w` when some automorphism of `G` maps `v` to `w`. -/
def orbitSetoid (G : SimpleGraph V) : Setoid V where
  r v w := ∃ σ : G ≃g G, σ v = w
  iseqv := ⟨fun v => ⟨Iso.refl, rfl⟩,
    fun ⟨σ, h⟩ => ⟨σ.symm, by rw [← h]; exact σ.symm_apply_apply _⟩,
    fun ⟨σ, h⟩ ⟨τ, h'⟩ => ⟨σ.trans τ, by rw [RelIso.trans_apply, h, h']⟩⟩

/-- The number of classes of `s` is `n` when `s` is the kernel of a surjection onto `Fin n`. -/
theorem natCard_quotient (s : Setoid V) {n : ℕ} (f : V → Fin n)
    (hf : ∀ v w, s.r v w ↔ f v = f w) (hs : Function.Surjective f) :
    Nat.card (Quotient s) = n := by
  let g : Quotient s → Fin n := Quotient.lift f (fun v w h => (hf v w).1 h)
  have hg : Function.Bijective g := by
    constructor
    · intro x y h
      induction x using Quotient.inductionOn with | h v => ?_
      induction y using Quotient.inductionOn with | h w => ?_
      exact Quotient.sound ((hf v w).2 h)
    · intro i
      obtain ⟨v, rfl⟩ := hs i
      exact ⟨Quotient.mk s v, rfl⟩
  rw [Nat.card_eq_of_bijective g hg, Nat.card_eq_fintype_card, Fintype.card_fin]

variable {W : Type*}

/-- An isomorphism preserves degrees. -/
theorem degree_iso [Fintype V] [Fintype W] {G : SimpleGraph V} {H : SimpleGraph W}
    [DecidableRel G.Adj] [DecidableRel H.Adj] (e : G ≃g H) (v : V) :
    H.degree (e v) = G.degree v := by
  rw [← card_neighborFinset_eq_degree, ← card_neighborFinset_eq_degree]
  symm
  apply Finset.card_equiv e.toEquiv
  intro u
  simp only [mem_neighborFinset, RelIso.coe_fn_toEquiv]
  exact e.map_adj_iff.symm

/-- The number of vertices of degree `d`. -/
def nDeg [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj] (d : ℕ) : ℕ :=
  (Finset.univ.filter fun v => G.degree v = d).card

theorem nDeg_iso [Fintype V] [Fintype W] {G : SimpleGraph V} {H : SimpleGraph W}
    [DecidableRel G.Adj] [DecidableRel H.Adj] (e : G ≃g H) (d : ℕ) : nDeg G d = nDeg H d := by
  apply Finset.card_equiv e.toEquiv
  intro u
  simp [degree_iso e u]

/-- An automorphism maps the card at `v` onto the card at `σ v`. -/
def cardIsoOfAut {G : SimpleGraph V} (σ : G ≃g G) (v : V) :
    G.induce {u | u ≠ v} ≃g G.induce {u | u ≠ σ v} where
  toFun u := ⟨σ u.1, fun h => u.2 (σ.injective h)⟩
  invFun u := ⟨σ.symm u.1, fun h => u.2 (by
    have h' := congrArg σ h
    rwa [σ.apply_symm_apply] at h')⟩
  left_inv u := Subtype.ext (σ.symm_apply_apply u.1)
  right_inv u := Subtype.ext (σ.apply_symm_apply u.1)
  map_rel_iff' := fun {a b} => σ.map_adj_iff (v := a.1) (w := b.1)

theorem cardSetoid_of_orbit {G : SimpleGraph V} {v w : V} (h : (orbitSetoid G).r v w) :
    (cardSetoid G).r v w := by
  obtain ⟨σ, rfl⟩ := h
  exact ⟨cardIsoOfAut σ v⟩

/-- The iterates of an automorphism are automorphisms. -/
theorem exists_iterate {G : SimpleGraph V} (σ : G ≃g G) (n : ℕ) :
    ∃ ρ : G ≃g G, ⇑ρ = (⇑σ)^[n] := by
  induction n with
  | zero => exact ⟨Iso.refl, rfl⟩
  | succ n ih =>
    obtain ⟨ρ, hρ⟩ := ih
    exact ⟨σ.trans ρ, by rw [Function.iterate_succ, ← hρ]; rfl⟩

end K2071
