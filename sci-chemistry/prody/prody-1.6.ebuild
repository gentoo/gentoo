# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Protein Dynamics Analysis"
HOMEPAGE="http://prody.csb.pitt.edu/ https://github.com/prody/ProDy"
SRC_URI="https://github.com/prody/ProDy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/ProDy-${PV}

DISTUTILS_IN_SOURCE_BUILD=true

python_prepare_all() {
	emake remove
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}" || die
	PATH="${S}"/scripts:${PATH} \
		nosetests --verbose || die
}
