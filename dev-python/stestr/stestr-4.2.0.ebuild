# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="A parallel Python test runner built around subunit"
HOMEPAGE="
	https://github.com/mtreinish/stestr/
	https://pypi.org/project/stestr/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/python-subunit-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.6[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.8.9[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
	)
"

python_test() {
	stestr init || die
	stestr run --test-path stestr/tests \
		--concurrency "${EPYTEST_JOBS:-$(makeopts_jobs)}" ||
		die "Tests failed with ${EPYTHON}"
}
