# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.18
atty-0.2.14
base64-0.13.0
bitflags-1.2.1
bstr-0.2.16
bytecount-0.6.2
cc-1.0.68
cfg-if-0.1.10
cfg-if-1.0.0
clap-2.33.3
crossbeam-channel-0.5.1
crossbeam-utils-0.8.5
encoding_rs-0.8.28
encoding_rs_io-0.1.7
fnv-1.0.7
fs_extra-1.2.0
glob-0.3.0
hermit-abi-0.1.18
itoa-0.4.7
jemallocator-0.3.2
jemalloc-sys-0.3.2
jobserver-0.1.22
lazy_static-1.4.0
libc-0.2.97
libm-0.1.4
log-0.4.14
memchr-2.4.0
memmap2-0.3.0
num_cpus-1.13.0
once_cell-1.7.2
packed_simd_2-0.3.5
pcre2-0.2.3
pcre2-sys-0.2.5
pkg-config-0.3.19
proc-macro2-1.0.27
quote-1.0.9
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
ryu-1.0.5
same-file-1.0.6
serde-1.0.126
serde_derive-1.0.126
serde_json-1.0.64
strsim-0.8.0
syn-1.0.73
termcolor-1.1.2
textwrap-0.11.0
thread_local-1.1.3
unicode-width-0.1.8
unicode-xid-0.2.2
walkdir-2.3.2
winapi-0.3.9
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
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
IUSE="+pcre"

DEPEND=""

RDEPEND="pcre? ( dev-libs/libpcre2:= )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/rg"

src_configure() {
	# allow building on musl with dynamic linking support
	# https://github.com/BurntSushi/rust-pcre2/issues/7
	use pcre && export PCRE2_SYS_STATIC=0
	myfeatures=( $(usex pcre pcre2 '') )
	cargo_src_configure
}

src_install() {
	cargo_src_install

	# hack to find/install generated files
	# stamp file can be present in multiple dirs if we build additional features
	# so grab fist match only
	local BUILD_DIR="$(dirname $(find target/ -name ripgrep-stamp -print -quit))"

	newbashcomp "${BUILD_DIR}"/rg.bash rg

	insinto /usr/share/fish/vendor_completions.d
	doins "${BUILD_DIR}"/rg.fish

	insinto /usr/share/zsh/site-functions
	doins complete/_rg

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md

	# we use a manpage from pre-compiled tarball, so we can skip dependency on asciidoctor
	doman "${WORKDIR}/${P}-x86_64-unknown-linux-musl/doc/rg.1"
}
