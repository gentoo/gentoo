# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_DATE="$(ver_cut 4)"
MY_PN="SuperDiag"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Provides the capability to determine the health of Supermicro servers components"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_PN}_${MY_PV}_${MY_DATE}.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="supermicro"
SLOT="0"
IUSE="iso usb"

BDEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=SDO"
	elog "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack ${A}

	if use iso; then
		unzip Diagnose_Remotely/ISOFor${MY_PN}_${MY_PV}.zip -d iso || die
	fi

	if use usb; then
		unzip Diagnose_Remotely/USBFor${MY_PN}_${MY_PV}.zip -d usb || die
	fi
}

src_install() {
	insinto /usr/share/superdiag
	doins startup.nsh ${MY_PN}.efi EFI/Boot/BootX64.efi

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
		doins usb/startup.nsh

		dosym ../BootX64.efi /usr/share/superdiag/USB/BootX64.efi
		dosym ../${MY_PN}.efi /usr/share/superdiag/USB/${MY_PN}.efi

		newdoc usb/Readme.txt Readme.USB.txt
	fi
}
