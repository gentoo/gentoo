# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )
inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Classes for orchestrating Python (virtual) environments."
HOMEPAGE="https://github.com/jaraco/jaraco.envs"
SRC_URI="mirror://pypi/${MY_P::1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="dev-python/namespace-jaraco[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' 'python3_[67]')"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

# there are no actual tests, just flake8 etc
RESTRICT="test"

python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	distutils-r1_python_install --skip-build
}
