# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
aho-corasick-0.5.3
aho-corasick-0.7.18
ansi_term-0.12.1
atty-0.2.14
autocfg-1.1.0
bitflags-1.3.2
block-0.1.6
cc-1.0.73
cexpr-0.6.0
cfg-if-1.0.0
clang-sys-1.3.3
clap-2.34.0
clap-3.2.12
clap_lex-0.2.4
diff-0.1.12
either-1.6.1
env_logger-0.3.5
env_logger-0.9.0
fuchsia-cprng-0.1.1
getrandom-0.2.3
glob-0.3.0
hashbrown-0.12.2
hermit-abi-0.1.19
humantime-2.1.0
indexmap-1.9.1
kernel32-sys-0.2.2
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.126
libloading-0.6.7
libloading-0.7.0
log-0.3.9
log-0.4.14
malloc_buf-0.0.6
memchr-0.1.11
memchr-2.5.0
minimal-lexical-0.1.4
nom-7.0.0
objc-0.2.7
os_str_bytes-6.2.0
peeking_take_while-0.1.2
ppv-lite86-0.2.10
proc-macro2-1.0.43
quickcheck-0.4.1
quote-1.0.9
rand-0.3.23
rand-0.4.6
rand-0.8.4
rand_chacha-0.3.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.6.3
rand_hc-0.3.1
rdrand-0.4.0
redox_syscall-0.2.9
regex-0.1.80
regex-1.5.5
regex-syntax-0.3.9
regex-syntax-0.6.25
remove_dir_all-0.5.3
rustc-hash-1.1.0
shlex-1.0.0
strsim-0.10.0
strsim-0.8.0
syn-1.0.99
tempdir-0.3.7
tempfile-3.2.0
termcolor-1.1.3
textwrap-0.11.0
textwrap-0.15.0
thread-id-2.0.0
thread_local-0.2.7
unicode-ident-1.0.3
unicode-width-0.1.10
utf8-ranges-0.1.3
vec_map-0.8.2
version_check-0.9.3
wasi-0.10.2+wasi-snapshot-preview1
which-4.2.2
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit rust-toolchain cargo

DESCRIPTION="Automatically generates Rust FFI bindings to C (and some C++) libraries"
HOMEPAGE="https://rust-lang.github.io/rust-bindgen"
SRC_URI="https://github.com/rust-lang/rust-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND="virtual/rust[rustfmt]"
RDEPEND="${DEPEND}
	sys-devel/clang:="

QA_FLAGS_IGNORED="usr/bin/bindgen"

S="${WORKDIR}/rust-${P}"

src_test () {
	# required by clang during tests
	local -x TARGET="$(rust_abi)"

	cargo_src_test --bins --lib
}

src_install () {
	cargo_src_install --path "${S}/bindgen-cli"

	einstalldocs
}
