# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.6
ansi_term-0.11.0
atty-0.2.11
bitflags-1.0.3
bytecount-0.3.1
cfg-if-0.1.4
clap-2.32.0
crossbeam-0.3.2
encoding_rs-0.8.4
encoding_rs_io-0.1.1
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
glob-0.2.11
globset-0.4.1
grep-0.1.9
ignore-0.4.3
lazy_static-1.0.2
libc-0.2.42
log-0.4.3
memchr-2.0.1
memmap-0.6.2
num_cpus-1.8.0
rand-0.4.2
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.2
regex-syntax-0.6.2
remove_dir_all-0.5.1
ripgrep-0.9.0
same-file-1.0.2
simd-0.2.2
strsim-0.7.0
tempdir-0.3.7
termcolor-1.0.1
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.5
ucd-util-0.1.1
unicode-width-0.1.5
unreachable-1.0.0
utf8-ranges-1.0.0
void-1.0.2
walkdir-2.1.4
winapi-0.3.5
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.0
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/rust-1.20
	doc? ( app-text/asciidoc )"

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	cargo_src_install

	# hacks to find/install generated files
	BUILD_DIR=$(dirname $(find target/release -name rg.bash))
	if use doc ; then
	    doman "${BUILD_DIR}"/rg.1
	fi
	newbashcomp "${BUILD_DIR}"/rg.bash rg

	dodoc CHANGELOG.md README.md

	insinto /usr/share/zsh/site-functions
	doins complete/_rg
}
