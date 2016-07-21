# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="TkMan man and info page browser"
HOMEPAGE="http://tkman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

DEPEND="
	>=app-text/rman-3.1
	>=dev-lang/tcl-8.4:0
	>=dev-lang/tk-8.4:0
	"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.2-gentoo.diff \
		"${FILESDIR}"/${PN}-CVE-2008-5137.diff #bug 247540
}

src_install() {
	local DOCS=( ANNOUNCE-tkman.txt CHANGES README-tkman )
	local HTML_DOCS=( manual.html )

	dodir /usr/bin
	default

	doicon contrib/TkMan.gif

	domenu "${FILESDIR}"/tkman.desktop
}
