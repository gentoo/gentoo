# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgit2-glib/libgit2-glib-0.0.12.ebuild,v 1.5 2015/04/08 17:51:56 mgorny Exp $

EAPI=5

GCONF_DEBUG="no"
PYTHON_COMPAT=( python3_3 )

inherit gnome2 python-r1

DESCRIPTION="Git library for GLib"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgit2-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/libgit2-0.20.0:=
	<dev-libs/libgit2-0.21
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/gobject-introspection-0.10.1
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure $(use_enable python)
}
