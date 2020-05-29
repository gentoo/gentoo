# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
atty-0.2.14
autocfg-1.0.0
base64-0.12.1
bitflags-1.2.1
bstr-0.2.12
bytecount-0.6.0
byteorder-1.3.4
cc-1.0.52
cfg-if-0.1.10
clap-2.33.0
crossbeam-channel-0.4.2
crossbeam-utils-0.7.2
encoding_rs-0.8.22
encoding_rs_io-0.1.7
fnv-1.0.6
fs_extra-1.1.0
glob-0.3.0
hermit-abi-0.1.12
itoa-0.4.5
jemalloc-sys-0.3.2
jemallocator-0.3.2
lazy_static-1.4.0
libc-0.2.69
log-0.4.8
maybe-uninit-2.0.0
memchr-2.3.3
memmap-0.7.0
num_cpus-1.13.0
packed_simd-0.3.3
pcre2-0.2.3
pcre2-sys-0.2.2
pkg-config-0.3.17
proc-macro2-1.0.12
quote-1.0.4
regex-1.3.7
regex-automata-0.1.9
regex-syntax-0.6.17
ryu-1.0.4
same-file-1.0.6
serde-1.0.107
serde_derive-1.0.107
serde_json-1.0.52
strsim-0.8.0
syn-1.0.19
termcolor-1.1.0
textwrap-0.11.0
thread_local-1.0.1
unicode-width-0.1.7
unicode-xid-0.2.0
walkdir-2.3.1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/BurntSushi/${PN}/releases/download/${PV}/${P}-x86_64-unknown-linux-musl.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD-2 Boost-1.0 || ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="pcre"

DEPEND=""

RDEPEND="pcre? ( dev-libs/libpcre2 )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig
"

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

	newbashcomp "${BUILD_DIR}"/rg.bash rg

	insinto /usr/share/fish/vendor_completions.d
	doins "${BUILD_DIR}"/rg.fish

	insinto /usr/share/zsh/site-functions
	doins complete/_rg

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md

	# we use a manpage from pre-compiled tarball, so we can skip dependency on asciidoctor
	doman "${WORKDIR}/${P}-x86_64-unknown-linux-musl/doc/rg.1"
}
