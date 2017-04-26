# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

src_prepare() {
	# skip integration and speed tests
	rm test/test_{integration,speed}* || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${PYTHONPATH%:}${PYTHONPATH+:}${S}/test" py.test -v test \
		|| die "Tests failed under ${EPYTHON}"
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( "${S}"/docs/_build/html/. )
	distutils-r1_python_install_all
}
