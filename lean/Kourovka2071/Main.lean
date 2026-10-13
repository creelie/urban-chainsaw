import Kourovka2071.Graph
import Kourovka2071.Cards
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic.FinCases

/-!
# Kourovka Notebook Problem 20.71(b)

`Γ` is connected, has exactly three isomorphism types of cards, and `Aut(Γ)` has exactly five
orbits on the vertices.
-/

namespace K2071

open SimpleGraph

/-! ## Two automorphisms: `(a, b) ↦ (ta, t³b)` and `(a, b) ↦ (a², b²)` -/

/-- `(a, b) ↦ (ta, t³b)`. -/
def μ : Fin 63 → Fin 63 := ofCode fun a b => 8 * gmul 2 a + gmul 3 b
/-- `(a, b) ↦ (t⁻¹a, t⁻³b)`. -/
def μ' : Fin 63 → Fin 63 := ofCode fun a b => 8 * gmul 5 a + gmul 6 b
/-- `(a, b) ↦ (a², b²)`. -/
def φ : Fin 63 → Fin 63 := ofCode fun a b => 8 * gmul a a + gmul b b
/-- `(a, b) ↦ (a⁴, b⁴)`, the inverse of `φ`. -/
def φ' : Fin 63 → Fin 63 :=
  ofCode fun a b => 8 * gmul (gmul a a) (gmul a a) + gmul (gmul b b) (gmul b b)

/-- An automorphism of `Γ` from a map with a two-sided inverse that preserves adjacency. -/
def autOf (f g : Fin 63 → Fin 63) (h1 : ∀ k, g (f k) = k) (h2 : ∀ k, f (g k) = k)
    (h3 : ∀ i j, Γ.Adj (f i) (f j) ↔ Γ.Adj i j) : Γ ≃g Γ where
  toFun := f
  invFun := g
  left_inv := h1
  right_inv := h2
  map_rel_iff' := fun {i j} => h3 i j

def μAut : Γ ≃g Γ := autOf μ μ' (by decide +kernel) (by decide +kernel) (by decide +kernel)
def φAut : Γ ≃g Γ := autOf φ φ' (by decide +kernel) (by decide +kernel) (by decide +kernel)

/-! ## Orbit representatives: `(0,1)`, `(1,0)`, `(1,1)`, `(1,t)`, `(1,t+1)` -/

def rep : Fin 5 → Fin 63 := ![0, 7, 8, 9, 10]

def Ttab : List ℕ := [0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 3, 4, 3, 4, 1, 3, 4, 2, 4, 4, 3, 3, 1, 4,
  4, 3, 2, 3, 3, 4, 1, 3, 3, 3, 4, 2, 4, 4, 1, 4, 3, 4, 4, 3, 2, 3, 1, 3, 4, 4, 3, 3, 4, 2, 1, 4,
  2, 3, 3, 4, 4, 3]
def W1tab : List ℕ := [0, 5, 1, 3, 2, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3,
  3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 6, 6, 6, 6, 6, 6, 6, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5,
  5, 5, 5, 5, 5, 5]
def W2tab : List ℕ := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 0, 2, 2, 0, 1, 0, 0, 1, 0, 2,
  1, 0, 0, 2, 1, 0, 0, 0, 1, 2, 0, 0, 2, 1, 0, 0, 2, 1, 2, 1, 0, 0, 0, 1, 0, 2, 2, 0, 1, 0, 0, 1,
  0, 1, 0, 2, 0, 2]

/-- The index of the orbit of `k`. -/
def T (k : Fin 63) : Fin 5 := ⟨Ttab.getD k.val 0 % 5, Nat.mod_lt _ (by decide)⟩

theorem word : ∀ k : Fin 63, μ^[W1tab.getD k.val 0] (φ^[W2tab.getD k.val 0] (rep (T k))) = k := by
  decide +kernel

theorem orbit_rep (k : Fin 63) : (orbitSetoid Γ).r (rep (T k)) k := by
  obtain ⟨ρ1, h1⟩ := exists_iterate μAut (W1tab.getD k.val 0)
  obtain ⟨ρ2, h2⟩ := exists_iterate φAut (W2tab.getD k.val 0)
  refine ⟨ρ2.trans ρ1, ?_⟩
  rw [RelIso.trans_apply, h1, h2]
  exact word k

/-! ## An invariant separating the five orbits -/

/-- `w` is adjacent to `(0, 0)` in the Cayley graph; these are the vertices of degree 13. -/
def inS (w : Fin 63) : Prop := adjCode 0 (w.val + 1) = true

instance : DecidablePred inS := fun w => inferInstanceAs (Decidable (adjCode 0 (w.val + 1) = true))

theorem inS_iff : ∀ w : Fin 63, inS w ↔ Γ.degree w = 13 := by decide +kernel

theorem inS_aut (σ : Γ ≃g Γ) (w : Fin 63) : inS (σ w) ↔ inS w := by
  rw [inS_iff, inS_iff, degree_iso σ]

/-- The number of common neighbours of degree 13. -/
def comS (y z : Fin 63) : ℕ := (Finset.univ.filter fun w => Γ.Adj y w ∧ Γ.Adj z w ∧ inS w).card

/-- The number of common neighbours. -/
def com (x z : Fin 63) : ℕ := (Finset.univ.filter fun w => Γ.Adj x w ∧ Γ.Adj z w).card

theorem comS_aut (σ : Γ ≃g Γ) (y z : Fin 63) : comS (σ y) (σ z) = comS y z := by
  symm
  apply Finset.card_equiv σ.toEquiv
  intro w
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, RelIso.coe_fn_toEquiv, Iso.map_adj_iff,
    inS_aut]

theorem com_aut (σ : Γ ≃g Γ) (x z : Fin 63) : com (σ x) (σ z) = com x z := by
  symm
  apply Finset.card_equiv σ.toEquiv
  intro w
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, RelIso.coe_fn_toEquiv, Iso.map_adj_iff]

/-- The number of pairs `(y, z)` with `x ∼ y ∼ z`, `y` and `z` without common neighbour of
degree 13, `z ≠ x` not adjacent to `x`, and `x`, `z` with exactly two common neighbours. -/
def Finv (x : Fin 63) : ℕ := (Finset.univ.filter fun p : Fin 63 × Fin 63 =>
  Γ.Adj x p.1 ∧ Γ.Adj p.1 p.2 ∧ comS p.1 p.2 = 0 ∧ p.2 ≠ x ∧ ¬ Γ.Adj x p.2 ∧
    com x p.2 = 2).card

theorem Finv_aut (σ : Γ ≃g Γ) (x : Fin 63) : Finv (σ x) = Finv x := by
  symm
  apply Finset.card_equiv (σ.toEquiv.prodCongr σ.toEquiv)
  rintro ⟨y, z⟩
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, Equiv.prodCongr_apply, Prod.map,
    RelIso.coe_fn_toEquiv, Iso.map_adj_iff, comS_aut, com_aut, ne_eq, EmbeddingLike.apply_eq_iff_eq]

def fval : Fin 5 → ℕ := ![6, 15, 21, 8, 4]

theorem Finv_rep0 : Finv 0 = 6 := by decide +kernel
theorem Finv_rep1 : Finv 7 = 15 := by decide +kernel
theorem Finv_rep2 : Finv 8 = 21 := by decide +kernel
theorem Finv_rep3 : Finv 9 = 8 := by decide +kernel
theorem Finv_rep4 : Finv 10 = 4 := by decide +kernel

theorem Finv_rep (i : Fin 5) : Finv (rep i) = fval i := by
  fin_cases i
  · exact Finv_rep0
  · exact Finv_rep1
  · exact Finv_rep2
  · exact Finv_rep3
  · exact Finv_rep4

theorem Finv_eq (v : Fin 63) : Finv v = fval (T v) := by
  obtain ⟨ρ, hρ⟩ := orbit_rep v
  calc Finv v = Finv (ρ (rep (T v))) := by rw [hρ]
    _ = Finv (rep (T v)) := Finv_aut ρ _
    _ = fval (T v) := Finv_rep _

theorem fval_inj : ∀ i j : Fin 5, fval i = fval j → i = j := by decide

theorem orbit_iff (v w : Fin 63) : (orbitSetoid Γ).r v w ↔ T v = T w := by
  constructor
  · rintro ⟨σ, rfl⟩
    exact fval_inj _ _ ((Finv_eq v).symm.trans ((Finv_aut σ v).symm.trans (Finv_eq (σ v))))
  · intro h
    have a := orbit_rep v
    have b := orbit_rep w
    rw [h] at a
    exact (orbitSetoid Γ).iseqv.trans ((orbitSetoid Γ).iseqv.symm a) b

theorem T_surj : Function.Surjective T := by decide

/-- `Aut(Γ)` has exactly five orbits. -/
theorem orbits_eq : Nat.card (Quotient (orbitSetoid Γ)) = 5 :=
  natCard_quotient _ T orbit_iff T_surj

/-! ## Cards -/

instance (v : Fin 63) : DecidableRel (Γ.induce {u | u ≠ v}).Adj := fun a b =>
  inferInstanceAs (Decidable (Γ.Adj a.1 b.1))

def dval : Fin 5 → ℕ := ![24, 20, 20, 22, 22]

theorem nDeg_rep0 : nDeg (Γ.induce {u | u ≠ 0}) 13 = 24 := by decide +kernel
theorem nDeg_rep1 : nDeg (Γ.induce {u | u ≠ 7}) 13 = 20 := by decide +kernel
theorem nDeg_rep2 : nDeg (Γ.induce {u | u ≠ 8}) 13 = 20 := by decide +kernel
theorem nDeg_rep3 : nDeg (Γ.induce {u | u ≠ 9}) 13 = 22 := by decide +kernel
theorem nDeg_rep4 : nDeg (Γ.induce {u | u ≠ 10}) 13 = 22 := by decide +kernel

theorem nDeg_rep (i : Fin 5) : nDeg (Γ.induce {u | u ≠ rep i}) 13 = dval i := by
  fin_cases i
  · exact nDeg_rep0
  · exact nDeg_rep1
  · exact nDeg_rep2
  · exact nDeg_rep3
  · exact nDeg_rep4

theorem nDeg_eq (v : Fin 63) : nDeg (Γ.induce {u | u ≠ v}) 13 = dval (T v) := by
  obtain ⟨e⟩ := cardSetoid_of_orbit (orbit_rep v)
  rw [← nDeg_rep, nDeg_iso e]

/-- A card isomorphism from a map with an inverse that preserves adjacency off `v`. -/
def cardIsoOf (v w : Fin 63) (f g : Fin 63 → Fin 63) (h1 : ∀ u, u ≠ v → f u ≠ w)
    (h2 : ∀ u, u ≠ w → g u ≠ v) (h3 : ∀ u, u ≠ v → g (f u) = u)
    (h4 : ∀ u, u ≠ w → f (g u) = u)
    (h5 : ∀ a b, a ≠ v → b ≠ v → (Γ.Adj (f a) (f b) ↔ Γ.Adj a b)) :
    Γ.induce {u | u ≠ v} ≃g Γ.induce {u | u ≠ w} where
  toFun u := ⟨f u.1, h1 u.1 u.2⟩
  invFun u := ⟨g u.1, h2 u.1 u.2⟩
  left_inv u := Subtype.ext (h3 u.1 u.2)
  right_inv u := Subtype.ext (h4 u.1 u.2)
  map_rel_iff' := fun {a b} => h5 a.1 b.1 a.2 b.2

/-- Left multiplication by `(p, q)` in the Suzuki group: `(c, d) ↦ (p + c, q + d + pc²)`. -/
def lmul (p q : ℕ) : Fin 63 → Fin 63 :=
  ofCode fun c d => 8 * (p ^^^ c) + (q ^^^ d ^^^ gmul p (gmul c c))

theorem card_12 : (cardSetoid Γ).r (rep 1) (rep 2) :=
  ⟨cardIsoOf 7 8 (lmul 1 1) (lmul 1 0) (by decide +kernel) (by decide +kernel)
    (by decide +kernel) (by decide +kernel) (by decide +kernel)⟩

theorem card_34 : (cardSetoid Γ).r (rep 3) (rep 4) :=
  ⟨cardIsoOf 9 10 (lmul 1 3) (lmul 1 2) (by decide +kernel) (by decide +kernel)
    (by decide +kernel) (by decide +kernel) (by decide +kernel)⟩

def m3 : Fin 5 → Fin 3 := ![0, 1, 1, 2, 2]

theorem rep_card (i j : Fin 5) (h : m3 i = m3 j) : (cardSetoid Γ).r (rep i) (rep j) := by
  have s := (cardSetoid Γ).iseqv
  fin_cases i <;> fin_cases j <;> simp [m3] at h <;>
    first
    | exact s.refl _
    | exact card_12
    | exact s.symm card_12
    | exact card_34
    | exact s.symm card_34

theorem dval_m3 : ∀ i j : Fin 5, dval i = dval j → m3 i = m3 j := by decide

theorem card_iff (v w : Fin 63) : (cardSetoid Γ).r v w ↔ m3 (T v) = m3 (T w) := by
  have s := (cardSetoid Γ).iseqv
  constructor
  · rintro ⟨e⟩
    exact dval_m3 _ _ ((nDeg_eq v).symm.trans ((nDeg_iso e 13).trans (nDeg_eq w)))
  · intro h
    exact s.trans (s.symm (cardSetoid_of_orbit (orbit_rep v)))
      (s.trans (rep_card _ _ h) (cardSetoid_of_orbit (orbit_rep w)))

theorem m3T_surj : Function.Surjective fun v => m3 (T v) := by decide

/-- `Γ` has exactly three isomorphism types of cards. -/
theorem card_types_eq : Nat.card (Quotient (cardSetoid Γ)) = 3 :=
  natCard_quotient _ (fun v => m3 (T v)) card_iff m3T_surj

/-! ## Connectedness -/

theorem connected : Γ.Connected := by
  have h : ∀ v : Fin 63, v = 0 ∨ Γ.Adj 0 v ∨ ∃ u, Γ.Adj 0 u ∧ Γ.Adj u v := by decide +kernel
  rw [connected_iff_exists_forall_reachable]
  refine ⟨0, fun v => ?_⟩
  rcases h v with rfl | h | ⟨u, h1, h2⟩
  · rfl
  · exact h.reachable
  · exact h1.reachable.trans h2.reachable

/-- **Kourovka Notebook 20.71(b).** A connected graph with exactly three isomorphism types of
cards whose automorphism group has more than three (namely five) orbits on the vertices. -/
theorem kourovka_20_71b :
    ∃ (V : Type) (_ : Fintype V) (G : SimpleGraph V),
      G.Connected ∧ Nat.card (Quotient (cardSetoid G)) = 3 ∧
        3 < Nat.card (Quotient (orbitSetoid G)) :=
  ⟨Fin 63, inferInstance, Γ, connected, card_types_eq, by rw [orbits_eq]; decide⟩

end K2071
