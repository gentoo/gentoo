# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE=xml
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg

MY_PN="${PN}-qt"

DESCRIPTION="An award-winning free and open-source video editor"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/httplib2[${PYTHON_MULTI_USEDEP}]
		dev-python/PyQt5[${PYTHON_MULTI_USEDEP},gui,svg,webkit,widgets]
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

S="${WORKDIR}/${MY_PN}-${PV}"

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
