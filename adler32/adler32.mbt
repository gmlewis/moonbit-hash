///|
/// This file is based on the Go implementation found here:
/// https://cs.opensource.google/go/go/+/refs/tags/go1.23.3:src/hash/adler32/adler32.go
/// which has the copyright notice:
/// Copyright 2009 The Go Authors. All rights reserved.
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file.
///
/// Package adler32 implements the Adler-32 checksum.
///
/// It is defined in RFC 1950:
///
///	Adler-32 is composed of two sums accumulated per byte: s1 is
///	the sum of all bytes, s2 is the sum of all s1 values. Both sums
///	are done modulo 65521. s1 is initialized to 1, s2 to zero.  The
///	Adler-32 checksum is stored as s2*65536 + s1 in most-
///	significant-byte first (network) order.
typealias @io.Slice

///|
typealias @io.IOError

///|
/// MOD is the largest prime that is less than 65536.
const MOD = 65521U

///|
/// NMAX is the largest n such that
/// 255 * n * (n+1) / 2 + (n+1) * (MOD-1) <= 2^32-1.
/// It is mentioned in RFC 1950 (search for "5552").
const NMAX = 5552

///|
/// The size of an Adler-32 checksum in bytes.
const SIZE = 4

///|
/// Digest represents the partial evaluation of a checksum.
/// The low 16 bits are s1, the high 16 bits are s2.
struct Digest {
  mut d : UInt
}

///|
pub impl @hash.Hash32 for Digest with reset(self) {
  self.d = 1
}

///|
/// New returns a new hash.Hash32 computing the Adler-32 checksum. Its
/// Sum method will lay the value out in big-endian byte order. The
/// returned Hash32 also implements [encoding.BinaryMarshaler] and
/// [encoding.BinaryUnmarshaler] to marshal and unmarshal the internal
/// state of the hash.
pub fn new() -> Digest {
  { d: 1 }
}

///|
/// Digest implements the @hash.Hash32 trait.
let _interface : &@hash.Hash32 = new()

///|
pub impl @hash.Hash32 for Digest with size(_self) {
  return SIZE
}

///|
pub impl @hash.Hash32 for Digest with block_size(_self) {
  return 4
}

///|
let magic = b"adl\x01"

///|
const MARSHALED_SIZE = 8 // magic.length() + 4

///|
pub fn marshal_binary(self : Digest) -> (Slice[Byte], IOError?) {
  let b = [
    b'a',
    b'd',
    b'l',
    b'\x01',
    (self.d >> 24).to_byte(),
    (self.d >> 16).to_byte(),
    (self.d >> 8).to_byte(),
    self.d.to_byte(),
  ]
  (Slice::new(b), None)
}

///|
fn be_uint32(b : Slice[Byte]) -> UInt {
  (b[0].to_uint() << 24) |
  (b[1].to_uint() << 16) |
  (b[2].to_uint() << 8) |
  b[3].to_uint()
}

///|
fn has_magic(b : Slice[Byte]) -> Bool {
  b[0] == magic[0] && b[1] == magic[1] && b[2] == magic[2] && b[3] == magic[3]
}

///|
pub fn unmarshal_binary(self : Digest, b : Slice[Byte]) -> IOError? {
  if b.length() < magic.length() || not(has_magic(b)) {
    return Some(IOError("hash/adler32: invalid hash state identifier"))
  }
  if b.length() != MARSHALED_SIZE {
    return Some(IOError("hash/adler32: invalid hash state size"))
  }
  self.d = be_uint32(b[magic.length():])
  None
}

///|
/// Add p to the running checksum d.
pub impl @hash.Hash32 for Digest with write(self, p) {
  let mut s1 = self.d & 0xffff
  let mut s2 = self.d >> 16
  let mut p = p
  while p.length() > 0 {
    let mut q : Slice[Byte] = Slice::new([])
    if p.length() > NMAX {
      q = p[NMAX:]
      p = p[:NMAX]
    }
    while p.length() >= 4 {
      s1 += p[0].to_uint()
      s2 += s1
      s1 += p[1].to_uint()
      s2 += s1
      s1 += p[2].to_uint()
      s2 += s1
      s1 += p[3].to_uint()
      s2 += s1
      p = p[4:]
    }
    for x in p {
      s1 += x.to_uint()
      s2 += s1
    }
    s1 %= MOD
    s2 %= MOD
    p = q
  }
  self.d = (s2 << 16) | s1
  (p.length(), None)
}

///|
pub impl @hash.Hash32 for Digest with sum32(self) {
  self.d
}

///|
pub impl @hash.Hash32 for Digest with sum(self, p) {
  let b = Slice::new([
    (self.d >> 24).to_byte(),
    (self.d >> 16).to_byte(),
    (self.d >> 8).to_byte(),
    self.d.to_byte(),
  ])
  p.append(b)
}

///|
/// checksum returns the Adler-32 checksum of data.
pub fn checksum(data : Slice[Byte]) -> UInt {
  let d = { d: 1 }
  let _ = d.write(data)
  d.d
}
