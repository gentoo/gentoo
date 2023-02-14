# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://gitlab.gnome.org/GNOME/simple-scan"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv x86"
IUSE="colord webp"

DEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.24:3
	>=gui-libs/libhandy-1.6.0:1=
	>=sys-libs/zlib-1.2.3.1:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	>=dev-libs/libgusb-0.2.7
	colord? ( >=x11-misc/colord-0.1.24:=[udev(+)] )
	webp? ( media-libs/libwebp )
	>=media-gfx/sane-backends-1.0.20:=

	media-libs/libjpeg-turbo:0=
"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gui-libs/libhandy:1[vala]
	dev-libs/libgusb[vala]
	colord? ( x11-misc/colord[vala] )
"

PATCHES=(
	# Add control for optional dependencies
	"${FILESDIR}"/40.0-add-control-optional-deps.patch
)

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		$(meson_use colord)
		-Dpackagekit=false
		$(meson_use webp)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
