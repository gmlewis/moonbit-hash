# gmlewis/zlib
[![check](https://github.com/gmlewis/moonbit-zlib/actions/workflows/check.yml/badge.svg)](https://github.com/gmlewis/moonbit-zlib/actions/workflows/check.yml)

This is a hash functions package based on Go's implementation:
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
moon 0.1.20241106 (79e45ae 2024-11-06) ~/.moon/bin/moon
moonc v0.1.20241106+8f17a3fc7 ~/.moon/bin/moonc
moonrun 0.1.20241106 (79e45ae 2024-11-06) ~/.moon/bin/moonrun
```

Use `moonup` to manage `moon` compiler versions:
https://github.com/chawyehsu/moonup