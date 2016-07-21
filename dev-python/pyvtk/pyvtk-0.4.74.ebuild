# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=PyVTK-${PV}

DESCRIPTION="Tools for manipulating VTK files in Python"
HOMEPAGE="http://cens.ioc.ee/projects/pyvtk/"
SRC_URI="http://cens.ioc.ee/projects/pyvtk/rel-0.x/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${P}.patch )
