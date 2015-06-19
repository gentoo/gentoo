# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/trf/trf-4.04.ebuild,v 1.6 2014/04/17 21:08:54 ulm Exp $

EAPI=4

inherit eutils

MY_P="${PN}404"

DESCRIPTION="Tandem Repeats Finder"
HOMEPAGE="http://tandem.bu.edu/trf/trf.html"
SRC_URI="http://tandem.bu.edu/trf/downloads/${MY_P}.linux"

LICENSE="trf"	# http://tandem.bu.edu/trf/trf.license.html
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror bindist"

S="${WORKDIR}"

QA_PREBUILT="opt/${PN}/.*"

src_unpack() {
	cp "${DISTDIR}/${MY_P}.linux" "${S}/${MY_P}.linux.exe" || die
}

src_install() {
	exeinto /opt/${PN}
	doexe trf404.linux.exe
	dosym /opt/${PN}/${MY_P}.linux.exe /opt/bin/trf
	# GTK version (http://tandem.bu.edu/trf/downloads/trf400.linuxgtk.exe) has broken linking
	#if use gtk; then
	#	doexe trf400.linuxgtk.exe || die
	#	make_desktop_entry /opt/${PN}/trf400.linuxgtk.exe "Tandem Repeats Finder" || die
	#fi
}
