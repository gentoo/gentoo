# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="The new generation of the pytest-salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt-factories"
SRC_URI="https://github.com/saltstack/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-4.6.6[${PYTHON_USEDEP}]
	dev-python/pytest-tempdir[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? ( >=app-admin/salt-3000.0[${PYTHON_USEDEP}] )
"

# pytest just bombs
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/pytest-salt-factories-0.92.0-setup.patch"
)

distutils_enable_tests pytest
