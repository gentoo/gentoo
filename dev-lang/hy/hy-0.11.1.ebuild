# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

RESTRICT="test" # needs some pointy sticks. Seriously.
PYTHON_COMPAT=(python{2_7,3_4,3_5})

inherit distutils-r1 eutils
DESCRIPTION="A LISP dialect running in python"
HOMEPAGE="http://hylang.org/"
SRC_URI="https://github.com/hylang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test doc examples"

RDEPEND="dev-python/flake8[${PYTHON_USEDEP}]
	>=dev-python/rply-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/astor-0.5[${PYTHON_USEDEP}]
	dev-python/clint[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/tox[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"
src_prepare() {
	use examples && EXAMPLES=( eg/. )
	use doc && HTML_DOCS=( docs/_build/html/. )
}

python_compile_all() {
	use doc && emake docs
}

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
