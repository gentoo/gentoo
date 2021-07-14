# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="https://regina-rexx.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/Regina-REXX-${PV}.tar.gz"
S="${WORKDIR}/Regina-REXX-${PV}"

LICENSE="LGPL-2.1 MPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/libcrypt:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-3.9.1-makefile.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoconf
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	DOCS=( BUGS HACKERS.txt README.Unix README_SAFE TODO )
	einstalldocs

	newinitd "${FILESDIR}"/rxstack-r1 rxstack
}

pkg_postinst() {
	elog "You may want to run"
	elog
	elog "\trc-update add rxstack default"
	elog
	elog "to enable Rexx queues (optional)."
}
