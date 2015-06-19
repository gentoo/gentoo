# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/freesmee/freesmee-0.83.ebuild,v 1.1 2013/06/21 18:46:00 ago Exp $

EAPI=5

inherit qt4-r2

DESCRIPTION="Tool for sending SMS and sending/receiving Freesmee-Message-Service"
HOMEPAGE="http://www.freesmee.com"
SRC_URI="https://github.com/${PN}/${PN}-desktop/archive/0.8-b3.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

S="${WORKDIR}/${PN}-desktop-0.8-b3"

DEPEND="dev-util/ticpp
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
	cd deployment/linux || die
	doicon ${PN}.png
	domenu ${PN}.desktop
}
