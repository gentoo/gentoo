# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnome-python/libgnome-python-2.28.1-r1.ebuild,v 1.9 2014/10/11 11:52:19 maekke Exp $

EAPI="5"

GNOME_ORG_MODULE="gnome-python"
G_PY_BINDINGS=( gnome gnomeui )
PYTHON_COMPAT=( python2_7 )

inherit gnome-python-common-r1

DESCRIPTION="Python bindings for essential GNOME libraries"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples"

RDEPEND=">=gnome-base/libgnome-2.24.1
	>=gnome-base/libgnomeui-2.24.0
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pyorbit-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/libbonobo-python-${PV}[${PYTHON_USEDEP}]
	>=dev-python/gnome-vfs-python-${PV}[${PYTHON_USEDEP}]
	>=dev-python/libgnomecanvas-python-${PV}[${PYTHON_USEDEP}]
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES=( examples/. )
