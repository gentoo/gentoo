# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcore.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
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
if [[ ${PV} == *9999 ]]; then
	RDEPEND+=" ~dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
else
	RDEPEND+=" >=dev-python/snakeoil-0.8.0[${PYTHON_USEDEP}]"
fi
DEPEND="${RDEPEND}
	${SPHINX}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

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
