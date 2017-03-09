# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

# This number identifies each release on the CRU website.
# Can't figure out how to avoid hardcoding it.
NUMBER="4324"

MY_PN=${PN/mmtk/MMTK}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Molecular Modeling ToolKit for Python"
HOMEPAGE="http://dirac.cnrs-orleans.fr/MMTK/"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${NUMBER}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="CeCILL-2"
KEYWORDS="~amd64 ~x86 ~ppc ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	<dev-python/numpy-1.9[${PYTHON_USEDEP}]
	dev-python/scientificpython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	export MMTK_USE_CYTHON="1"
	sed \
		-e "/ext_package/d" \
		-e "/^if sphinx/s|:| == 3:|g" \
		-e "s:import sphinx:sphinx = None:g" \
		-i "${S}"/setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=( README* Doc/CHANGELOG )
	HTML_DOCS=( Doc/HTML/. )

	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/${P}
		doins -r Examples
	fi
}
