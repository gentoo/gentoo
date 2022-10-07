# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org meson python-single-r1

DESCRIPTION="Eye of GNOME plugins"
HOMEPAGE="https://wiki.gnome.org/Apps/EyeOfGnome/Plugins https://gitlab.gnome.org/GNOME/eog-plugins"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+exif map picasa +python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	map? ( exif )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=dev-libs/glib-2.53.4:2
	>=dev-libs/libpeas-1.14.1:=
	>=media-gfx/eog-41.0
	exif? ( >=media-libs/libexif-0.6.16 )
	map? (
		media-libs/libchamplain:0.12[gtk]
		>=media-libs/clutter-1.9.4:1.0
		>=media-libs/clutter-gtk-1.1.2:1.0
	)
	picasa? ( >=dev-libs/libgdata-0.9.1:= )
	python? (
		${PYTHON_DEPS}
		dev-libs/glib[dbus]
		dev-libs/libpeas:=[gtk,python,${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
		gnome-base/gsettings-desktop-schemas
		media-gfx/eog[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
"
DEPEND="${RDEPEND}
	test? ( dev-libs/appstream-glib )"
BDEPEND="
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-build-Use-correct-variables.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use exif plugin_exif-display)
		$(meson_use python plugin_export-to-folder)
		-Dplugin_fit-to-width=true
		$(meson_use python plugin_fullscreenbg)
		-Dplugin_light-theme=true
		$(meson_use map plugin_map)
		$(meson_use python plugin_maximize-windows)
		$(meson_use picasa plugin_postasa)
		-Dplugin_postr=false
		$(meson_use python plugin_pythonconsole)
		-Dplugin_send-by-mail=true
		$(meson_use python plugin_slideshowshuffle)
	)
	meson_src_configure
}
