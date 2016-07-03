# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4,3_5} )
VALA_MIN_API_VERSION="0.30"
VALA_USE_DEPEND="vapigen"

inherit gnome2 python-single-r1 vala virtualx

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+introspection python vala webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# FIXME: some unittests seem to hang forever
RDEPEND="
	>=dev-libs/glib-2.47.92:2[dbus]
	dev-libs/libgit2[ssh,threads]
	>=dev-libs/libgit2-glib-0.23.4[ssh]
	dev-libs/libpcre:3
	>=dev-libs/libpeas-1.18.0
	>=dev-libs/libxml2-2.9
	dev-util/uncrustify
	sys-devel/clang
	>=x11-libs/gtk+-3.20.0:3[introspection?]
	>=x11-libs/gtksourceview-3.20.0:3.0[introspection?]
	>=x11-libs/pango-1.38.0
	introspection? ( >=dev-libs/gobject-introspection-1.47.92:= )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.19.3:3 )
	vala? ( $(vala_depend) )
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4= )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.50.1
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	use python && export PYTHON3_CONFIG="$(python_get_PYTHON_CONFIG)"
	gnome2_src_configure \
		--enable-editorconfig \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable python python-pack-plugin) \
		$(use_enable vala vala-pack-plugin) \
		$(use_enable webkit)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data/gsettings" || die
	GSETTINGS_SCHEMA_DIR="${S}/data/gsettings" virtx emake check
}
