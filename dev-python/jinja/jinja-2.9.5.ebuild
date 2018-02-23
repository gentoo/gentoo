# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit eutils distutils-r1

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="http://jinja.pocoo.org/ https://pypi.python.org/pypi/Jinja2"

# pypi tarball is missing tests
SRC_URI="https://github.com/pallets/jinja/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	!dev-python/jinja:compat"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

# XXX: handle Babel better?

wrap_opts() {
	local mydistutilsargs=()

	if [[ ${EPYTHON} == python* ]]; then
		mydistutilargs+=( --with-debugsupport )
	fi

	"${@}"
}

python_compile() {
	wrap_opts distutils-r1_python_compile
	if [[ ${EPYTHON} == python3.2 ]]; then
		2to3 --no-diffs -n -w -f unicode "${BUILD_DIR}/lib" || die
	fi
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use examples ; then
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all

	insinto /usr/share/vim/vimfiles/syntax
	doins ext/Vim/*
}

pkg_postinst() {
	if ! has_version dev-python/Babel; then
		elog "For i18n support, please emerge dev-python/Babel."
	fi
}
