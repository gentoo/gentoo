# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_BUILD="0724"
MY_DATE="$(ver_cut 4)"
MY_DATE_ISO="20180724"
MY_PN="SuperDiag"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}_${MY_PV}_${MY_DATE}"

DESCRIPTION="Provides the capability to determine the health of Supermicro servers components"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_PN}_${MY_PV}_${MY_DATE}_package.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="supermicro"
SLOT="0"
IUSE="iso usb"

DEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack "${S}"/${MY_P}.zip

	if use iso; then
		unzip ${MY_P}/Diagnose_Remotely/ISOFor${MY_PN}_v${MY_PV}_${MY_BUILD}.zip -d iso || die
	fi

	if use usb; then
		unzip ${MY_P}/Diagnose_Remotely/USBFor${MY_PN}_v${MY_PV}_${MY_BUILD}.zip -d usb || die
	fi
}

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=SDO"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	insinto /usr/share/superdiag
	doins ${MY_P}/startup.nsh ${MY_P}/${MY_PN}_v${MY_PV}.efi ${MY_P}/EFI/Boot/BootX64.efi

	insinto /usr/share/superdiag/Picture
	doins ${MY_P}/Picture/*.bmp

	insinto /usr/share/superdiag/SelData
	doins ${MY_P}/SelData/*.dat

	local DOCS=(
		"Superdiag_${MY_PV}_addendum_release_notes.docx"
		"${MY_P}/Supermicro Super Diagnostics Offline readme.txt"
		"${MY_P}/Supermicro Super Diagnostics Offline User Guide V${MY_PV}.pdf"
	)
	dodoc "${DOCS[@]}"

	if use iso; then
		insinto /usr/share/superdiag/ISO
		doins iso/${MY_PN}_v${MY_PV}_${MY_DATE_ISO}.iso

		newdoc iso/Readme.txt Readme.ISO.txt
	fi

	if use usb; then
		insinto /usr/share/superdiag/USB
		doins usb/STARTUP.nsh

		dosym ../BootX64.efi /usr/share/superdiag/USB/BootX64.efi
		dosym ../${MY_PN}_v${MY_PV}.efi /usr/share/superdiag/USB/${MY_PN}_v${MY_PV}.efi
		dosym ../Picture /usr/share/superdiag/USB/Picture
		dosym ../SelData /usr/share/superdiag/USB/SelData

		newdoc usb/Readme.txt Readme.USB.txt
	fi
}
