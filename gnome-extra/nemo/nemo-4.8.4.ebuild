# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit meson gnome2-utils python-single-r1 virtualx xdg

DESCRIPTION="A file manager for Cinnamon, forked from Nautilus"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/nemo"
SRC_URI="https://github.com/linuxmint/nemo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc exif +nls selinux test tracker xmp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# https://github.com/linuxmint/nemo/issues/2501
RESTRICT="test"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.45.7:2[dbus]
	>=dev-libs/gobject-introspection-0.9.12:=
	>=dev-libs/libxml2-2.7.8:2
	gnome-base/dconf:0=
	>=gnome-extra/cinnamon-desktop-4.8:0=
	>=x11-libs/gtk+-3.10.0:3[introspection]
	>=x11-libs/libnotify-0.7:=
	x11-libs/libX11
	>=x11-libs/pango-1.40.0
	>=x11-libs/xapps-2.0.5

	exif? ( >=media-libs/libexif-0.6.20:= )
	selinux? ( sys-libs/libselinux )
	tracker? ( >=app-misc/tracker-2.0:= )
	xmp? ( >=media-libs/exempi-2.2.0:= )
"
RDEPEND="
	${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-themes/adwaita-icon-theme

	nls? ( >=gnome-extra/cinnamon-translations-4.8 )
"
PDEPEND="
	>=gnome-base/gvfs-0.1.2
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	>=dev-util/gdbus-codegen-2.31.0
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig

	doc? ( dev-util/gtk-doc )
"

PATCHES=(
	# Fix performance regression when icon captions enabled.
	# https://github.com/linuxmint/nemo/issues/2472
	"${FILESDIR}/${PN}-4.6-captions-fix.patch"
)

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

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
