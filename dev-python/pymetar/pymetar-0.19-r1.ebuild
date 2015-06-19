# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymetar/pymetar-0.19-r1.ebuild,v 1.4 2015/05/27 11:23:14 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Downloads, decodes and provides access to the weather report for a given station ID"
HOMEPAGE="http://www.schwarzvogel.de/software-pymetar.shtml"
SRC_URI="http://www.schwarzvogel.de/pkgs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="librarydoc.txt README THANKS"

# Fix to install of data
PATCHES=( "${FILESDIR}"/setup.patch )
