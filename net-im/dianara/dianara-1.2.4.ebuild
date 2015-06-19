# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/dianara/dianara-1.2.4.ebuild,v 1.5 2015/02/22 18:41:23 mgorny Exp $

EAPI=5

inherit eutils gnome2-utils qmake-utils

MY_P=${PN}-v${PV/_beta/beta}
DESCRIPTION="Qt-based client for the pump.io distributed social network"
HOMEPAGE="http://dianara.nongnu.org/"
SRC_URI="mirror://nongnu/dianara/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-crypt/qca:2[qt4(+)]
	dev-libs/qjson
	dev-libs/qoauth
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	sys-apps/file"
RDEPEND="${DEPEND}
	app-crypt/qca:2[openssl]
"

S=${WORKDIR}/${MY_P}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	doman manual/*
	dodoc README TODO CHANGELOG BUGS
	doicon -s 32 icon/32x32/${PN}.png
	doicon -s 64 icon/64x64/${PN}.png
	domenu ${PN}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
