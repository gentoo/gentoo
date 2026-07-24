# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_ID="1035"
MY_DATE="$(ver_cut 4)"
MY_PN="SuperDiag"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Provides the capability to determine the health of Supermicro servers components"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="https://www.supermicro.com/Bios/sw_download/1035/${MY_PN}_${MY_PV}_${MY_DATE}.zip"
S="${WORKDIR}"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="iso usb"

BDEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

src_unpack() {
	unpack ${A}

	use arm64 && SMCARCH="ARM"
	use amd64 && SMCARCH="X86"
	unzip "${SMCARCH}/${MY_PN}_${MY_PV}_${MY_DATE}_For_${SMCARCH}.zip"

	if use iso; then
		unzip Diagnose_Remotely/ISOFor${MY_PN}_${MY_PV}.zip -d iso || die
	fi

	if use usb; then
		unzip Diagnose_Remotely/USBFor${MY_PN}_${MY_PV}.zip -d usb || die
	fi
}

src_install() {
	insinto /usr/share/superdiag
	doins startup.nsh ${MY_PN}.efi

	local DOCS=(
		"Supermicro Super Diagnostics Offline readme.txt"
		"Supermicro Super Diagnostics Offline User Guide V${MY_PV}.pdf"
	)
	dodoc "${DOCS[@]}"

	if use iso; then
		insinto /usr/share/superdiag/ISO
		doins iso/${MY_PN}_${MY_PV}.iso

		newdoc iso/Readme.txt Readme.ISO.txt
	fi

	if use usb; then
		insinto /usr/share/superdiag/USB
		doins usb/startup.nsh usb/EFI/BOOT/BOOTX64.EFI

		dosym ../../../BOOTX64.EFI /usr/share/superdiag/USB/EFI/BOOT/BOOTX64.EFI
		dosym ../${MY_PN}.efi /usr/share/superdiag/USB/${MY_PN}.efi

		newdoc usb/Readme.txt Readme.USB.txt
	fi
}
