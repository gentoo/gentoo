# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/alacarte/alacarte-3.11.91.ebuild,v 1.3 2015/06/26 09:24:23 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
# FIXME: support python3 but installs in a weird location
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit gnome2 python-r1

DESCRIPTION="Simple GNOME menu editor"
HOMEPAGE="https://git.gnome.org/browse/alacarte"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-base/gnome-menus-3.5.3:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installing() {
		gnome2_src_install
		# Massage shebang to make python_doscript happy
		sed -e 's:#! '"${PYTHON}:#!/usr/bin/python:" \
			-i alacarte || die
			python_doscript alacarte
		}
	python_foreach_impl run_in_build_dir installing
}
