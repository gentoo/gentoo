# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.4
ansi_term-0.10.2
atty-0.2.6
bitflags-1.0.1
bytecount-0.3.1
cfg-if-0.1.2
clap-2.30.0
crossbeam-0.3.2
encoding_rs-0.7.2
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
glob-0.2.11
globset-0.3.0
grep-0.1.8
ignore-0.4.1
lazy_static-1.0.0
libc-0.2.36
log-0.4.1
memchr-2.0.1
memmap-0.6.2
num_cpus-1.8.0
rand-0.3.22
rand-0.4.2
redox_syscall-0.1.37
redox_termios-0.1.1
regex-0.2.6
regex-syntax-0.4.2
ripgrep-0.8.1
same-file-1.0.2
simd-0.2.1
strsim-0.7.0
tempdir-0.3.5
termcolor-0.3.5
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.5
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
void-1.0.2
walkdir-2.1.4
winapi-0.3.4
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/rust-1.20
	app-text/asciidoc"

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	cargo_src_install

	# hacks to find/install generated files
	BUILD_DIR=$(dirname $(find target/release -name rg.1))
	doman "${BUILD_DIR}"/rg.1
	dobashcomp "${BUILD_DIR}"/rg.bash

	dodoc CHANGELOG.md README.md

	insinto /usr/share/zsh/site-functions
	doins complete/_rg
}
