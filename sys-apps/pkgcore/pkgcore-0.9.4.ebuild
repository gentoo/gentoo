# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcore.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="https://github.com/pkgcore/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

DESCRIPTION="a framework for package management"
HOMEPAGE="https://github.com/pkgcore/pkgcore"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
IUSE="doc test"

if [[ ${PV} == *9999 ]] ; then
	SPHINX="dev-python/sphinx[${PYTHON_USEDEP}]"
else
	SPHINX="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
fi
RDEPEND=">=dev-python/snakeoil-0.7.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	${SPHINX}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )
"

pkg_setup() {
	# disable snakeoil 2to3 caching...
	unset PY2TO3_CACHEDIR
}

python_compile_all() {
	esetup.py build_man $(usex doc "build_docs" "")
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install install_man \
		$(usex doc "install_docs --path="${ED%/}"/usr/share/doc/${PF}/html" "")
	distutils-r1_python_install_all
}

pkg_postinst() {
	python_foreach_impl pplugincache
}
