# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lupy/lupy-0.2.1-r2.ebuild,v 1.5 2015/04/14 12:50:06 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Lupy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Lupy is a is a full-text indexer and search engine written in Python"
HOMEPAGE="http://divmod.org/projects/lupy http://pypi.python.org/pypi/Lupy"
SRC_URI="mirror://sourceforge/lupy/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ~s390 x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="changelog.txt releasenotes.txt"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
