# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Python module for importing and exporting DSV files"
HOMEPAGE="http://python-dsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/DSV-${PV}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/wxpython:2.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/DSV-${PV}

python_prepare_all() {
	epatch "${FILESDIR}"/${P}-wxversion.patch

	distutils-r1_python_prepare_all
}
