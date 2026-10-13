#!/usr/bin/env python3
"""Independent check of the answer to Kourovka Notebook Problem 20.71(b).

H = A(3, theta) is the Suzuki 2-group of order 64: pairs (a, b) over
F8 = F2[t]/(t^3 + t + 1) with (a, b)(c, d) = (a + c, b + d + a c^2).
Y = Cay(H, S), S = {(a, 0), (a, a^3) : a != 0}, and X = Y - (0, 0).

The script checks that
  1. X has 63 vertices and 434 edges and is connected;
  2. mu: (a, b) -> (t a, t^3 b) and phi: (a, b) -> (a^2, b^2) are automorphisms
     of X, and the group they generate has the five orbits P, O0, O1, O2, O3;
  3. the isomorphism invariant F takes the values 6, 15, 21, 8, 4 on them,
     so Aut(X) has exactly five orbits;
  4. for every vertex x, left multiplication by x^{-1} is an isomorphism of
     the card X - x onto the card X - x^{-1};
  5. the number of vertices of degree 13 in the card X - x is 24 on P, 20 on
     O0 and O1, 22 on O2 and O3, so X has exactly three card types.
"""
import itertools
import sys

MOD = 0b1011  # t^3 + t + 1


def fmul(x, y):
    """Product in F8 by schoolbook multiplication and reduction."""
    r = 0
    for i in range(3):
        if (y >> i) & 1:
            r ^= x << i
    for i in (4, 3):
        if (r >> i) & 1:
            r ^= MOD << (i - 3)
    return r


def fpow(x, n):
    r = 1
    for _ in range(n):
        r = fmul(r, x)
    return r


def gmul(g, h):
    (a, b), (c, d) = g, h
    return (a ^ c, b ^ d ^ fmul(a, fmul(c, c)))


def ginv(g):
    a, b = g
    return (a, b ^ fpow(a, 3))


E = (0, 0)
H = [(a, b) for a in range(8) for b in range(8)]
S = {(a, 0) for a in range(1, 8)} | {(a, fpow(a, 3)) for a in range(1, 8)}
V = [g for g in H if g != E]
assert len(S) == 14 and all(ginv(s) in S for s in S)

adj = {g: set() for g in V}
for g in V:
    for s in S:
        h = gmul(g, s)
        if h != E:
            adj[g].add(h)
for g in V:
    for h in adj[g]:
        assert g in adj[h] and g != h
fails = 0


def check(name, ok):
    global fails
    print(("PASS " if ok else "FAIL ") + name)
    if not ok:
        fails += 1


# 1. size and connectivity
nedges = sum(len(adj[g]) for g in V) // 2
check("63 vertices and 434 edges", len(V) == 63 and nedges == 434)
seen, stack = {V[0]}, [V[0]]
while stack:
    g = stack.pop()
    for h in adj[g] - seen:
        seen.add(h)
        stack.append(h)
check("X is connected", len(seen) == 63)


# 2. two automorphisms and the orbits of the group they generate
def mu(g):
    a, b = g
    return (fmul(2, a), fmul(fpow(2, 3), b))


def phi(g):
    a, b = g
    return (fmul(a, a), fmul(b, b))


def is_aut(f):
    img = [f(g) for g in V]
    if sorted(img) != sorted(V):
        return False
    return all((f(h) in adj[f(g)]) == (h in adj[g]) for g in V for h in V)


check("mu is an automorphism", is_aut(mu))
check("phi is an automorphism", is_aut(phi))

parent = {g: g for g in V}


def find(g):
    while parent[g] != g:
        parent[g] = parent[parent[g]]
        g = parent[g]
    return g


for g in V:
    for f in (mu, phi):
        parent[find(g)] = find(f(g))
orbits = {}
for g in V:
    orbits.setdefault(find(g), set()).add(g)


def trace(x):
    return x ^ fmul(x, x) ^ fpow(x, 4)


def cls(g):
    a, b = g
    if a == 0:
        return "P"
    beta = fmul(b, fpow(fpow(a, 3), 6))  # b / a^3
    if beta == 0:
        return "O0"
    if beta == 1:
        return "O1"
    return "O2" if trace(beta) == 0 else "O3"


named = {}
for g in V:
    named.setdefault(cls(g), set()).add(g)
check("<mu, phi> has the orbits P, O0, O1, O2, O3 of sizes 7, 7, 7, 21, 21",
      sorted(map(frozenset, orbits.values()), key=sorted)
      == sorted(map(frozenset, named.values()), key=sorted)
      and [len(named[c]) for c in ("P", "O0", "O1", "O2", "O3")] == [7, 7, 7, 21, 21])

# 3. the invariant F
deg = {g: len(adj[g]) for g in V}
D13 = {g for g in V if deg[g] == 13}
check("the vertices of degree 13 are the elements of S", D13 == S)


def com(x, z):
    return len(adj[x] & adj[z])


def comS(y, z):
    return len(adj[y] & adj[z] & D13)


def F(x):
    n = 0
    for y in adj[x]:
        for z in adj[y]:
            if z != x and z not in adj[x] and comS(y, z) == 0 and com(x, z) == 2:
                n += 1
    return n


fv = {c: {F(g) for g in named[c]} for c in named}
check("F = 6, 15, 21, 8, 4 on P, O0, O1, O2, O3",
      [fv[c] for c in ("P", "O0", "O1", "O2", "O3")] == [{6}, {15}, {21}, {8}, {4}])


# 4. card isomorphisms by left multiplication
def card_iso_ok(x):
    y = ginv(x)
    xi = ginv(x)
    f = {u: gmul(xi, u) for u in V if u != x}
    if sorted(f.values()) != sorted(u for u in V if u != y):
        return False
    return all((f[w] in adj[f[u]]) == (w in adj[u]) for u in f for w in f)


check("X - x is isomorphic to X - x^{-1} for every x", all(card_iso_ok(x) for x in V))
inv_cls = {(cls(x), cls(ginv(x))) for x in V}
check("inversion maps P, O0, O1, O2, O3 to P, O1, O0, O3, O2",
      inv_cls == {("P", "P"), ("O0", "O1"), ("O1", "O0"), ("O2", "O3"), ("O3", "O2")})


# 5. the degree-13 count of the cards
def card_d13(x):
    return sum(1 for u in V if u != x and len(adj[u] - {x}) == 13)


dv = {c: {card_d13(g) for g in named[c]} for c in named}
check("cards have 24, 20, 20, 22, 22 vertices of degree 13",
      [dv[c] for c in ("P", "O0", "O1", "O2", "O3")] == [{24}, {20}, {20}, {22}, {22}])

print("orbits of Aut(X): 5, card types: 3" if fails == 0 else "%d checks failed" % fails)
sys.exit(1 if fails else 0)
