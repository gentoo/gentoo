# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A more feature-full replacement of the Alt-Tab window switching behavior"
HOMEPAGE="https://code.google.com/p/superswitcher/"
SRC_URI="https://superswitcher.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=gnome-base/gconf-2:2
	x11-libs/gtk+:2
	>=x11-libs/libwnck-2.10:1
	x11-libs/libXcomposite
	x11-libs/libXinerama
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-wnck-workspace.patch
	"${FILESDIR}"/${PN}-0.6-glib-single-include.patch
)

src_prepare() {
	default
	sed -i \
		-e '/-DG.*_DISABLE_DEPRECATED/d' \
		src/Makefile.am || die #338906

	mv configure.{in,ac} || die #426262

	eautoreconf
}
