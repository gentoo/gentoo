# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="http://www.bpython-interpreter.org/ https://bitbucket.org/bobf/bpython/ https://pypi.python.org/pypi/bpython"
SRC_URI="http://www.bpython-interpreter.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gtk test"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	gtk? ( dev-python/pygobject:2[$(python_gen_usedep python2_7)]
		dev-python/pygtk[$(python_gen_usedep python2_7)] )
	dev-python/urwid[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

DOCS=( AUTHORS  CHANGELOG  TODO sample-config sample.theme light.theme )

PATCHES=( "${FILESDIR}"/${PN}-desktop.patch )

# Req'd for clean build by each impl
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c doc/sphinx/source/ \
			doc/sphinx/source/ doc/sphinx/source/html || die "docs build failed"
	fi
}

python_install() {
	distutils-r1_python_install
	if ! use gtk; then
		rm -f "${D}"usr/bin/bpython-gtk*
		# delete_unneeded_modules() {
		rm -f "${D}$(python_get_sitedir)/bpython/gtk_.py"
	fi
}

python_test() {
	pushd build/lib > /dev/null
	# https://bitbucket.org/bobf/bpython/issue/289/test-failures-in-latest-release-py27-py33
	sed -e s':test_enter:_&:' -i bpython/test/test_repl.py || die

	"${PYTHON}" -m unittest discover || die
	popd > /dev/null
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/sphinx/source/html/. )
	distutils-r1_python_install_all
}
