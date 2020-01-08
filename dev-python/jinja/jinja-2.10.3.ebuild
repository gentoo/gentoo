# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="http://jinja.pocoo.org/ https://pypi.org/project/Jinja2/"

# pypi tarball is missing tests
SRC_URI="https://github.com/pallets/jinja/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	!dev-python/jinja:compat"
RDEPEND="${CDEPEND}
	dev-python/markupsafe[${PYTHON_USEDEP}]"
BDEPEND="${CDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

# XXX: handle Babel better?

wrap_opts() {
	local mydistutilsargs=()

	if [[ ${EPYTHON} == python* ]]; then
		mydistutilargs+=( --with-debugsupport )
	fi

	"${@}"
}

python_prepare() {
	# async is not supported on python2
	if ! python_is_python3; then
		rm -f jinja2/async*.py || die "Failed to remove async from python2"
	fi
}

python_compile() {
	wrap_opts distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs html
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
