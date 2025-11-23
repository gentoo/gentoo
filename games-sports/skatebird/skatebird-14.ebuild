# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="3G"
inherit check-reqs desktop wrapper xdg

MY_PN="SkateBIRD"
DESCRIPTION="Skateboarding game where you play as a bird"
HOMEPAGE="https://glassbottommeg.itch.io/skatebird"
SRC_URI="skatebird-linux.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}"
DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default

	# Avoid error trying to create unity.lock.
	sed -i "/^single-instance=/d" ${MY_PN}_Data/boot.config || die
}

src_install() {
	exeinto "${DIR}"
	newexe ${MY_PN}.x86_64 ${MY_PN}
	doexe UnityPlayer.so

	insinto "${DIR}"
	doins -r ${MY_PN}_Data/

	newicon -s 128 ${MY_PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_wrapper ${PN} "${DIR}"/${MY_PN}
	make_desktop_entry ${PN} ${MY_PN}
}
