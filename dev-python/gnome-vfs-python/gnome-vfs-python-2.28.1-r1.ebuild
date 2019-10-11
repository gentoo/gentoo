# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GNOME_ORG_MODULE="gnome-python"
G_PY_BINDINGS=( gnomevfs gnomevfsbonobo pyvfsmodule )
PYTHON_COMPAT=( python2_7 )

inherit gnome-python-common-r1

DESCRIPTION="Python bindings for the GnomeVFS library"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc examples"

RDEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=gnome-base/gnome-vfs-2.24.0
	>=gnome-base/libbonobo-2.8
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES=( examples/vfs/. )
