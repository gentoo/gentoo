# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="https://pytest.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/iniconfig[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	>=dev-python/py-1.8.2[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-3.4[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/argcomplete[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.56[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/xmlschema[${PYTHON_USEDEP}]
	)"

src_test() {
	# workaround new readline defaults
	echo "set enable-bracketed-paste off" > "${T}"/inputrc || die
	local -x INPUTRC="${T}"/inputrc
	distutils-r1_src_test
}

python_test() {
	distutils_install_for_testing --via-root

	"${EPYTHON}" -m pytest -vv --lsof -rfsxX -p no:pkgcore -p no:flaky ||
		die "Tests failed with ${EPYTHON}"
}
