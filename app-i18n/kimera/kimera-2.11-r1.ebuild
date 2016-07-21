# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit qt4-r2 eutils multilib

DESCRIPTION="A Japanese input method which supports the XIM protocol"
SRC_URI="mirror://sourceforge.jp/kimera/37271/${P}.tar.gz"
HOMEPAGE="http://kimera.sourceforge.jp/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"
IUSE="+anthy"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qt3support:4
	anthy? ( app-i18n/anthy )
	!anthy? ( app-i18n/canna )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README*"

src_configure() {
	local myconf="target.path=/usr/$(get_libdir)/${P}"
	use anthy || myconf="${myconf} no_anthy=1"
	eqmake4 kimera.pro ${myconf}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
}
