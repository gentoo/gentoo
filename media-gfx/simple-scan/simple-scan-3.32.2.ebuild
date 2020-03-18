# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.34"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://gitlab.gnome.org/GNOME/simple-scan"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"
IUSE="colord webp" # packagekit

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.22:3
	>=sys-libs/zlib-1.2.3.1:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	>=dev-libs/libgusb-0.2.7
	colord? ( >=x11-misc/colord-0.1.24:=[udev] )
	webp? ( media-libs/libwebp )
	>=media-gfx/sane-backends-1.0.20:=

	virtual/jpeg:0=
"
# packagekit? ( >=app-admin/packagekit-base-1.1.5 )
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	>=dev-libs/libgusb-0.2.7[vala]
	colord? ( >=x11-misc/colord-0.1.24:=[vala] )
"

PATCHES=(
	# Add control for optional dependencies
	"${FILESDIR}"/3.26-add-control-optional-deps.patch
	# libwepmix: Fix use of possibly unassigned local variable 'data'
	# (from 3.34 branch)
	"${FILESDIR}"/${PN}-3.32.2-unasigned-variable.patch
)

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
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
