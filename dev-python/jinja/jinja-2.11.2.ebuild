# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="http://jinja.pocoo.org/ https://pypi.org/project/Jinja2/"
# pypi tarball is missing tests
SRC_URI="https://github.com/pallets/jinja/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="examples"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
	!dev-python/jinja:compat"

distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/pallets-sphinx-themes
distutils_enable_tests pytest

# XXX: handle Babel better?

src_prepare() {
	# avoid unnecessary dep on extra sphinxcontrib modules
	sed -i '/sphinxcontrib.log_cabinet/ d' docs/conf.py || die

	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile

	if ! python_is_python3; then
		rm "${BUILD_DIR}"/lib/jinja2/async*.py || die
	fi
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
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
