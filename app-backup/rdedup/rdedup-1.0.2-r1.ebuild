# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.5.3
	argparse@0.2.2
	cc@1.0.99
	env_logger@0.3.5
	flate2@0.2.20
	fs2@0.2.5
	fuchsia-cprng@0.1.1
	gcc@0.3.55
	kernel32-sys@0.2.2
	libc@0.2.155
	libsodium-sys@0.0.12
	log@0.3.9
	log@0.4.21
	memchr@0.1.11
	miniz-sys@0.1.12
	pkg-config@0.3.30
	rand@0.3.23
	rand@0.4.6
	rand_core@0.3.1
	rand_core@0.4.2
	rdrand@0.4.0
	regex@0.1.80
	regex-syntax@0.3.9
	rollsum@0.2.1
	rpassword@0.2.3
	rust-crypto@0.2.36
	rustc-serialize@0.3.25
	serde@0.7.15
	sodiumoxide@0.0.12
	termios@0.2.2
	thread-id@2.0.0
	thread_local@0.2.7
	time@0.1.45
	utf8-ranges@0.1.3
	wasi@0.10.0+wasi-snapshot-preview1
	winapi@0.2.8
	winapi@0.3.9
	winapi-build@0.1.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	rdedup@${PV}
	rdedup-lib@${PV}
"

inherit cargo

DESCRIPTION="Data deduplication with compression and public key encryption"
HOMEPAGE="https://github.com/dpc/rdedup"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/libsodium-1.0.11:="
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default
	ln -sf "${WORKDIR}/cargo_home/gentoo/rdedup-lib-${PV}" lib || die
}

src_install() {
	cargo_src_install
	dodoc {CHANGELOG,README}.md
}
