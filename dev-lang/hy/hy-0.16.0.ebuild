# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

RESTRICT="test" # needs some pointy sticks. Seriously.
PYTHON_COMPAT=(python{2_7,3_6,3_7})

inherit distutils-r1 eutils
DESCRIPTION="A LISP dialect running in python"
HOMEPAGE="http://hylang.org/"
SRC_URI="https://github.com/hylang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test doc"

RDEPEND=">=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/clint-0.4[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	>=dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	>=dev-python/rply-0.7.6[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${PN}-0.15.0-do-not-install-get_version.py.patch )

src_prepare() {
	default
	use doc && HTML_DOCS=( docs/_build/html/. )
}

python_compile_all() {
	use doc && emake docs
}

python_test() {
	nosetests -vv || die "Tests failed under ${EPYTHON}"
}
