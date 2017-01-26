# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_4,3_5} )
VALA_MIN_API_VERSION="0.32" # Needed when gtk+-3.20 is found

inherit gnome2 pax-utils python-r1 vala

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Gitg"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="debug glade +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# test if unbundling of libgd is possible
# Currently it seems not to be (unstable API/ABI)
RDEPEND="
	app-crypt/libsecret
	dev-libs/libgee:0.8[introspection]
	>=app-text/gtkspell-3.0.3:3
	>=dev-libs/glib-2.38:2[dbus]
	>=dev-libs/gobject-introspection-0.10.1:=
	dev-libs/libgit2:=[threads]

	>=dev-libs/libgit2-glib-0.24.0[ssh]
	<dev-libs/libgit2-glib-0.25.0

	>=dev-libs/libpeas-1.5.0[gtk]
	>=dev-libs/libxml2-2.9.0:2
	net-libs/libsoup:2.4
	>=gnome-base/gsettings-desktop-schemas-0.1.1
	>=x11-libs/gtk+-3.20.0:3
	>=x11-libs/gtksourceview-3.10:3.0
	x11-themes/adwaita-icon-theme
	glade? ( >=dev-util/glade-3.2:3.10 )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-libs/libgit2-glib-0.22.0[vala]
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	sed \
		-e '/CFLAGS/s:-g::g' \
		-e '/CFLAGS/s:-O0::g' \
		-i configure.ac || die

	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-deprecations \
		$(use_enable debug) \
		$(use_enable glade glade-catalog) \
		$(use_enable python)
}

src_install() {
	# -j1: bug #???
	gnome2_src_install -j1

	if use python ; then
		install_gi_override() {
			python_moduleinto "$(python_get_sitedir)/gi/overrides"
			python_domodule "${S}"/libgitg-ext/GitgExt.py
		}
		python_foreach_impl install_gi_override
	fi
}
