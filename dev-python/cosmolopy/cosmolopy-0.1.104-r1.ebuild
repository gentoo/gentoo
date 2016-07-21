# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7)

inherit distutils-r1

MY_PN=CosmoloPy
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cosmology routines built on NumPy/SciPy"
HOMEPAGE="https://roban.github.com/CosmoloPy/ https://pypi.python.org/pypi/CosmoloPy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-python/nose[${PYTHON_USEDEP}]
	dev-lang/swig
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )"
RDEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_compile_all() {
	if use doc; then
		epydoc -n "CosmoloPy - Cosmology routines built on NumPy/SciPy" \
			--exclude='cosmolopy.EH._power' --exclude='cosmolopy.EH.power' \
			--no-private --no-frames --html --docformat restructuredtext \
			cosmolopy/ -o docAPI/ || die
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docAPI/. )
	distutils-r1_python_install_all
}
