# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}404"

DESCRIPTION="Tandem Repeats Finder"
HOMEPAGE="https://tandem.bu.edu/trf/trf.html"
SRC_URI="https://tandem.bu.edu/trf/downloads/${MY_P}.linux"
S="${WORKDIR}"

LICENSE="trf"	# http://tandem.bu.edu/trf/trf.license.html
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror bindist"

QA_PREBUILT="opt/trf/.*"

src_unpack() {
	cp "${DISTDIR}"/${MY_P}.linux "${S}"/${MY_P}.linux.exe || die
}

src_install() {
	exeinto /opt/trf
	doexe trf404.linux.exe
	dosym ../trf/${MY_P}.linux.exe /opt/bin/trf
}
