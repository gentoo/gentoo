# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

MY_PN="backports.weakref"
MY_PV="${PV}.post1"

DESCRIPTION="Backport of new features in Python's weakref module"
HOMEPAGE="https://github.com/pjdelport/backports.weakref"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-python/backports[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

python_install() {
	# avoid a collision with dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
