# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="https://bitbucket.org/izi/polib/wiki/Home"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc"

DEPEND="doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.7-BE-test.patch
)

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" tests/tests.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
