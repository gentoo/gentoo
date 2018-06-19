# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Kryoflux SPS Decoder Library"
HOMEPAGE="https://www.kryoflux.com/"
SRC_URI="https://www.kryoflux.com/download/${PN}_${PV}_source.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="Kryoflux-MAME"
SLOT="0"

DEPEND="app-arch/unzip"

S="${WORKDIR}/capsimg_source_linux_macosx/CAPSImg"

DOCS=( "${WORKDIR}/DONATIONS.txt" "${WORKDIR}/HISTORY.txt" "${WORKDIR}/RELEASE.txt" )

PATCHES=( "${FILESDIR}"/add_symlink.patch )

src_unpack() {
	unpack ${A}

	# Unpacked ZIP-file contains two ZIP files, use the one for Linux
	unpack "${WORKDIR}"/capsimg_source_linux_macosx.zip
}

src_prepare() {
	default

	# Respect users CFLAGS and CXXFLAGS
	sed -i -e 's/-g//' configure.in || die
	sed -i -e 's/CXXFLAGS="${CFLAGS}/CXXFLAGS="${CXXFLAGS}/' configure.in || die

	mv configure.in configure.ac || die
	eautoconf

	# Fix permissions, as configure is not marked executable
	chmod +x configure || die
}
