# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A lightweight modular configurable http url handler/browser launcher"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	into /usr
	dobin browser-config
	dosym /usr/bin/browser-config /usr/bin/runbrowser
	insinto /usr/share/browser-config
	doins definitions/*
}

pkg_postinst() {
	elog "Please run browser-config -b <browser> -m <method>"
	elog "If run as root, it will be global, if run as a user it will be for"
	elog "that user only."
	elog
	elog "Please see browser-config -h for info on available browsers/methods"
	elog
	elog "You may then tell your applications to use either 'runbrowser' or"
	elog "'browser-config' as a browser."
	elog
}
