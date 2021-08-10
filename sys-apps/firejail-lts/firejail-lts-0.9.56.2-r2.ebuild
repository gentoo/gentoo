# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Security sandbox for any type of processes; LTS version"
HOMEPAGE="https://firejail.wordpress.com/"

MY_PN=firejail

SRC_URI="https://github.com/netblue30/${MY_PN}/archive/${PV}-LTS.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64"
IUSE="apparmor +globalcfg +network +seccomp +suid +userns test +whitelist"
RESTRICT="!test? ( test )"

RDEPEND="apparmor? ( sys-libs/libapparmor )"

DEPEND="${RDEPEND}
		!sys-apps/firejail
		test? ( dev-tcltk/expect )"

S="${WORKDIR}/${MY_PN}-${PV}-LTS"

src_prepare() {
	default

	find -type f -name Makefile.in | xargs sed -i -r \
		-e '/^\tinstall .*COPYING /d' \
		-e '/CFLAGS/s: (-O2|-ggdb) : :g' || die

	sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die

	# remove compression of man pages
	sed -i -e '/gzip -9n $$man; \\/d' Makefile.in || die
	sed -i -e '/rm -f $$man.gz; \\/d' Makefile.in || die
	sed -i -r -e 's|\*\.([[:digit:]])\) install -c -m 0644 \$\$man\.gz|\*\.\1\) install -c -m 0644 \$\$man|g' Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable apparmor) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable seccomp) \
		$(use_enable suid) \
		$(use_enable userns) \
		$(use_enable whitelist)
}

src_compile() {
	emake CC="$(tc-getCC)"
}
