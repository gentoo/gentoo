# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="https://regina-rexx.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.0"
SLOT="0"
KEYWORDS="amd64 ppc64"

RDEPEND="virtual/libcrypt:=
	!dev-lang/oorexx"

PATCHES=( "${FILESDIR}/${PN}-3.9.5-makefile.patch" )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoconf
}

src_configure() {
	local bits="$(( "$(tc-get-ptr-size)" * 8))"
	econf "bitflag=${bits}" "osis${bits}bit=yes" "--enable-${bits}bit"
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
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
