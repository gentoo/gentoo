# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2

MY_P="${PN/gnome-}-${PV}"

DESCRIPTION="A lightweight and fast raw image thumbnailer for GNOME"
HOMEPAGE="https://libopenraw.pages.freedesktop.org/raw-thumbnailer/"
SRC_URI="https://libopenraw.freedesktop.org/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	>=media-libs/libopenraw-0.1.0:=[gtk]
	>=x11-libs/gdk-pixbuf-2:2
	>=dev-libs/glib-2.26:2
	!media-gfx/raw-thumbnailer
"
DEPEND="${RDEPEND}
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-deprecation-warning.patch
	"${FILESDIR}"/${P}-fix-downscale.patch
	"${FILESDIR}"/${P}-libopenraw-0.1.patch
)

src_prepare() {
	default
	eautoreconf
}
