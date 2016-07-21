# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# We don't support the egg.recent bindings that are also provided - they are
# deprecated, have deps we don't really want and there are no users in-tree.
GNOME_ORG_MODULE="gnome-python-extras"
G_PY_BINDINGS="eggtray"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome-python-common-r1

DESCRIPTION="EggTrayIcon bindings for Python"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=dev-python/libbonobo-python-2.22.1[${PYTHON_USEDEP}]
	>=dev-python/libgnome-python-2.22.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common"
# eautoreconf needs gnome-base/gnome-common

EXAMPLES=( examples/egg/trayicon.py )

src_prepare() {
	epatch "${FILESDIR}/${P}-python-libs.patch" #344231
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	eautoreconf
	gnome-python-common-r1_src_prepare
}
