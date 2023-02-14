# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Official Hetzner Cloud python library"
HOMEPAGE="https://github.com/hetznercloud/hcloud-python"
SRC_URI="
	https://github.com/hetznercloud/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"

RDEPEND="
	>=dev-python/python-dateutil-2.7.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Integration tests need docker:
	# https://github.com/hetznercloud/hcloud-python/blob/master/.travis.yml#L16
	tests/integration
)

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
