# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 gnome2-utils readme.gentoo

DESCRIPTION="An automatic disk mounting service using udisks"
HOMEPAGE="https://pypi.python.org/pypi/udiskie https://github.com/coldfix/udiskie"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="dev-python/dbus-python
	dev-python/notify-python
	dev-python/pygobject:2
	dev-python/pyxdg
	sys-fs/udisks"
DEPEND="app-text/asciidoc
	dev-python/setuptools"

DOC_CONTENTS="You have to select which sys-fs/udisks SLOT you want to use:\n
# emerge --noreplace 'sys-fs/udisks:0' (for UDisks 1.0.4+)\nor\n
# emerge --noreplace 'sys-fs/udisks:2' (for UDisks 2.0.0+)"

src_prepare() {
	sed -i -e 's:gtk-update-icon-cache:true:' setup.py || die
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	emake -C doc
}

src_install() {
	distutils-r1_src_install
	doman doc/${PN}.8
	readme.gentoo_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
