# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
DESCRIPTION="Relative Expression-Based Object Language"
HOMEPAGE="http://rebol.com"

# download links are from
#    http://rebolsource.net/
# amd64 is of experimental build
git_commit=25033f8
SRC_URI="
	amd64? ( http://rebolsource.net/downloads/experimental/r3-linux-x64-gbf237fc )
	x86? (   http://rebolsource.net/downloads/linux-x86/r3-g${git_commit} )
"

# sourcecode uses this license:
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PREBUILT="opt/rebol/r3"

S=${WORKDIR}

src_unpack() {
	mkdir -p "${S}"
	cp "${DISTDIR}/${A}" "${S}"/r3 || die
}

src_compile() {
	:
}

src_install() {
	exeinto /opt/rebol
	doexe r3
}
