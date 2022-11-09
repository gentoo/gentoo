# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 xdg-utils

DESCRIPTION="An automatic disk mounting service using udisks"
HOMEPAGE="https://pypi.org/project/udiskie/ https://github.com/coldfix/udiskie"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-fs/udisks:2"
DEPEND="app-text/asciidoc
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/python-keyutils[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:gtk-update-icon-cache:true:' setup.py || die
	default

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	emake -C doc
}

src_install() {
	distutils-r1_src_install
	doman doc/${PN}.8
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
