# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
approx-0.3.2
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
bitflags-1.2.1
bstr-0.2.13
byteorder-1.3.4
cfg-if-0.1.10
clap-2.33.3
cloudabi-0.0.3
colored-2.0.0
console-0.12.0
csv-1.1.3
csv-core-0.1.10
encode_unicode-0.3.6
fuchsia-cprng-0.1.1
getrandom-0.1.15
hermit-abi-0.1.17
indicatif-0.15.0
itoa-0.4.6
lazy_static-1.4.0
libc-0.2.79
memchr-2.3.3
num-0.2.1
number_prefix-0.3.0
num-bigint-0.2.6
num-complex-0.2.4
num-integer-0.1.43
num-iter-0.1.41
num-rational-0.2.4
num-traits-0.2.12
ppv-lite86-0.2.9
proc-macro2-1.0.24
quote-1.0.7
rand-0.6.5
rand-0.7.3
rand_chacha-0.1.1
rand_chacha-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
regex-1.4.1
regex-automata-0.1.9
regex-syntax-0.6.20
rust_decimal-1.8.1
ryu-1.0.5
serde-1.0.117
serde_derive-1.0.117
serde_json-1.0.59
statistical-1.0.0
strsim-0.8.0
syn-1.0.44
terminal_size-0.1.13
termios-0.3.3
term_size-0.3.2
textwrap-0.11.0
unicode-width-0.1.8
unicode-xid-0.2.1
vec_map-0.8.2
version_check-0.9.2
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A command-line benchmarking tool (runs other benchmarks)"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install
	doman doc/hyperfine.1
	einstalldocs
}
