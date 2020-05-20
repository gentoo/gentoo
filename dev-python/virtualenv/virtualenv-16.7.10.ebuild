# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"
SRC_URI="https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/setuptools-19.6.2[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/pip-19.3.1-r1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pypiserver[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

DOCS=( docs/index.rst docs/changes.rst )

PATCHES=(
	"${FILESDIR}/virtualenv-16.7.7-tests.patch"

	# disable tests that need internet access
	"${FILESDIR}/virtualenv-16.7.7-tests-internet.patch"

	# test fixes for pypy
	"${FILESDIR}/virtualenv-16.7.8-tests-pypy.patch"
)

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/towncrier

python_test() {
	cp "${S}"/LICENSE.txt "${BUILD_DIR}"/lib || \
		die "Could not copy LICENSE.txt with ${EPYTHON}"

	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
