# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GNOME_ORG_MODULE="gnome-python"
G_PY_BINDINGS="gnomecanvas"
PYTHON_COMPAT=( python2_7 )

inherit gnome-python-common-r1

DESCRIPTION="Python bindings for the Gnome Canvas library"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples"

RDEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=gnome-base/libgnomecanvas-2.8.0
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES=( examples/canvas/. )
