# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Official Hetzner Cloud python library"
HOMEPAGE="https://github.com/hetznercloud/hcloud-python"
SRC_URI="https://github.com/hetznercloud/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc examples"

RDEPEND="
	>=dev-python/future-0.17.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

python_test() {
	# Integration tests need docker:
	# https://github.com/hetznercloud/hcloud-python/blob/master/.travis.yml#L16
	epytest --ignore tests/integration
}
