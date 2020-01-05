# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Syntax highlighting and autocompletion for the Python interpreter"
HOMEPAGE="https://www.bpython-interpreter.org/ https://github.com/bpython/bpython https://pypi.org/project/bpython/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/curtsies-0.2.11[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

DOCS=( AUTHORS CHANGELOG sample.theme light.theme )

# Req'd for clean build by each impl
DISTUTILS_IN_SOURCE_BUILD=1

RESTRICT="test" #659110

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c doc/sphinx/source/ \
			doc/sphinx/source/ doc/sphinx/source/html || die "docs build failed"
	fi
}

python_test() {
	pushd build/lib > /dev/null
	"${PYTHON}" -m unittest discover || die
	popd > /dev/null
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/sphinx/source/html/. )
	distutils-r1_python_install_all
}
