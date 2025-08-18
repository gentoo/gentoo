# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature xdg

DESCRIPTION="Lightweight image viewer"
HOMEPAGE="https://github.com/lxde/gpicview"
SRC_URI="https://github.com/lxde/gpicview/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ppc ~riscv x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/libjpeg-turbo:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

# Changelog is not up-to-date
# NEWS is empty
DOCS=( AUTHORS )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --enable-gtk3
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "GIF support" gui-libs/gdk-pixbuf[gif]
	optfeature "JPEG support" gui-libs/gdk-pixbuf[jpeg]
	optfeature "TIFF support" gui-libs/gdk-pixbuf[tiff]
	optfeature "WebP support" gui-libs/gdk-pixbuf-loader-webp
}
