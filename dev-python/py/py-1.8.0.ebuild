# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="https://pylib.readthedocs.io/en/latest/ https://pypi.org/project/py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.2-skip-apiwarn-pytest31.patch
	"${FILESDIR}"/${P}-pytest-4.patch
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's:intersphinx_mapping:#&:' -i doc/conf.py || die

	distutils-r1_python_prepare_all

	# broken, and relying on exact assertion strings
	rm testing/code/test_assertion.py || die
	# broken on py3.8, don't seem important
	sed -i -e 's:test_syntaxerror_rerepresentation:_&:' \
		-e 's:test_comments:_&:' \
		testing/code/test_source.py || die
	# broken on py3.9, this package is just dead
	sed -i -e 's:test_excinfo_\(repr\|set\):_&:' \
		-e 's:test_format_excinfo:_&:' \
		-e 's:test_excinfo_str:_&:' \
		testing/code/test_excinfo.py || die
	sed -i -e 's:test_getfslineno:_&:' \
		testing/code/test_source.py || die
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
