# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MYPN=astLib
MYP=${MYPN}-${PV}

DESCRIPTION="Python astronomy modules for image and coordinate manipulation"
HOMEPAGE="http://astlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2 LGPL-2.1"

IUSE="doc examples"

PATCHES=( "${FILESDIR}/${P}-system-wcstools.patch" )

DEPEND="sci-astronomy/wcstools"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MYP}"

python_install_all() {
	dodoc CHANGE_LOG RELEASE_NOTES
	insinto /usr/share/doc/${PF}/html
	use doc && doins -r docs/${MYPN}/*
	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
	distutils-r1_python_install_all
}
