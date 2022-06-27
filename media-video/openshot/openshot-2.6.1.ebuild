# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE=xml
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg

MY_PN="${PN}-qt"

DESCRIPTION="Award-winning free and open-source video editor"
HOMEPAGE="https://openshot.org/"
SRC_URI="https://github.com/OpenShot/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="$(python_gen_cond_dep '
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},gui,svg,widgets]
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	>=media-libs/libopenshot-0.2.7:0=[python,${PYTHON_SINGLE_USEDEP}]"
DEPEND=""
BDEPEND="$(python_gen_cond_dep '
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	')"

src_prepare() {
	distutils-r1_python_prepare_all
	# prevent setup.py from trying to update MIME databases
	sed -i 's/^ROOT =.*/ROOT = False/' setup.py || die
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}

python_test() {
	distutils_install_for_testing
	"${EPYTHON}" src/tests/query_tests.py -v --platform minimal || die
}
