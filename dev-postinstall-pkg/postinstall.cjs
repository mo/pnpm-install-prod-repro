const fs = require('node:fs')
const path = require('node:path')

const projectDir = process.env.INIT_CWD
if (!projectDir) throw new Error('INIT_CWD was not set by pnpm')

const markerPath = path.join(projectDir, 'dev-postinstall-ran')
fs.writeFileSync(markerPath, 'A devDependency postinstall script ran.\n')
console.log(`BUG REPRO: wrote ${markerPath}`)
