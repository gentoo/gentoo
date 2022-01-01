# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_DATE="$(ver_cut 4)"
MY_PN="${PN^^}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="An in-band utility for configuring Supermicro IPMI devices"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="https://www.supermicro.com/wftp/utility/{MY_PN}/${MY_PN}_${MY_PV}_build.${MY_DATE}.zip"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="uefi"

BDEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

S="${WORKDIR}/${MY_PN}_${MY_PV}_build.${MY_DATE}"

QA_PREBUILT="usr/bin/ipmicfg"

src_install() {
	newbin Linux/$(usex amd64 '64bit' '32bit')/IPMICFG-Linux.x86$(usex amd64 '_64' '') ipmicfg

	if use uefi; then
		insinto /usr/share/ipmicfg
		newins UEFI/IPMICFG.efi ipmicfg.efi
	fi

	# Install docs
	local DOCS=(
		"IPMICFG_UserGuide.pdf"
		"ReleaseNotes.txt"
	)
	einstalldocs
}
