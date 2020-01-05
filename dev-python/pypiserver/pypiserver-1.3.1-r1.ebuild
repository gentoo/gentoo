# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )
inherit distutils-r1

DESCRIPTION="Minimal PyPI server"
HOMEPAGE="https://github.com/pypiserver/pypiserver"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.25.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools-git[${PYTHON_USEDEP}]
	test? (
		dev-python/passlib[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/pypiserver-1.3.1-no-internet.patch"
)

DOCS=( README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	sed -r \
		-e "s:[\"']tox[\"'](,|$)::" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}
