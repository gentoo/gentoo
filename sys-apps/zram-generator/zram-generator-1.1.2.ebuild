# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.4.7
	anyhow-1.0.45
	autocfg-1.0.1
	bitflags-1.2.1
	cc-1.0.72
	cfg-if-1.0.0
	clap-2.33.3
	ctor-0.1.21
	dlv-list-0.2.3
	fasteval-0.2.4
	fs_extra-1.2.0
	getrandom-0.2.3
	hashbrown-0.9.1
	libc-0.2.107
	liboverdrop-0.0.2
	log-0.4.14
	memoffset-0.6.4
	nix-0.22.2
	ordered-multimap-0.3.1
	ppv-lite86-0.2.15
	proc-macro2-1.0.32
	quote-1.0.10
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	redox_syscall-0.2.10
	remove_dir_all-0.5.3
	rust-ini-0.17.0
	syn-1.0.81
	tempfile-3.2.0
	textwrap-0.11.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	wasi-0.10.2+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo systemd toolchain-funcs

DESCRIPTION="Systemd unit generator for zram swap devices"
HOMEPAGE="https://github.com/systemd/zram-generator"
SRC_URI="https://github.com/systemd/zram-generator/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	  $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man"

BDEPEND="virtual/rust
	virtual/pkgconfig
	man? ( app-text/ronn-ng )"

QA_FLAGS_IGNORED="lib/systemd/system-generators/zram-generator"

src_configure() {
	cargo_src_configure

	sed -e "s,@SYSTEMD_SYSTEM_GENERATOR_DIR@,$(systemd_get_systemgeneratordir)," \
		< units/systemd-zram-setup@.service.in \
		> units/systemd-zram-setup@.service || de
}

src_compile() {
	tc-export PKG_CONFIG

	export SYSTEMD_UTIL_DIR="$(systemd_get_utildir)"
	cargo_src_compile

	use man && emake man
}

src_install() {
	# https://bugs.gentoo.org/715890
	mv man man.bkp || die
	cargo_src_install
	mv man.bkp man || die

	mkdir -p "${D}/$(systemd_get_systemgeneratordir)" || die
	mv "${D}"/usr/bin/zram-generator "${D}/$(systemd_get_systemgeneratordir)" || die

	systemd_dounit units/systemd-zram-setup@.service
	if use man ; then
		dodoc zram-generator.conf.example
		doman man/zram-generator.8 man/zram-generator.conf.5
	fi
}
