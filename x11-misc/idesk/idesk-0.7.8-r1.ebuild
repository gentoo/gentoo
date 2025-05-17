# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility to place icons on the root window"
HOMEPAGE="https://github.com/neagix/idesk"
SRC_URI="https://github.com/neagix/idesk/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 sparc x86"
IUSE="svg"

RDEPEND="
	dev-libs/glib
	dev-libs/libxml2:=
	media-libs/freetype
	media-libs/imlib2[X]
	media-libs/libart_lgpl
	x11-libs/libXft
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/startup-notification
	svg? (
		gnome-base/librsvg
		x11-libs/gdk-pixbuf
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.8-use-pkg-config-imlib2.patch
)

src_prepare() {
	default

	sed -i -e 's,/usr/local/,/usr/,' examples/default.lnk || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-libsn \
		$(use_enable svg)
}
