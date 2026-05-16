# StarBook Bootstrap

Public bootstrap for installing StarBook from the private `starbook-agent-memory` repository.

It only clones or updates the private repo and then delegates to StarBook's real installer. Access to the private repo is still required through standard Git HTTPS credentials.

## Install

```bash
cd /path/to/project
curl -fsSL https://raw.githubusercontent.com/cuizhu12138/starbook-bootstrap/main/install.sh | sh -s -- --project-dir "$PWD"
```

## Options

```bash
--repo-url <url>      Private StarBook repo URL.
--version <tag>      StarBook tag, default v0.3.6.
--install-dir <dir>  Local clone directory.
```
