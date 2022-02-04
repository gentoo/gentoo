# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1 flag-o-matic

MY_PN="python-glyr"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python wrapper for Glyr"
HOMEPAGE="https://sahib.github.io/python-glyr/intro.html
	https://github.com/sahib/python-glyr"
SRC_URI="https://github.com/sahib/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
KEYWORDS="amd64 x86"
SLOT="0"

RDEPEND="media-libs/glyr:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs

python_prepare_all() {
	# Disable test requiring internet connection
	sed -e 's:test_download:_&:' -i tests/test_misc.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover tests || die "Tests fail with ${EPYTHON}"
}
