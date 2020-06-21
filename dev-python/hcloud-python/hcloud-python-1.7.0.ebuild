# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Official Hetzner Cloud python library"
HOMEPAGE="https://github.com/hetznercloud/hcloud-python"
SRC_URI="https://github.com/hetznercloud/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

COMMON_DEPEND=">=dev-python/python-dateutil-2.7.5[${PYTHON_USEDEP}]
	<dev-python/python-dateutil-2.9[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]
	<dev-python/requests-2.23[${PYTHON_USEDEP}]"

BDEPEND="${COMMON_DEPEND}
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme
	)
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)"

RDEPEND="${COMMON_DEPEND}
	>=dev-python/future-0.17.1[${PYTHON_USEDEP}]
	<dev-python/future-0.19[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use examples && dodoc -r examples
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

distutils_enable_tests pytest

src_test() {
	# Integration tests need docker:
	# https://github.com/hetznercloud/hcloud-python/blob/master/.travis.yml#L16
	rm -fr tests/integration
	default
}
