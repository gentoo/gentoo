# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="https://regina-rexx.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="virtual/libcrypt:=
	!dev-lang/oorexx"

PATCHES=( "${FILESDIR}/${PN}-3.9.6-makefile.patch" )

src_prepare() {
	default
	mv configure.{in,ac} || die
	sed -i "s/\$(INSTALL) -s/\$(INSTALL)/g" Makefile.in || die
	sed -E -i "s/\\$\(INSTALL\) -m ([0-9]{3}) -c/\$\(INSTALL\) -m \1 -c -D/g" Makefile.in || die
	sed -E -i "s/\\$\(INSTALL\) -c -m ([0-9]{3})/\$\(INSTALL\) -c -m \1 -D/g" Makefile.in || die
	eautoconf
}

src_configure() {
	append-cflags "$(test-flags-CC -std=gnu17)" # bug 944237
	local bits="$(( "$(tc-get-ptr-size)" * 8))"
	econf "bitflag=${bits}" "osis${bits}bit=yes" "--enable-${bits}bit"
}

src_compile() {
	emake -j1 CC="$(tc-getCC)"
}

src_install() {
	emake -j1 INSTALL="$(command -v install)" DESTDIR="${D}" install
	DOCS=( BUGS HACKERS.txt README.Unix README_SAFE TODO )
	einstalldocs

	newinitd "${FILESDIR}/rxstack-r1" rxstack
}

pkg_postinst() {
	elog "You may want to run"
	elog
	elog "\trc-update add rxstack default"
	elog
	elog "to enable Rexx queues (optional)."
}
