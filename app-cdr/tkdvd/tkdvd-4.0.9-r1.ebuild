# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/tkdvd/tkdvd-4.0.9-r1.ebuild,v 1.4 2015/05/21 13:28:59 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="A Tcl/Tk GUI for writing DVDs and CDs"
HOMEPAGE="http://regis.damongeot.free.fr/tkdvd/"
SRC_URI="http://regis.damongeot.free.fr/tkdvd/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	app-cdr/dvd+rw-tools
	dev-lang/tcl:0
	dev-lang/tk:0
	virtual/cdrtools
"

S=${WORKDIR}/tkdvd

src_compile() { :; }

src_install() {
	insinto /usr/share/${PF}/src
	doins src/*

	insinto /usr/share/${PF}
	doins TkDVD.sh

	cat <<- EOF >"${T}"tkdvd
	#!/bin/sh
	cd /usr/share/${PF}
	sh TkDVD.sh
	EOF

	dobin "${T}"tkdvd

	DOCS=( ChangeLog FAQ README TODO doc/config_file )
	HTML_DOCS=( doc/combobox.html )
	einstalldocs

	doicon icons/*.png
}
