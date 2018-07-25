# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver java-vm-2

MY_DATE="$(ver_cut 4)"
MY_PN="SMCIPMITool"
MY_PN_SRC_URI="SMCIPMItool"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="An out-of-band utility for interfacing with SuperBlade and IPMI devices via CLI"
HOMEPAGE="https://www.supermicro.com/"
SRC_URI="amd64? ( ftp://ftp.supermicro.com/utility/${MY_PN_SRC_URI}/Linux/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64.tar.gz )
	x86? ( ftp://ftp.supermicro.com/utility/${MY_PN_SRC_URI}/Linux/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux.tar.gz )"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="net-misc/stunnel
	sys-libs/ncurses:5
	virtual/jre"

RESTRICT="bindist fetch mirror strip"

S="${WORKDIR}"

QA_PREBUILT="opt/smcipmitool/libiKVM*.so
	opt/smcipmitool/libjcurses*.so
	opt/smcipmitool/libSharedLibrary*.so"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=IPMI"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	# Choose ARCH
	if use amd64; then
		local my_arch="${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64"
	else
		local my_arch="${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux"
	fi

	# Install binary
	exeinto /opt/smcipmitool
	doexe ${my_arch}/SMCIPMITool

	# Install libs
	exeinto /opt/smcipmitool
	if use amd64; then
		doexe ${my_arch}/*64.so
	else
		doexe ${my_arch}/libjcurses.so ${my_arch}/*32.so
	fi

	# Install java libs
	exeinto /opt/smcipmitool
	if use amd64; then
		doexe ${my_arch}/*64.jnilib
	fi

	# Install files
	insinto /opt/smcipmitool
	doins ${my_arch}/*.jar ${my_arch}/*.lax ${my_arch}/*.properties

	# Use system java
	dosym ../..${JAVA_VM_SYSTEM}/jre /opt/smcipmitool/jre

	# Install certificates
	insinto /opt/smcipmitool/BMCSecurity
	doins ${my_arch}/BMCSecurity/*.crt ${my_arch}/BMCSecurity/*.key ${my_arch}/BMCSecurity/*.pem ${my_arch}/BMCSecurity/*.txt

	# Install Stunnel config
	insinto /opt/smcipmitool/BMCSecurity/linux
	doins ${my_arch}/BMCSecurity/linux/stunnel.conf

	# Use system stunnel
	dosym ../../../../usr/bin/stunnel /opt/smcipmitool/BMCSecurity/linux/stunnel$(usex amd64 64 32)

	# Install symlink
	dodir /opt/bin
	dosym ../smcipmitool/SMCIPMITool /opt/bin/smcipmitool

	# Install docs
	local DOCS=( "${my_arch}/jcurses.README" "${my_arch}/ReleaseNotes.txt" "${my_arch}/SMCIPMITool_User_Guide.pdf" )
	einstalldocs
}
