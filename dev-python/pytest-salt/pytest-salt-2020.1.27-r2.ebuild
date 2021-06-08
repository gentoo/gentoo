# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

MY_PV="${PV/_p/.post}"
DESCRIPTION="PyTest Salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt"
SRC_URI="https://github.com/saltstack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.2.0[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-tempdir[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
"
#BDEPEND="
#	test? ( app-admin/salt[${PYTHON_USEDEP}] )
#"

PATCHES=(
	"${FILESDIR}/${PN}-2020.1.27-r2.patch"
)

# tests need network access
RESTRICT="test"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
