# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools xdg

DESCRIPTION="let it snow on your desktop and windows"
HOMEPAGE="https://www.ratrabbit.nl/ratrabbit/xsnow/"
SRC_URI="https://www.ratrabbit.nl/downloads/xsnow/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/cairo
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
