# pnpm `install --prod` lifecycle-script repro

This project reproduces a pnpm 12.4.1 bug: a production-only install executes
an allowed lifecycle script from a package declared solely in `devDependencies`.

## Expected behavior

`pnpm install --prod --frozen-lockfile` should omit the complete
`devDependencies` graph. In particular, it should neither install nor run a
`postinstall` script from a dev-only package.

## Actual behavior

pnpm 12.4.1 runs the `postinstall` script of `dev-postinstall-pkg`, even though
that package is a direct `devDependency`. Once installation finishes, the
package itself is absent from `node_modules`.

This suggests that pnpm filters the final dependency tree correctly, but applies
its lifecycle-script build phase to a broader dependency graph first. On a real
deployment this can needlessly download packages and execute dev-only code with
the deployment user's permissions.

## Reproduce

Run with pnpm 12.4.1:

```sh
./repro.sh
```

The script:

1. Generates a frozen lockfile without running scripts.
2. Runs `pnpm install --prod --frozen-lockfile`.
3. Confirms that the dev package's `postinstall` created
   `dev-postinstall-ran`.
4. Confirms that no copy of `dev-postinstall-pkg` remains under
   `node_modules`.

`pnpm-workspace.yaml` explicitly allows the dev package's build script. That
does not make it a production dependency; it only exposes the incorrect script
selection during the production install.
