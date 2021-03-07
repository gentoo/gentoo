# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="let it snow on your desktop and windows"
HOMEPAGE="https://janswaal.home.xs4all.nl/Xsnow/ https://sourceforge.net/projects/xsnow/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	sys-apps/dbus
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.7-gamesdir.patch
)

src_prepare() {
	default
	eautoreconf
}
