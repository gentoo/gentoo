# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit meson gnome2-utils python-single-r1 virtualx xdg

DESCRIPTION="A file manager for Cinnamon, forked from Nautilus"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/nemo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc exif +nls selinux tracker xmp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT=test

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/gobject-introspection-0.6.4:=
	>=gnome-extra/cinnamon-desktop-4.4:0=
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.9.10:3[introspection]
	>=dev-libs/libxml2-2.7.8:2

	gnome-base/dconf:0=
	>=x11-libs/libnotify-0.7:=
	x11-libs/libX11
	>=x11-libs/xapps-1.8.0

	exif? ( >=media-libs/libexif-0.6.20:= )
	tracker? ( >=app-misc/tracker-2.0:= )
	xmp? ( >=media-libs/exempi-2.2.0:= )
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	nls? ( >=gnome-extra/cinnamon-translations-4.4 )
	$(python_gen_cond_dep '
		dev-python/polib[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"
PDEPEND=">=gnome-base/gvfs-0.1.2"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	>=dev-util/gdbus-codegen-2.31.0
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

src_prepare() {
	default
	python_fix_shebang files/usr/share/nemo/actions install-scripts
}

src_configure() {
	local emesonargs=(
		$(meson_use exif)
		$(meson_use tracker)
		$(meson_use xmp)
		$(meson_use selinux)
		$(meson_use doc gtk_doc)
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
