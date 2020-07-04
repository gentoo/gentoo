# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Thin-wrapper around the mock package for easier use with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-mock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/mock-2[${PYTHON_USEDEP}]' -2)"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pytest-mock-2.0.0-warnings.patch
)

src_prepare() {
	if has_version dev-python/mock; then
		# test fails when standalone mock is installed
		sed -e 's|^\(def \)\(test_standalone_mock(\)|\1_\2|' -i tests/test_pytest_mock.py || die
	fi
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	pytest --assert=plain -vv || die "Tests fail with ${EPYTHON}"
}
