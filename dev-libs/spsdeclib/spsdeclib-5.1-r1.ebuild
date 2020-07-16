# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Kryoflux SPS Decoder Library"
HOMEPAGE="https://www.kryoflux.com/"
SRC_URI="https://www.kryoflux.com/download/${PN}_${PV}_source.zip"

KEYWORDS="amd64 x86"
LICENSE="Kryoflux-MAME"
SLOT="0"

DEPEND="app-arch/unzip"

S="${WORKDIR}/capsimg_source_linux_macosx/CAPSImg"

DOCS=( "${WORKDIR}"/{DONATIONS,HISTORY,RELEASE}.txt )

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

	# Remove MSVC compiler-specific attribute
	sed -i -e 's/__cdecl //' ../LibIPF/Caps{Lib,FDC}.h || die

	mv configure.in configure.ac || die
	eautoconf

	# Fix permissions, as configure is not marked executable
	chmod +x configure || die
}

src_install() {
	default

	insinto /usr/include/caps5
	doins ../Core/CommonTypes.h ../LibIPF/*.h
}
