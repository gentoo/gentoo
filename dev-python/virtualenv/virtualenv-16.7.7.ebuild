# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# pypy{,3} dropped until test deps are tested/updated
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

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
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc test"

BDEPEND=">=dev-python/setuptools-19.6.2[${PYTHON_USEDEP}]
	doc? ( $(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
			dev-python/towncrier[${PYTHON_USEDEP}]
		')
	)
	test? (
		>=dev-python/pip-19.3.1-r1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pypiserver[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

DOCS=( docs/index.rst docs/changes.rst )

# uncomment if line above is removed
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/virtualenv-16.7.7-tests.patch"

	# disable tests that need internet access
	"${FILESDIR}/virtualenv-16.7.7-tests-internet.patch"
)

python_check_deps() {
	use doc || return 0

	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" && \
		has_version "dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]" && \
		has_version "dev-python/towncrier[${PYTHON_USEDEP}]"
}

python_compile_all() {
	if use doc; then
		sed -i -e 's:^intersphinx_mapping:disabled_&:' \
			docs/conf.py || die

		sphinx-build -b html -d docs/_build/doctrees docs \
			docs/_build/html || die

		HTML_DOCS+=( "docs/_build/html/." )
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

python_test() {
	cp "${S}"/LICENSE.txt "${BUILD_DIR}"/lib || \
		die "Could not copy LICENSE.txt with ${EPYTHON}"

	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
