# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 vala virtualx

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/CharacterMap"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/gjs-1.43.3
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=dev-libs/libunistring-0.9.5
	>=x11-libs/gtk+-3.20:3[introspection]
	>=x11-libs/pango-1.36[introspection]
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"

python_check_deps() {
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_enable test dogtail)
}

src_test() {
	virtx emake check
}
