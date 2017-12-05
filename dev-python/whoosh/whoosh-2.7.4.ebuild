# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Fast, pure-Python full text indexing, search and spell checking library"
HOMEPAGE="https://bitbucket.org/mchaput/whoosh/wiki/Home/ https://pypi.python.org/pypi/Whoosh/"
SRC_URI="mirror://pypi/W/${PN^}/${P^}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ~ppc ~ppc64 x86 ~x64-solaris"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.4-tests-specify-utf8.patch
)

python_prepare_all() {
	# (backport from upstream)
	sed -i -e '/cmdclass/s:pytest:PyTest:' setup.py || die

	# Prevent un-needed download during build
	sed -e "/^              'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# https://bitbucket.org/mchaput/whoosh/issue/403/
	if use doc; then
		sphinx-build -b html -c docs/source/ docs/source/ docs/source/build/html || die
		HTML_DOCS=( docs/source/build/html/. )
	fi
}

python_test() {
	# https://bitbucket.org/mchaput/whoosh/issue/412/tarball-of-whoosh-270-pypi-missing-english
	# tarball missing a file english-words.10.gz which when added sees all tests pass.
	esetup.py test
}
