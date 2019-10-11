# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GNOME_ORG_MODULE="gnome-python-desktop"
G_PY_BINDINGS="wnck"
PYTHON_COMPAT=( python2_7 )

inherit gnome-python-common-r1 eutils

DESCRIPTION="Python bindings for the libwnck library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86"
IUSE="examples"

RDEPEND=">=x11-libs/libwnck-2.19.3:1
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES=( examples/wnck_example.py )

src_prepare() {
	# Fix three enum items that should be flags, upstream bug #616306
	epatch "${FILESDIR}/${PN}-2.30.2-flagsfix.patch"
	gnome-python-common-r1_src_prepare
}
