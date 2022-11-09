# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org gnome2-utils meson python-r1 vala xdg-utils

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Gitg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="glade +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# test if unbundling of libgd is possible
# Currently it seems not to be (unstable API/ABI)
RDEPEND="
	app-crypt/libsecret[vala]
	>=app-text/gspell-1[vala]
	>=dev-libs/glib-2.38:2[dbus]
	>=dev-libs/gobject-introspection-0.10.1:=
	dev-libs/json-glib
	dev-libs/libdazzle[vala]
	dev-libs/libgee:0.8[introspection]
	dev-libs/libgit2:=[threads]
	>=dev-libs/libgit2-glib-1.0.0[ssh]
	>=dev-libs/libpeas-1.5.0[gtk]
	>=dev-libs/libxml2-2.9.0:2
	>=gnome-base/gsettings-desktop-schemas-0.1.1
	>=x11-libs/gtk+-3.20.0:3
	>=x11-libs/gtksourceview-4.0.3:4
	x11-themes/adwaita-icon-theme
	glade? ( >=dev-util/glade-3.2:3.10 )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-libs/libgit2-glib-1.0.0[vala]
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PV}"-fix-build-with-meson-0.61.1.patch
)

src_prepare() {
	default
	vala_src_prepare
	xdg_environment_reset

	# it doesn't do anything in DESTDIR mode, except for failing
	# when python3 symlink is not present
	echo "#!/bin/sh" > meson_post_install.py || die
}

src_configure() {
	local emesonargs=(
		$(meson_use glade glade_catalog)
		# we install the module manually anyway
		-Dpython=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use python ; then
		python_moduleinto gi.overrides
		python_foreach_impl python_domodule libgitg-ext/GitgExt.py
	fi
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
