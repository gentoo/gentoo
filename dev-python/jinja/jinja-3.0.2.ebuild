# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="https://jinja.palletsprojects.com/ https://pypi.org/project/Jinja2/"
# pypi tarball is missing tests
SRC_URI="https://github.com/pallets/jinja/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="examples"

RDEPEND="
	>=dev-python/markupsafe-2.0.0[${PYTHON_USEDEP}]
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

python_install_all() {
	if use examples ; then
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	if ! has_version dev-python/Babel; then
		elog "For i18n support, please emerge dev-python/Babel."
	fi
}
