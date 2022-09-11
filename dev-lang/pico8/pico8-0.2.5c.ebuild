# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

MY_PN="pico-8"
DESCRIPTION="Fantasy console for making and playing tiny games and other computer programs"
HOMEPAGE="https://www.lexaloffle.com/pico-8.php"
SRC_URI="
	amd64? ( ${MY_PN}_${PV}_amd64.zip )
	arm? ( ${MY_PN}_${PV}_raspi.zip )
	arm64? ( ${MY_PN}_${PV}_raspi.zip )
	x86? ( ${MY_PN}_${PV}_i386.zip )
"
LICENSE="PICO-8 MIT BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl2[haptic,joystick,sound,video]
	net-misc/wget
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/${PN}"

pkg_nofetch() {
	einfo "Please buy and download ${A} from one of:"
	einfo "  ${HOMEPAGE}"
	einfo "  https://lexaloffle.itch.io/${MY_PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	insinto "${DIR}"

	case ${ARCH} in
		amd64|arm) newexe ${PN}_dyn ${PN} ;;
		arm64) newexe ${PN}_64 ${PN} ;;
		x86) newexe ${PN}_32bit_dyn ${PN} ;;
	esac

	doins ${PN}.dat
	dodoc ${MY_PN}_manual.txt

	dosym ../..${DIR}/${PN} /usr/bin/${PN}
	doicon -s 128 lexaloffle-${PN}.png
	make_desktop_entry ${PN} ${MY_PN^^} lexaloffle-${PN}
}
