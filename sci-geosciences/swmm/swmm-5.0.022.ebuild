# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator toolchain-funcs

MY_PV=$(delete_all_version_separators)
MY_SRC="swmm${MY_PV}_engine.zip"
DESCRIPTION="Storm Water Management Model - SWMM, hydrology, hydraulics, and water quality model"
HOMEPAGE="http://www.epa.gov/ednnrmrl/models/swmm/index.htm"
SRC_URI="http://www.epa.gov/nrmrl/wswrd/wq/models/swmm/${MY_SRC}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}

pkg_setup() {
	tc-export CC
}

src_unpack() {
	unpack ${MY_SRC}
	# Need to delete Readme.txt, because it is in makefiles.zip
	rm Readme.txt || die
	unpack ./makefiles.zip
	unpack ./GNU_CON.zip
	unpack ./source*.ZIP
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
}

src_compile(){
	# 'sed' command has to accomodate DOS formatted file.
	sed -i \
		-e 's;^#define DLL;//#define DLL;' \
		-e 's;^//#define CLE;#define CLE;' \
		swmm5.c || die
	emake
}

src_install(){
	newbin swmm5 swmm
	dodoc Roadmap.txt
}
