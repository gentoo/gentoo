# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.3
ansi_term-0.9.0
atty-0.2.2
bitflags-0.9.1
bytecount-0.1.7
cfg-if-0.1.2
clap-2.26.0
crossbeam-0.2.10
encoding_rs-0.6.11
env_logger-0.4.3
fnv-1.0.5
fs2-0.4.2
kernel32-sys-0.2.2
lazy_static-0.2.8
libc-0.2.29
log-0.3.8
memchr-1.0.1
memmap-0.5.2
num_cpus-1.6.2
regex-0.2.2
regex-syntax-0.4.1
same-file-0.1.3
simd-0.1.1
simd-0.2.0
strsim-0.6.0
term_size-0.3.0
textwrap-0.7.0
thread_local-0.3.4
unicode-segmentation-1.2.0
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
void-1.0.2
walkdir-1.0.7
winapi-0.2.8
winapi-build-0.1.1
"

inherit cargo

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/rust-1.17"

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	cargo_src_install

	doman doc/rg.1
	dodoc CHANGELOG.md README.md

	insinto /usr/share/zsh/site-functions
	doins complete/_rg
}
