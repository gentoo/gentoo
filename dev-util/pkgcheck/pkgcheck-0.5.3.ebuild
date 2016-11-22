# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/pkgcore/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based QA utility"
HOMEPAGE="https://github.com/pkgcore/pkgcheck"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"

RDEPEND="
	>=sys-apps/pkgcore-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/snakeoil-0.7.0[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
[[ ${PV} == *9999 ]] && DEPEND+=" dev-python/sphinx[${PYTHON_USEDEP}]"

pkg_setup() {
	# disable snakeoil 2to3 caching...
	unset PY2TO3_CACHEDIR
}

python_compile_all() {
	esetup.py build_man
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( AUTHORS NEWS.rst )
	distutils-r1_python_install install_man
	distutils-r1_python_install_all
}

pkg_postinst() {
	python_foreach_impl pplugincache pkgcheck.plugins
}
