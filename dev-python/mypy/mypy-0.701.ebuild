# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

if [ "${PV}" == "9999" ]; then
	inherit distutils-r1 git-r3
	EGIT_REPO_URI="https://github.com/python/${PN}"
	SRC_URI=""
else
	inherit distutils-r1
	TYPESHED_COMMIT="36b28e5"
	SRC_URI="https://github.com/python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
			https://api.github.com/repos/python/typeshed/tarball/${TYPESHED_COMMIT} -> mypy-typeshed-${PV}-${TYPESHED_COMMIT}.tar.gz"
fi

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/flake8[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
CDEPEND="
	!dev-util/stubgen
	>=dev-python/psutil-5.4.0[${PYTHON_USEDEP}]
	<dev-python/psutil-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.3.1[${PYTHON_USEDEP}]
	<dev-python/typed-ast-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.0[${PYTHON_USEDEP}]
	<dev-python/mypy_extensions-0.5.0[${PYTHON_USEDEP}]
	"

RDEPEND="${CDEPEND}"

RESTRICT="!test? ( test )"

src_unpack() {
	if [ "${PV}" == "9999" ]; then
		git-r3_src_unpack
	else
		unpack ${A}
		rmdir "${S}/mypy/typeshed"
		mv "${WORKDIR}/python-typeshed-${TYPESHED_COMMIT}" "${S}/mypy/typeshed"
	fi
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	local PYTHONPATH="$(pwd)"

	"${PYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
