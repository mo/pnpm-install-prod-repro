# pnpm `install --prod` lifecycle-script repro

Run `./repro.sh` with pnpm 12.4.1.

The script creates a lockfile, then runs `pnpm install --prod --frozen-lockfile`.
It proves the bug when `dev-postinstall-ran` is created even though no copy of
`dev-postinstall-pkg` remains under `node_modules`.
