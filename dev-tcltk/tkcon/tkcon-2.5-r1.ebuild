# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

DESCRIPTION="Tk GUI console"
HOMEPAGE="http://tkcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="doc"

DEPEND="dev-lang/tk"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-under.patch"
}

src_install() {
	local tclver="$(echo 'puts $tcl_version' | tclsh)"
	local instdir=/usr/$(get_libdir)/tcl${tclver}/${PN}2.5
	dodir ${instdir}
	cp -pP pkgIndex.tcl tkcon.tcl "${D}"${instdir} || die
	dodir /usr/bin
	dosym ${instdir}/tkcon.tcl /usr/bin/tkcon
	dodoc README.txt
	if use doc; then
		dohtml doc/*
	fi
}
