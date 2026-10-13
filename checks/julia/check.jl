# Independent check of the answer to Kourovka Notebook Problem 20.71(b), in Julia.
# F8 = F2[t]/(t^3 + t + 1) as polynomials over F2 reduced by long division.
# The Suzuki 2-group H of order 64: (a, b)(c, d) = (a + c, b + d + a c^2).
# Y = Cay(H, S), S = {(a, 0), (a, a^3) : a != 0}, X = Y - (0, 0).
# Same five claims as check.py; the graph is a Boolean adjacency matrix.

function fmul(x::Int, y::Int)
    r = 0
    for i in 0:2
        if (y >> i) & 1 == 1
            r = xor(r, x << i)
        end
    end
    for i in 4:-1:3
        if (r >> i) & 1 == 1
            r = xor(r, 0b1011 << (i - 3))
        end
    end
    return r
end
fpow(x, n) = n == 0 ? 1 : fmul(x, fpow(x, n - 1))
gmul(g, h) = (xor(g[1], h[1]), xor(g[2], h[2], fmul(g[1], fmul(h[1], h[1]))))
ginv(g) = (g[1], xor(g[2], fpow(g[1], 3)))

const V = [(a, b) for a in 0:7 for b in 0:7 if (a, b) != (0, 0)]
const idx = Dict(g => i for (i, g) in enumerate(V))
const S = Set(vcat([(a, 0) for a in 1:7], [(a, fpow(a, 3)) for a in 1:7]))
const n = length(V)
const A = falses(n, n)
for g in V, s in S
    h = gmul(g, s)
    if h != (0, 0)
        A[idx[g], idx[h]] = true
        A[idx[h], idx[g]] = true
    end
end
fails = 0
function check(name, ok)
    global fails
    println(ok ? "PASS " : "FAIL ", name)
    ok || (fails += 1)
end

check("63 vertices and 434 edges", n == 63 && length(S) == 14 && !any(A[i, i] for i in 1:n) && count(A) == 2 * 434)
seen = falses(n); seen[1] = true; frontier = [1]
while !isempty(frontier)
    v = pop!(frontier)
    for w in 1:n
        if A[v, w] && !seen[w]
            seen[w] = true; push!(frontier, w)
        end
    end
end
check("X is connected", all(seen))

mu(g) = (fmul(2, g[1]), fmul(fpow(2, 3), g[2]))
phi(g) = (fmul(g[1], g[1]), fmul(g[2], g[2]))
function is_aut(f)
    p = [idx[f(g)] for g in V]
    sort(p) == collect(1:n) && A[p, p] == A
end
check("mu is an automorphism", is_aut(mu))
check("phi is an automorphism", is_aut(phi))

trace(x) = xor(x, fmul(x, x), fpow(x, 4))
function cls(g)
    a, b = g
    a == 0 && return 1
    beta = fmul(b, fpow(fpow(a, 3), 6))
    beta == 0 && return 2
    beta == 1 && return 3
    return trace(beta) == 0 ? 4 : 5
end
function orbit(g)
    orb = Set([g]); todo = [g]
    while !isempty(todo)
        h = pop!(todo)
        for k in (mu(h), phi(h))
            if !(k in orb)
                push!(orb, k); push!(todo, k)
            end
        end
    end
    orb
end
ok = all(orbit(g) == Set(h for h in V if cls(h) == cls(g)) for g in V)
ok &= [count(g -> cls(g) == c, V) for c in 1:5] == [7, 7, 7, 21, 21]
check("<mu, phi> has the orbits P, O0, O1, O2, O3 of sizes 7, 7, 7, 21, 21", ok)

deg = vec(sum(A, dims = 2))
D13 = deg .== 13
check("the vertices of degree 13 are the elements of S", Set(V[D13]) == S)
com(x, z) = count(A[x, :] .& A[z, :])
comS(y, z) = count(A[y, :] .& A[z, :] .& D13)
function F(x)
    m = 0
    for y in 1:n, z in 1:n
        if A[x, y] && A[y, z] && z != x && !A[x, z] && comS(y, z) == 0 && com(x, z) == 2
            m += 1
        end
    end
    m
end
fval = [6, 15, 21, 8, 4]
check("F = 6, 15, 21, 8, 4 on P, O0, O1, O2, O3", all(F(idx[g]) == fval[cls(g)] for g in V))

function card_iso_ok(x)
    y = ginv(x)
    keep = [i for i in 1:n if V[i] != x]
    p = [idx[gmul(y, V[i])] for i in keep]
    target = [i for i in 1:n if V[i] != y]
    sort(p) == target && A[p, p] == A[keep, keep]
end
check("X - x is isomorphic to X - x^{-1} for every x", all(card_iso_ok(x) for x in V))
invc = [1, 3, 2, 5, 4]
check("inversion maps P, O0, O1, O2, O3 to P, O1, O0, O3, O2", all(cls(ginv(x)) == invc[cls(x)] for x in V))

dval = [24, 20, 20, 22, 22]
function card_d13(x)
    keep = [i for i in 1:n if i != x]
    count(vec(sum(A[keep, keep], dims = 2)) .== 13)
end
check("cards have 24, 20, 20, 22, 22 vertices of degree 13", all(card_d13(idx[g]) == dval[cls(g)] for g in V))

println(fails == 0 ? "orbits of Aut(X): 5, card types: 3" : "$fails checks failed")
exit(fails == 0 ? 0 : 1)
