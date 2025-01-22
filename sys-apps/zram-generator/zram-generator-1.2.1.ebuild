# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.7.8
	anstyle@1.0.10
	anyhow@1.0.94
	autocfg@1.4.0
	bitflags@1.3.2
	bitflags@2.6.0
	cc@1.2.5
	cfg-if@1.0.0
	clap@4.5.23
	clap_builder@4.5.23
	clap_lex@0.7.4
	ctor@0.2.9
	dlv-list@0.3.0
	errno@0.3.10
	fasteval@0.2.4
	fastrand@2.3.0
	fs_extra@1.3.0
	getrandom@0.2.15
	hashbrown@0.12.3
	libc@0.2.169
	liboverdrop@0.1.0
	linux-raw-sys@0.4.14
	log@0.4.22
	memoffset@0.6.5
	nix@0.23.2
	once_cell@1.20.2
	ordered-multimap@0.4.3
	proc-macro2@1.0.92
	quote@1.0.37
	rust-ini@0.18.0
	rustix@0.38.42
	shlex@1.3.0
	syn@2.0.90
	tempfile@3.14.0
	unicode-ident@1.0.14
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

inherit cargo systemd toolchain-funcs

DESCRIPTION="Systemd unit generator for zram swap devices"
HOMEPAGE="https://github.com/systemd/zram-generator"
SRC_URI="
	https://github.com/systemd/zram-generator/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"
IUSE="+man"
# TODO: Permission issue on 'test_cases'
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
	man? ( app-text/ronn-ng )
"

QA_FLAGS_IGNORED="usr/lib/systemd/system-generators/zram-generator"

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
