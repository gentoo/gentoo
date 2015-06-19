# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/freesmee/freesmee-9999.ebuild,v 1.1 2013/06/21 12:41:54 ago Exp $

EAPI=5

inherit qt4-r2 git-2

DESCRIPTION="Tool for sending SMS and sending/receiving Freesmee-Message-Service"
HOMEPAGE="http://www.freesmee.com"
EGIT_REPO_URI="https://github.com/${PN}/${PN}-desktop.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-util/ticpp
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
	cd deployment/linux
	doicon ${PN}.png
	domenu ${PN}.desktop
}
