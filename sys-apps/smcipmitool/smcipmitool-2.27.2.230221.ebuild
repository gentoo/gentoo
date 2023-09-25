# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 prefix

MY_DATE="$(ver_cut 4)"
MY_PN="SMCIPMITool"
MY_PN_SRC_URI="SMCIPMItool"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="An out-of-band utility for interfacing with SuperBlade and IPMI devices via CLI"
HOMEPAGE="https://www.supermicro.com/"
SRC_URI="https://www.supermicro.com/Bios/sw_download/549/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64.tar.gz"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	net-misc/stunnel
	sys-libs/ncurses-compat:5
	virtual/jre:1.8
"

RESTRICT="bindist mirror"

DIR="/usr/share/${PN}"
QA_PREBUILT="usr/lib*"

src_unpack() {
	unpack ${A}
	mv -v ${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64 ${P} || die
}

src_prepare() {
	default

	# Don't use their scary launchers
	rm -v lax.jar || die
}

src_compile() {
	:
}

src_install() {
	java-pkg_dojar *.jar
	java-pkg_doso *64.so

	local pre=$(prefixify_ro "${FILESDIR}"/launcher-pre.bash)
	java-pkg_dolauncher smcipmitool-ikvm --jar iKVM.jar -pre "${pre}"
	java-pkg_dolauncher smcipmitool-jviewersmc --jar JViewerSMC.jar -pre "${pre}"
	java-pkg_dolauncher smcipmitool-jviewerx9 --jar JViewerX9.jar -pre "${pre}"
	java-pkg_dolauncher smcipmitool --jar SMCIPMITool.jar -pre "${pre}"

	exeinto "${DIR}"/jre/bin
	newexe $(prefixify_ro "${FILESDIR}"/fake-java.bash) java

	insinto "${DIR}"/lib/BMCSecurity
	doins BMCSecurity/*.{crt,key,pem,txt}

	insinto "${DIR}"/lib/BMCSecurity/linux
	doins BMCSecurity/linux/stunnel.conf

	dosym ../../../../../bin/stunnel "${DIR}"/lib/BMCSecurity/linux/stunnel32
	dosym ../../../../../bin/stunnel "${DIR}"/lib/BMCSecurity/linux/stunnel64

	local DOCS=(
		"jcurses.README"
		"ReleaseNotes.txt"
		"SMCIPMITool_User_Guide.pdf"
	)

	einstalldocs
}
