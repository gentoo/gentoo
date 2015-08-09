# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2:2.5"
inherit eutils multilib python

DESCRIPTION="a lean, flexible frontend to mplayer written in python"
HOMEPAGE="http://jdolan.dyndns.org/trac/wiki/Pymp"
SRC_URI="http://jdolan.dyndns.org/jaydolan/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd"
IUSE=""

RDEPEND="media-video/mplayer
	dev-python/pygtk"
DEPEND="sys-apps/sed"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e "s/python/python2/" -e "s:PREFIX/lib:/usr/$(get_libdir):" pymp || die "sed failed"
}

src_compile() { :; }

src_install() {
	dobin pymp || die "dobin failed"
	insinto /usr/$(get_libdir)/pymp
	doins *.py || die "doins failed"
	dodoc CHANGELOG README
	doicon pymp.png
	make_desktop_entry pymp Pymp pymp
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/pymp
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/pymp
}
