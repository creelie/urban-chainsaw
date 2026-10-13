/* Independent check of the answer to Kourovka Notebook Problem 20.71(b), in C.
   F8 = F2[t]/(t^3 + t + 1), multiplied through discrete logarithms to the base t.
   The Suzuki 2-group H of order 64 has elements (a, b), coded 8a + b, with
   (a, b)(c, d) = (a + c, b + d + a c^2).  Y = Cay(H, S) with
   S = {(a, 0), (a, a^3) : a != 0}, and X = Y - (0, 0).
   Checks: 63 vertices, 434 edges, connected; mu and phi are automorphisms with
   the orbits P, O0, O1, O2, O3; the invariant F is 6, 15, 21, 8, 4 on them;
   X - x is isomorphic to X - x^{-1} by left multiplication; the cards have
   24, 20, 20, 22, 22 vertices of degree 13.  Hence 5 orbits and 3 card types. */
#include <stdio.h>
#include <string.h>

static int EXP[14], LOG[8];
static int fmul(int x, int y) { return (x && y) ? EXP[LOG[x] + LOG[y]] : 0; }
static int fpow(int x, int n) { int r = 1; while (n--) r = fmul(r, x); return r; }
static int gmul(int g, int h) {
  int a = g >> 3, b = g & 7, c = h >> 3, d = h & 7;
  return ((a ^ c) << 3) | (b ^ d ^ fmul(a, fmul(c, c)));
}
static int ginv(int g) { int a = g >> 3, b = g & 7; return (a << 3) | (b ^ fpow(a, 3)); }
static int A[64][64], fails;

static void check(const char *name, int ok) {
  printf("%s %s\n", ok ? "PASS" : "FAIL", name);
  if (!ok) fails++;
}
static int deg(int u, int skip) { int d = 0; for (int w = 1; w < 64; w++) if (w != skip && A[u][w]) d++; return d; }
static int is_aut(int (*f)(int)) {
  int hit[64] = {0};
  for (int g = 1; g < 64; g++) { int y = f(g); if (y == 0 || hit[y]) return 0; hit[y] = 1; }
  for (int g = 1; g < 64; g++) for (int h = 1; h < 64; h++) if (A[f(g)][f(h)] != A[g][h]) return 0;
  return 1;
}
static int mu(int g) { return (fmul(2, g >> 3) << 3) | fmul(fpow(2, 3), g & 7); }
static int phi(int g) { return (fmul(g >> 3, g >> 3) << 3) | fmul(g & 7, g & 7); }
static int trace(int x) { return x ^ fmul(x, x) ^ fpow(x, 4); }
static int cls(int g) {
  int a = g >> 3, b = g & 7;
  if (a == 0) return 0;
  int beta = fmul(b, fpow(fpow(a, 3), 6));
  if (beta == 0) return 1;
  if (beta == 1) return 2;
  return trace(beta) == 0 ? 3 : 4;
}
static int com(int x, int z) { int n = 0; for (int w = 1; w < 64; w++) if (A[x][w] && A[z][w]) n++; return n; }
static int D13[64];
static int comS(int y, int z) { int n = 0; for (int w = 1; w < 64; w++) if (A[y][w] && A[z][w] && D13[w]) n++; return n; }
static int F(int x) {
  int n = 0;
  for (int y = 1; y < 64; y++) if (A[x][y])
    for (int z = 1; z < 64; z++)
      if (A[y][z] && z != x && !A[x][z] && comS(y, z) == 0 && com(x, z) == 2) n++;
  return n;
}
static int parent[64];
static int find(int g) { while (parent[g] != g) g = parent[g] = parent[parent[g]]; return g; }

int main(void) {
  for (int i = 0, x = 1; i < 14; i++) { EXP[i] = x; if (i < 7) LOG[x] = i; x <<= 1; if (x & 8) x ^= 11; }
  int S[64] = {0};
  for (int a = 1; a < 8; a++) { S[a << 3] = 1; S[(a << 3) | fpow(a, 3)] = 1; }
  int ns = 0; for (int s = 0; s < 64; s++) ns += S[s];
  for (int g = 1; g < 64; g++) for (int s = 0; s < 64; s++) if (S[s]) {
    int h = gmul(g, s);
    if (h) { A[g][h] = 1; A[h][g] = 1; }
  }
  int ne = 0, loops = 0;
  for (int g = 1; g < 64; g++) { loops += A[g][g]; for (int h = g + 1; h < 64; h++) ne += A[g][h]; }
  check("63 vertices and 434 edges", ns == 14 && loops == 0 && ne == 434);
  int seen[64] = {0}, st[64], sp = 0, nseen = 1; seen[1] = 1; st[sp++] = 1;
  while (sp) { int g = st[--sp]; for (int h = 1; h < 64; h++) if (A[g][h] && !seen[h]) { seen[h] = 1; nseen++; st[sp++] = h; } }
  check("X is connected", nseen == 63);
  check("mu is an automorphism", is_aut(mu));
  check("phi is an automorphism", is_aut(phi));
  for (int g = 0; g < 64; g++) parent[g] = g;
  for (int g = 1; g < 64; g++) { parent[find(g)] = find(mu(g)); parent[find(g)] = find(phi(g)); }
  int ok = 1, size[5] = {0};
  for (int g = 1; g < 64; g++) { size[cls(g)]++; for (int h = 1; h < 64; h++) if ((find(g) == find(h)) != (cls(g) == cls(h))) ok = 0; }
  ok = ok && size[0] == 7 && size[1] == 7 && size[2] == 7 && size[3] == 21 && size[4] == 21;
  check("<mu, phi> has the orbits P, O0, O1, O2, O3 of sizes 7, 7, 7, 21, 21", ok);
  ok = 1;
  for (int g = 1; g < 64; g++) { D13[g] = deg(g, -1) == 13; if (D13[g] != S[g]) ok = 0; }
  check("the vertices of degree 13 are the elements of S", ok);
  const int fval[5] = {6, 15, 21, 8, 4}, dval[5] = {24, 20, 20, 22, 22};
  ok = 1; for (int g = 1; g < 64; g++) if (F(g) != fval[cls(g)]) ok = 0;
  check("F = 6, 15, 21, 8, 4 on P, O0, O1, O2, O3", ok);
  ok = 1;
  for (int x = 1; x < 64; x++) {
    int y = ginv(x), hit[64] = {0}, f[64];
    for (int u = 1; u < 64; u++) if (u != x) {
      f[u] = gmul(y, u);
      if (f[u] == 0 || f[u] == y || hit[f[u]]) ok = 0; else hit[f[u]] = 1;
    }
    for (int u = 1; u < 64; u++) for (int w = 1; w < 64; w++)
      if (u != x && w != x && A[f[u]][f[w]] != A[u][w]) ok = 0;
  }
  check("X - x is isomorphic to X - x^{-1} for every x", ok);
  const int invc[5] = {0, 2, 1, 4, 3};
  ok = 1; for (int x = 1; x < 64; x++) if (cls(ginv(x)) != invc[cls(x)]) ok = 0;
  check("inversion maps P, O0, O1, O2, O3 to P, O1, O0, O3, O2", ok);
  ok = 1;
  for (int x = 1; x < 64; x++) {
    int n = 0; for (int u = 1; u < 64; u++) if (u != x && deg(u, x) == 13) n++;
    if (n != dval[cls(x)]) ok = 0;
  }
  check("cards have 24, 20, 20, 22, 22 vertices of degree 13", ok);
  if (fails) printf("%d checks failed\n", fails); else printf("orbits of Aut(X): 5, card types: 3\n");
  return fails ? 1 : 0;
}
