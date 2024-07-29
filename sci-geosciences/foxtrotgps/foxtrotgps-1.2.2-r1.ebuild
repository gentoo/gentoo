# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="Easy to use, fast and lightweight mapping application (fork of tangogps)"
HOMEPAGE="https://www.foxtrotgps.org/"
SRC_URI="https://www.foxtrotgps.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-libs/libxml2:2
	gnome-base/libglade
	media-libs/libexif
	net-misc/curl
	>=sci-geosciences/gpsd-2.90:=
	sys-apps/dbus
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/${P}-gpsd-api9.patch"
	"${FILESDIR}/${P}-gcc10.patch"
	"${FILESDIR}/${P}-fix-some-receivers.patch"
)
