# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Downloads, decodes and provides access to the weather report for a given station ID"
HOMEPAGE="http://www.schwarzvogel.de/software-pymetar.shtml"
SRC_URI="http://www.schwarzvogel.de/pkgs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="librarydoc.txt"

PATCHES=( "${FILESDIR}"/setup_pymetar-0.21.patch )
