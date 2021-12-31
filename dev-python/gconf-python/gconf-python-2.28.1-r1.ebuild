# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GNOME_ORG_MODULE="gnome-python"
PYTHON_COMPAT=( python2_7 )

inherit gnome-python-common-r1

DESCRIPTION="Python bindings for the GConf library"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples"

RDEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=gnome-base/gconf-2.11.1
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES=( examples/gconf/. )
