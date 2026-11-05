# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kryoflux SPS Decoder Library"
HOMEPAGE="https://www.kryoflux.com/"

SRC_URI="https://www.kryoflux.com/download/${PN}_${PV}_source.zip"
S="${WORKDIR}/SPStudio_Dev/"

LICENSE="Kryoflux-MAME"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="app-arch/unzip"

DOCS=( CAPSLib520a.pdf {HISTORY,RELEASE}.txt )

PATCHES=( "${FILESDIR}/spsdeclib-5.2-honor-destdir.patch" )

src_prepare() {
	cmake_src_prepare

	# Remove MSVC compiler-specific attribute
	sed -i -e 's/__cdecl //' LibIPF/Caps{Lib,FDC}.h || die
}

src_install() {
	cmake_src_install

	insinto /usr/include/CAPSImage
	doins Core/CommonTypes.h
}
