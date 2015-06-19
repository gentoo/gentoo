# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udiskie/udiskie-1.1.1.ebuild,v 1.2 2014/09/24 19:42:05 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 gnome2-utils

DESCRIPTION="An automatic disk mounting service using udisks"
HOMEPAGE="http://pypi.python.org/pypi/udiskie http://github.com/coldfix/udiskie"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-fs/udisks:2"
DEPEND="app-text/asciidoc
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i \
		-e "s:udiskie.__version__:2:" \
		-e 's:gtk-update-icon-cache:true:' \
		setup.py || die

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

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
