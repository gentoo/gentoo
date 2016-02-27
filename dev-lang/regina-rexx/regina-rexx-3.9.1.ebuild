# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils toolchain-funcs

DESCRIPTION="Portable Rexx interpreter"
HOMEPAGE="http://regina-rexx.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/Regina-REXX-${PV}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/Regina-REXX-${PV}

MAKEOPTS+=" -j1"

DOCS=( BUGS HACKERS.txt README.Unix README_SAFE TODO )

src_prepare() {
	sed -e 's/CFLAGS=/UPSTREAM_CFLAGS=/' -i common/incdebug.m4 || die

	eautoconf
	tc-export CC #don't move it as tc-getCC
}

src_compile() {
	emake LIBEXE="$(tc-getAR)"
}

src_install() {
	default
	newinitd "${FILESDIR}"/rxstack-r1 rxstack
}

pkg_postinst() {
	elog "You may want to run"
	elog
	elog "\trc-update add rxstack default"
	elog
	elog "to enable Rexx queues (optional)."
}
