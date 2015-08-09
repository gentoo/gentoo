# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit python multilib

SRC_URI="http://dev.gentoo.org/~lxnay/${PN}/${P}.tar.bz2"

KEYWORDS="~x86 ~amd64"
DESCRIPTION="Build and operate a electronic whiteboard Wiimote and IR Pen"
HOMEPAGE="http://github.com/pnegre/python-whiteboard"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="app-misc/cwiid[python]
	dev-python/numpy
	dev-python/pybluez
	dev-python/PyQt4
	dev-python/python-xlib"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	python_mod_optimize "/usr/$(get_libdir)/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "/usr/$(get_libdir)/${PN}"
}
