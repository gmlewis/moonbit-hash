# gmlewis/hash
[![check](https://github.com/gmlewis/moonbit-hash/actions/workflows/check.yml/badge.svg)](https://github.com/gmlewis/moonbit-hash/actions/workflows/check.yml)

This package provides hash functions based on Go's implementation:
https://cs.opensource.google/go/go/+/refs/tags/go1.23.3:src/hash/hash.go;l=26
which has the copyright notice:

```
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
```

## Status

The code has been updated to support compiler:

```bash
$ moon version --all
moon 0.1.20250210 (da67b3c 2025-02-10) ~/.moon/bin/moon
moonc v0.1.20250210+7be093d1f ~/.moon/bin/moonc
moonrun 0.1.20250210 (da67b3c 2025-02-10) ~/.moon/bin/moonrun
```

Use `moonup` to manage `moon` compiler versions:
https://github.com/chawyehsu/moonup
