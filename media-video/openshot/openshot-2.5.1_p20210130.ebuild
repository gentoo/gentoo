# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE=xml
DISTUTILS_SINGLE_IMPL=1

COMMIT=14ecc519d8390d6fa76cdc03e0d79a0fb5ca12a7
MY_PN="${PN}-qt"
inherit distutils-r1 xdg

DESCRIPTION="Award-winning free and open-source video editor"
HOMEPAGE="https://openshot.org/"
SRC_URI="https://github.com/OpenShot/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="1"
# KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/httplib2[${PYTHON_MULTI_USEDEP}]
		dev-python/PyQt5[${PYTHON_MULTI_USEDEP},gui,svg,widgets]
		dev-python/PyQtWebEngine[${PYTHON_MULTI_USEDEP}]
		dev-python/pyzmq[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
	>=media-libs/libopenshot-0.2.5:0=[python,${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="
	$(python_gen_cond_dep '
		doc? ( dev-python/sphinx[${PYTHON_MULTI_USEDEP}] )
	')
"

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
