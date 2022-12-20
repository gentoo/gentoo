# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
aho-corasick-0.7.15
ansi_term-0.11.0
atty-0.2.14
bindgen-0.56.0
bitflags-1.2.1
cexpr-0.4.0
cfg-if-0.1.10
cfg-if-1.0.0
clang-sys-1.0.3
clap-2.33.3
diff-0.1.12
env_logger-0.8.1
glob-0.3.0
hermit-abi-0.1.17
humantime-2.0.1
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.80
libloading-0.6.5
log-0.4.11
memchr-2.3.4
nom-5.1.2
peeking_take_while-0.1.2
proc-macro2-1.0.24
quote-1.0.7
regex-1.4.2
regex-syntax-0.6.21
rustc-hash-1.1.0
shlex-0.1.1
strsim-0.8.0
termcolor-1.1.0
textwrap-0.11.0
thread_local-1.0.1
unicode-width-0.1.8
unicode-xid-0.2.1
vec_map-0.8.2
version_check-0.9.2
which-3.1.1
winapi-0.3.9
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
	cargo_src_install

	einstalldocs
}
