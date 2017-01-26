# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils systemd

DESCRIPTION="Corsair K65/K70/K95 Driver"
HOMEPAGE="https://github.com/ccMSC/ckb"
SRC_URI="https://github.com/ccMSC/ckb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/quazip-0.7.2[qt5]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

DOCS=( README.md BUILD.md DAEMON.md )

src_prepare() {
	sed -i -e "s/-Werror=all//" src/ckb-daemon/ckb-daemon.pro || die
	sed -i -e "/quazip/d" -e "s/^.*QUAZIP_STATIC/LIBS += -lquazip5/" src/ckb/ckb.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	dobin bin/ckb bin/ckb-daemon
	dodir /usr/bin/ckb-animations
	exeinto /usr/bin/ckb-animations
	doexe bin/ckb-animations/*

	newinitd "${FILESDIR}"/ckb.initd ckb-daemon
	domenu usr/ckb.desktop
	doicon usr/ckb.png
	systemd_dounit service/systemd/ckb-daemon.service
}
