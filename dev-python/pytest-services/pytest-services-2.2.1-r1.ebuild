# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of fixtures and utility functions to run service processes for pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-services/
	https://pypi.org/project/pytest-services/
"
SRC_URI="
	https://github.com/pytest-dev/pytest-services/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/zc-lockfile[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pylibmc[${PYTHON_USEDEP}]
		x11-base/xorg-server[xvfb]
		net-misc/memcached
		!dev-python/pytest-salt
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/pytest-services-2.0.1-no-mysql.patch"
	"${FILESDIR}/pytest-services-2.0.1-lockdir.patch"
)

python_test() {
	epytest -p no:xvfb
}
