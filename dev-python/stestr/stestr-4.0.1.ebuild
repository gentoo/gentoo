# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A parallel Python test runner built around subunit"
HOMEPAGE="https://github.com/mtreinish/stestr"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/subunit-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.8.9[${PYTHON_USEDEP}]"
BDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing
	stestr init || die
	stestr run || die "Tests failed with ${EPYTHON}"
}
