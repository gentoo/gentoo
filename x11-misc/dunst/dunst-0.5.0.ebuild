# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="customizable and lightweight notification-daemon"
HOMEPAGE="http://www.knopwob.org/dunst/"
SRC_URI="http://www.knopwob.org/public/dunst-release/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libxdg-basedir
	sys-apps/dbus
	x11-libs/libXScrnSaver
	x11-libs/libXft
	x11-libs/libXinerama
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	dodoc CHANGELOG
}
