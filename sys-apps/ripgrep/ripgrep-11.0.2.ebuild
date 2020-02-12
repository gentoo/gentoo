# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.4
atty-0.2.13
base64-0.10.1
bitflags-1.1.0
bstr-0.2.6
bytecount-0.5.1
byteorder-1.3.2
c2-chacha-0.2.2
cc-1.0.38
cfg-if-0.1.9
clap-2.33.0
crossbeam-channel-0.3.9
crossbeam-utils-0.6.6
encoding_rs-0.8.17
encoding_rs_io-0.1.6
fnv-1.0.6
fs_extra-1.1.0
getrandom-0.1.7
glob-0.3.0
itoa-0.4.4
jemallocator-0.3.2
jemalloc-sys-0.3.2
lazy_static-1.3.0
libc-0.2.60
log-0.4.8
memchr-2.2.1
memmap-0.7.0
num_cpus-1.10.1
packed_simd-0.3.3
pcre2-0.2.1
pcre2-sys-0.2.2
pkg-config-0.3.15
ppv-lite86-0.2.5
proc-macro2-0.4.30
quote-0.6.13
rand-0.7.0
rand_chacha-0.2.1
rand_core-0.5.0
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.2.0
regex-automata-0.1.8
regex-syntax-0.6.10
remove_dir_all-0.5.2
ryu-1.0.0
same-file-1.0.5
serde-1.0.98
serde_derive-1.0.98
serde_json-1.0.40
strsim-0.8.0
syn-0.15.42
tempfile-3.1.0
termcolor-1.0.5
textwrap-0.11.0
thread_local-0.3.6
ucd-util-0.1.5
unicode-width-0.1.5
unicode-xid-0.1.0
utf8-ranges-1.0.3
walkdir-2.2.9
winapi-0.3.7
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD-2 Boost-1.0 || ( MIT Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~x86"
IUSE="+man pcre"

DEPEND=""

RDEPEND="pcre? ( dev-libs/libpcre2 )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig
	>=virtual/rust-1.34
	man? ( app-text/asciidoc )"

QA_FLAGS_IGNORED="usr/bin/rg"

src_compile() {
	# allow building on musl with dynamic linking support
	# https://github.com/BurntSushi/rust-pcre2/issues/7
	use elibc_musl && export PCRE2_SYS_STATIC=0
	cargo_src_compile $(usex pcre "--features pcre2" "")
}

src_install() {
	cargo_src_install $(usex pcre "--features pcre2" "")

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
