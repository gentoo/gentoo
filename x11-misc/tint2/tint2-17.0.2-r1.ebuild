# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# note: this is the final "original" version, we opted to stop
# using the 17.1.x (dead) fork wrt bug #970019

inherit cmake xdg

DESCRIPTION="Lightweight panel/taskbar for Linux"
HOMEPAGE="https://gitlab.com/o9000/tint2/"
SRC_URI="https://gitlab.com/o9000/tint2/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86"
IUSE="startup-notification svg tint2conf"

RDEPEND="
	dev-libs/glib:2
	media-libs/imlib2[X,png]
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	startup-notification? ( x11-libs/startup-notification )
	svg? (
		gnome-base/librsvg:2
		x11-libs/gdk-pixbuf:2
	)
	tint2conf? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake4.patch
	"${FILESDIR}"/${P}-glib2.76.patch
	"${FILESDIR}"/${P}-math.patch
)

src_configure() {
	local mycmakeargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		-DENABLE_RSVG=$(usex svg)
		-DENABLE_SN=$(usex startup-notification)
		-DENABLE_TINT2CONF=$(usex tint2conf)
	)

	cmake_src_configure
}
