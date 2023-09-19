# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.18
autocfg-1.0.1
bstr-0.2.16
byteorder-1.4.3
cfg-if-0.1.10
cfg-if-1.0.0
chan-0.1.23
csv-1.1.6
csv-core-0.1.10
csv-index-0.1.6
docopt-1.1.1
filetime-0.1.15
fuchsia-cprng-0.1.1
hermit-abi-0.1.18
itoa-0.4.7
lazy_static-1.4.0
libc-0.2.97
log-0.4.14
memchr-2.4.0
num-traits-0.2.14
num_cpus-1.13.0
proc-macro2-1.0.27
quickcheck-0.6.2
quote-1.0.9
rand-0.3.23
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.57
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
ryu-1.0.5
serde-1.0.126
serde_derive-1.0.126
streaming-stats-0.2.3
strsim-0.10.0
syn-1.0.73
tabwriter-1.2.1
threadpool-1.8.1
unicode-width-0.1.8
unicode-xid-0.2.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A fast CSV command line toolkit written in Rust"
HOMEPAGE="https://github.com/BurntSushi/xsv"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/BurntSushi/xsv/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( MIT Unlicense ) Apache-2.0 Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="${RUST_DEPEND}"

src_prepare() {
	rm Cargo.lock || die "Failed to remove stale Cargo.lock"
	default
}

src_install() {
	cargo_src_install
	dodoc BENCHMARKS.md README.md
}
