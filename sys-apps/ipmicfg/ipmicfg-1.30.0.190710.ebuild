# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_DATE="$(ver_cut 4)"
MY_PN="${PN^^}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="An in-band utility for configuring Supermicro IPMI devices"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="ftp://ftp.supermicro.com/utility/${MY_PN}/${MY_PN}_${MY_PV}_build.${MY_DATE}.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="supermicro"
SLOT="0"

DEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}/${MY_PN}_${MY_PV}_build.${MY_DATE}"

QA_PREBUILT="
	opt/ipmicfg/IPMICFG-Linux.x86
	opt/ipmicfg/IPMICFG-Linux.x86_64
"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=IPMI"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	# Choose ARCH
	local my_arch_binary="$(usex amd64 'x86_64' 'x86')"
	local my_arch_folder="$(usex amd64 '64bit' '32bit')"

	# Install files
	insinto /opt/ipmicfg
	doins Linux/"${my_arch_folder}"/*.dat

	# Install binary
	exeinto /opt/ipmicfg
	doexe Linux/"${my_arch_folder}"/IPMICFG-Linux."${my_arch_binary}"

	# Install symlink
	dodir /opt/bin
	dosym ../ipmicfg/IPMICFG-Linux."${my_arch_binary}" /opt/bin/ipmicfg

	# Install docs
	local DOCS=(
		"IPMICFG_UserGuide.pdf"
		"ReleaseNotes.txt"
	)
	einstalldocs
}
