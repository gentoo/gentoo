# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit qt4-r2

DESCRIPTION="A flexible and configurable notification daemon"
HOMEPAGE="http://sourceforge.net/projects/qtnotifydaemon/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qt3support:4
	!x11-misc/notification-daemon
	!x11-misc/notify-osd"
DEPEND="${RDEPEND}"

S=${WORKDIR}

PATCHES=( "${FILESDIR}/${P}-build.patch" )

src_install() {
	dobin ${PN}

	insinto /usr/share/dbus-1/services
	doins org.freedesktop.Notifications.service

	doman debian/${PN}.1
}
