# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_REQ_USE="xml"

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/bite/bite.git"
	inherit git-r3
else
	SRC_URI="https://github.com/bite/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="bug, issue, and ticket extraction library and command line tool"
HOMEPAGE="https://github.com/bite/bite"
LICENSE="BSD"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/requests-2[${PYTHON_USEDEP}]
	dev-python/multidict[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	app-crypt/gpgme[python,${PYTHON_USEDEP}]
"
if [[ ${PV} == *9999 ]] ; then
	RDEPEND+=" ~dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
	SPHINX="dev-python/sphinx[${PYTHON_USEDEP}]"
else
	RDEPEND+=" >=dev-python/snakeoil-0.8[${PYTHON_USEDEP}]"
	SPHINX="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
fi
DEPEND="
	${SPHINX}
	dev-python/setuptools[${PYTHON_USEDEP}]
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
