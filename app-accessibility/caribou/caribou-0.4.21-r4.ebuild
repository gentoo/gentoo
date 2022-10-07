# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="xml(+)"

inherit autotools gnome.org gnome2-utils python-single-r1 vala

DESCRIPTION="Input assistive technology intended for switch and pointer users"
HOMEPAGE="https://wiki.gnome.org/Projects/Caribou"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	app-accessibility/at-spi2-core
	$(python_gen_cond_dep '
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
	')
	>=dev-libs/gobject-introspection-0.10.7:=
	dev-libs/libgee:0.8
	dev-libs/libxml2
	>=media-libs/clutter-1.5.11:1.0[introspection]
	>=x11-libs/gtk+-3:3[introspection]
	x11-libs/libX11
	x11-libs/libxklavier
	x11-libs/libXtst
"
# gsettings-desktop-schemas is needed for the 'toolkit-accessibility' key
# pyatspi-2.1.90 needed to run caribou if pygobject:3 is installed
# librsvg needed to load svg images in css styles
RDEPEND="
	${COMMON_DEPEND}
	dev-libs/glib[dbus]
	$(python_gen_cond_dep '
		>=dev-python/pyatspi-2.1.90[${PYTHON_USEDEP}]
	')
	>=gnome-base/gsettings-desktop-schemas-3
	gnome-base/librsvg:2
	sys-apps/dbus
	!<x11-base/xorg-server-1.20.10
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/libxslt
"
BDEPEND="
	$(vala_depend)
	>=dev-util/intltool-0.35.5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-compilation-error.patch"
	"${FILESDIR}/${PN}-fix-subkey-popmenu.patch"
	"${FILESDIR}/${PN}-fix-xadapter-xkb-calls.patch"
	"${FILESDIR}/${PN}-fix-antler-style-css.patch"
	"${FILESDIR}/${PN}-fix-python-env.patch"
	"${FILESDIR}/${PN}-change_autostart_cinnamon.patch"
	"${FILESDIR}/${PN}-drop_gir_patch.patch"
)

src_prepare() {
	default
	vala_src_prepare
	gnome2_disable_deprecation_warning
	eautoreconf
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-schemas-compile \
		--disable-docs \
		--disable-static \
		--disable-gtk2-module \
		--enable-gtk3-module
}

src_install() {
	DOCS="AUTHORS NEWS README"
	default
	find "${D}" -name '*.la' -delete || die
	python_optimize
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
