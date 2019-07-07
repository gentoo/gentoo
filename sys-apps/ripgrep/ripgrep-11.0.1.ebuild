# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.3
atty-0.2.11
autocfg-0.1.2
base64-0.10.1
bitflags-1.0.4
bstr-0.1.2
bytecount-0.5.1
byteorder-1.3.1
cc-1.0.35
cfg-if-0.1.7
clap-2.33.0
cloudabi-0.0.3
crossbeam-channel-0.3.8
crossbeam-utils-0.6.5
encoding_rs-0.8.17
encoding_rs_io-0.1.6
fnv-1.0.6
fuchsia-cprng-0.1.1
glob-0.3.0
globset-0.4.3
grep-0.2.4
grep-cli-0.1.2
grep-matcher-0.1.2
grep-pcre2-0.1.3
grep-printer-0.1.2
grep-regex-0.1.3
grep-searcher-0.1.4
ignore-0.4.7
itoa-0.4.3
lazy_static-1.3.0
libc-0.2.51
log-0.4.6
memchr-2.2.0
memmap-0.7.0
num_cpus-1.10.0
packed_simd-0.3.3
pcre2-0.2.0
pcre2-sys-0.2.0
pkg-config-0.3.14
proc-macro2-0.4.27
quote-0.6.12
rand-0.6.5
rand_chacha-0.1.1
rand_core-0.3.1
rand_core-0.4.0
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.3
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.54
redox_termios-0.1.1
regex-1.1.6
regex-automata-0.1.6
regex-syntax-0.6.6
remove_dir_all-0.5.1
ripgrep-11.0.1
ryu-0.2.7
same-file-1.0.4
serde-1.0.90
serde_derive-1.0.90
serde_json-1.0.39
smallvec-0.6.9
strsim-0.8.0
syn-0.15.31
tempfile-3.0.7
termcolor-1.0.4
termion-1.5.1
textwrap-0.11.0
thread_local-0.3.6
ucd-util-0.1.3
unicode-width-0.1.5
unicode-xid-0.1.0
utf8-ranges-1.0.2
walkdir-2.2.7
winapi-0.3.7
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="+man pcre"

DEPEND=""

RDEPEND="pcre? ( dev-libs/libpcre2 )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig
	>=virtual/rust-1.34
	man? ( app-text/asciidoc )"

QA_FLAGS_IGNORED="usr/bin/rg"

src_compile() {
	cargo_src_compile $(usex pcre "--features pcre2" "")
}

src_install() {
	cargo_src_install --path=. $(usex pcre "--features pcre2" "")

	# hack to find/install generated files
	# stamp file can be present in multiple dirs if we build additional features
	# so grab fist match only
	local BUILD_DIR="$(dirname $(find target/release -name ripgrep-stamp -print -quit))"

	if use man ; then
	    doman "${BUILD_DIR}"/rg.1
	fi

	newbashcomp "${BUILD_DIR}"/rg.bash rg

	insinto /usr/share/fish/vendor_completions.d
	doins "${BUILD_DIR}"/rg.fish

	insinto /usr/share/zsh/site-functions
	doins complete/_rg

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md
}
