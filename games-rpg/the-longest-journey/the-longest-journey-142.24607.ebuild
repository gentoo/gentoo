# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="1826M"
CHECKREQS_DISK_USR="1820M"
inherit check-reqs desktop wrapper xdg

MY_EXE="setup_the_longest_journey_${PV%.*}_lang_update_(${PV##*.})"
ICON="9c94fffadc23bac626a24a9c04cf8f107598ef9d0d2a58cbb6a9abd4d6eb0fbc.png"

DESCRIPTION="Adventure through the twin worlds of Stark and Arcadia, seen through the eyes of an 18-year old student"
HOMEPAGE="https://www.gog.com/game/the_longest_journey"
SRC_URI="${MY_EXE}.exe ${MY_EXE}-1.bin"
LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+hd +hd-fmv"
RESTRICT="bindist fetch"

RDEPEND="
	>=games-engines/scummvm-2.5.1[opengl,truetype,vorbis]
"

PDEPEND="
	hd? ( ${CATEGORY}/${PN}-hd )
	hd-fmv? ( ${CATEGORY}/${PN}-hd-fmv )
"

BDEPEND="
	app-arch/innoextract
	app-arch/unzip
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${MY_EXE}{.exe,-1.bin} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	innoextract -e -s -m "${DISTDIR}/${MY_EXE}.exe" || die
	unzip -qo app/webcache.zip "${ICON}" || die
}

src_install() {
	local dir=/usr/share/${PN}

	insinto "${dir}"
	doins -r [0-9]?/ Global/ Static/ Fonts/ game.exe x.xarc *.ini
	dodoc manual.pdf

	docinto html
	dodoc -r tlj_faq_files/ tlj_faq.html

	newicon -s 128 "${ICON}" "${PN}.png"
	make_wrapper ${PN} "scummvm -p \"${EPREFIX}${dir}\" tlj"
	make_desktop_entry ${PN} "The Longest Journey"
}
