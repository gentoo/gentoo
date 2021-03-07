# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tqdm/tqdm"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86 ~x64-macos"
fi

DESCRIPTION="Add a progress meter to your loops in a second"
HOMEPAGE="https://github.com/tqdm/tqdm"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	# Skip unpredictable performance tests
	pytest -vv --ignore 'tests/tests_perf.py' ||
		die "Tests failed with ${EPYTHON}"
}

python_install() {
	doman "${BUILD_DIR}"/lib/tqdm/tqdm.1
	rm "${BUILD_DIR}"/lib/tqdm/tqdm.1 || die
	distutils-r1_python_install
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
