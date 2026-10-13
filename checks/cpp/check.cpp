// Independent check of the answer to Kourovka Notebook Problem 20.71(b), in C++.
// F8 = F2[t]/(t^3 + t + 1) through a multiplication table built by shift and reduce.
// The Suzuki 2-group H of order 64: (a, b)(c, d) = (a + c, b + d + a c^2), coded 8a + b.
// Y = Cay(H, S), S = {(a, 0), (a, a^3) : a != 0}, X = Y - (0, 0).
// Same five claims as check.py; adjacency is kept as bitsets.
#include <array>
#include <bitset>
#include <cstdio>
#include <functional>
#include <numeric>
#include <string>
#include <vector>

using Row = std::bitset<64>;
static std::array<std::array<int, 8>, 8> M;
static std::array<Row, 64> adj;
static int fails = 0;

static int xtime(int x) { x <<= 1; return (x & 8) ? x ^ 11 : x; }
static int fpow(int x, int n) { int r = 1; while (n--) r = M[r][x]; return r; }
static int gmul(int g, int h) {
  int a = g >> 3, b = g & 7, c = h >> 3, d = h & 7;
  return ((a ^ c) << 3) | (b ^ d ^ M[a][M[c][c]]);
}
static int ginv(int g) { return (g & 56) | ((g & 7) ^ fpow(g >> 3, 3)); }
static void check(const std::string& name, bool ok) {
  std::printf("%s %s\n", ok ? "PASS" : "FAIL", name.c_str());
  if (!ok) ++fails;
}
static int cls(int g) {
  int a = g >> 3, b = g & 7;
  if (a == 0) return 0;
  int beta = M[b][fpow(fpow(a, 3), 6)];
  if (beta == 0) return 1;
  if (beta == 1) return 2;
  int tr = beta ^ M[beta][beta] ^ fpow(beta, 4);
  return tr == 0 ? 3 : 4;
}

int main() {
  for (int x = 0; x < 8; ++x) {
    int p = x;  // p = x t^i
    for (int i = 0; i < 8; ++i) M[x][i] = 0;
    for (int i = 0; i < 3; ++i) {
      for (int y = 0; y < 8; ++y) if ((y >> i) & 1) M[x][y] ^= p;
      p = xtime(p);
    }
  }
  Row S;
  for (int a = 1; a < 8; ++a) { S.set(a << 3); S.set((a << 3) | fpow(a, 3)); }
  Row V; for (int g = 1; g < 64; ++g) V.set(g);
  for (int g = 1; g < 64; ++g)
    for (int s = 0; s < 64; ++s)
      if (S[s]) { int h = gmul(g, s); if (h) { adj[g].set(h); adj[h].set(g); } }
  std::size_t ne = 0; bool loopless = true;
  for (int g = 1; g < 64; ++g) { ne += adj[g].count(); loopless = loopless && !adj[g][g]; }
  check("63 vertices and 434 edges", S.count() == 14 && loopless && ne == 2 * 434);
  Row seen; seen.set(1);
  for (bool grew = true; grew;) {
    Row nxt = seen;
    for (int g = 1; g < 64; ++g) if (seen[g]) nxt |= adj[g];
    grew = nxt != seen; seen = nxt;
  }
  check("X is connected", seen == V);
  std::function<int(int)> mu = [](int g) { return (M[2][g >> 3] << 3) | M[fpow(2, 3)][g & 7]; };
  std::function<int(int)> phi = [](int g) { return (M[g >> 3][g >> 3] << 3) | M[g & 7][g & 7]; };
  auto is_aut = [&](const std::function<int(int)>& f) {
    Row img;
    for (int g = 1; g < 64; ++g) img.set(f(g));
    if (img != V) return false;
    for (int g = 1; g < 64; ++g)
      for (int h = 1; h < 64; ++h)
        if (adj[f(g)][f(h)] != adj[g][h]) return false;
    return true;
  };
  check("mu is an automorphism", is_aut(mu));
  check("phi is an automorphism", is_aut(phi));
  // orbits of <mu, phi> by closure from each vertex
  bool ok = true;
  std::array<int, 5> size{};
  for (int g = 1; g < 64; ++g) {
    ++size[cls(g)];
    Row orb; orb.set(g);
    for (bool grew = true; grew;) {
      Row nxt = orb;
      for (int h = 1; h < 64; ++h) if (orb[h]) { nxt.set(mu(h)); nxt.set(phi(h)); }
      grew = nxt != orb; orb = nxt;
    }
    for (int h = 1; h < 64; ++h) if (orb[h] != (cls(h) == cls(g))) ok = false;
  }
  ok = ok && size == std::array<int, 5>{7, 7, 7, 21, 21};
  check("<mu, phi> has the orbits P, O0, O1, O2, O3 of sizes 7, 7, 7, 21, 21", ok);
  Row D13;
  for (int g = 1; g < 64; ++g) if (adj[g].count() == 13) D13.set(g);
  check("the vertices of degree 13 are the elements of S", D13 == S);
  const std::array<int, 5> fval{6, 15, 21, 8, 4}, dval{24, 20, 20, 22, 22};
  ok = true;
  for (int x = 1; x < 64; ++x) {
    int n = 0;
    for (int y = 1; y < 64; ++y) if (adj[x][y])
      for (int z = 1; z < 64; ++z)
        if (adj[y][z] && z != x && !adj[x][z] && (adj[y] & adj[z] & D13).none() &&
            (adj[x] & adj[z]).count() == 2) ++n;
    if (n != fval[cls(x)]) ok = false;
  }
  check("F = 6, 15, 21, 8, 4 on P, O0, O1, O2, O3", ok);
  ok = true;
  for (int x = 1; x < 64; ++x) {
    int y = ginv(x);
    std::array<int, 64> f{};
    Row img;
    for (int u = 1; u < 64; ++u) if (u != x) { f[u] = gmul(y, u); img.set(f[u]); }
    Row target = V; target.reset(y);
    if (img != target) ok = false;
    for (int u = 1; u < 64; ++u) for (int w = 1; w < 64; ++w)
      if (u != x && w != x && adj[f[u]][f[w]] != adj[u][w]) ok = false;
  }
  check("X - x is isomorphic to X - x^{-1} for every x", ok);
  const std::array<int, 5> invc{0, 2, 1, 4, 3};
  ok = true;
  for (int x = 1; x < 64; ++x) if (cls(ginv(x)) != invc[cls(x)]) ok = false;
  check("inversion maps P, O0, O1, O2, O3 to P, O1, O0, O3, O2", ok);
  ok = true;
  for (int x = 1; x < 64; ++x) {
    int n = 0;
    for (int u = 1; u < 64; ++u) {
      if (u == x) continue;
      Row r = adj[u]; r.reset(x);
      if (r.count() == 13) ++n;
    }
    if (n != dval[cls(x)]) ok = false;
  }
  check("cards have 24, 20, 20, 22, 22 vertices of degree 13", ok);
  if (fails) std::printf("%d checks failed\n", fails);
  else std::printf("orbits of Aut(X): 5, card types: 3\n");
  return fails ? 1 : 0;
}
