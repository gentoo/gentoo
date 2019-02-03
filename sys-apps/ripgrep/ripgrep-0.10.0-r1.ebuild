# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.8
arrayvec-0.4.7
atty-0.2.11
base64-0.9.2
bitflags-1.0.4
bytecount-0.3.2
byteorder-1.2.6
cc-1.0.24
cfg-if-0.1.5
clap-2.32.0
cloudabi-0.0.3
crossbeam-channel-0.2.4
crossbeam-epoch-0.5.2
crossbeam-utils-0.5.0
encoding_rs-0.8.6
encoding_rs_io-0.1.2
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
glob-0.2.11
globset-0.4.2
grep-0.2.2
grep-cli-0.1.1
grep-matcher-0.1.1
grep-pcre2-0.1.1
grep-printer-0.1.1
grep-regex-0.1.1
grep-searcher-0.1.1
ignore-0.4.4
itoa-0.4.2
lazy_static-1.1.0
libc-0.2.43
lock_api-0.1.3
log-0.4.5
memchr-2.0.2
memmap-0.6.2
memoffset-0.2.1
nodrop-0.1.12
num_cpus-1.8.0
owning_ref-0.3.3
parking_lot-0.6.4
parking_lot_core-0.3.0
pcre2-0.1.0
pcre2-sys-0.1.1
pkg-config-0.3.14
proc-macro2-0.4.18
quote-0.6.8
rand-0.4.3
rand-0.5.5
rand_core-0.2.1
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.5
regex-syntax-0.6.2
remove_dir_all-0.5.1
ripgrep-0.10.0
ryu-0.2.6
safemem-0.2.0
same-file-1.0.3
scopeguard-0.3.3
serde-1.0.77
serde_derive-1.0.77
serde_json-1.0.27
simd-0.2.2
smallvec-0.6.5
stable_deref_trait-1.1.1
strsim-0.7.0
syn-0.15.1
tempdir-0.3.7
termcolor-1.0.3
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
ucd-util-0.1.1
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
utf8-ranges-1.0.1
version_check-0.1.4
void-1.0.2
walkdir-2.2.5
winapi-0.3.5
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
"

inherit cargo bash-completion-r1

DESCRIPTION="a search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="+man pcre"

RDEPEND="pcre? ( dev-libs/libpcre2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=virtual/rust-1.20
	man? ( app-text/asciidoc )"

QA_FLAGS_IGNORED="usr/bin/rg"

src_test() {
	cargo test || die "tests failed"
}

src_compile() {
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
