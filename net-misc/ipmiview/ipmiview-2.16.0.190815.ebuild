# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 prefix

MY_DATE="$(ver_cut 4)"
MY_PN="IPMIView"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="A GUI application that allows to manage multiple target systems through BMC"
HOMEPAGE="https://www.supermicro.com/"
SRC_URI="ftp://ftp.supermicro.com/utility/${MY_PN}/Linux/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64.tar.gz"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	net-misc/stunnel
	virtual/jre:1.8
"

DEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror strip"

DIR="/usr/share/${PN}"
QA_PREBUILT="usr/lib*"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=IPMI"
	elog "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack ${A}
	mv -v ${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64 ${P} || die
}

src_prepare() {
	default

	# Extract icons for menu entries
	unzip -j -LL IPMIView20.jar images/ipmi{view,trap}.ico || die

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
	java-pkg_dolauncher ipmiview --jar IPMIView20.jar -pre "${pre}"
	java-pkg_dolauncher ipmiview-ikvm --jar iKVM.jar -pre "${pre}"
	java-pkg_dolauncher ipmiview-ikvmmicroblade --jar iKVMMicroBlade.jar -pre "${pre}"
	java-pkg_dolauncher ipmiview-jviewerx9 --jar JViewerX9.jar -pre "${pre}"
	java-pkg_dolauncher trapreceiver --jar TrapView.jar -pre "${pre}"

	exeinto ${DIR}/jre/bin
	newexe $(prefixify_ro "${FILESDIR}"/fake-java-r1.bash) java

	insinto ${DIR}/lib/BMCSecurity
	doins BMCSecurity/*.{crt,key,pem,txt}

	insinto ${DIR}/lib/BMCSecurity/linux
	doins BMCSecurity/linux/stunnel.conf

	dosym ../../../../../bin/stunnel ${DIR}/lib/BMCSecurity/linux/stunnel32
	dosym ../../../../../bin/stunnel ${DIR}/lib/BMCSecurity/linux/stunnel64

	doicon ipmi{view,trap}.ico
	make_desktop_entry ipmiview IPMIView ipmiview.ico
	make_desktop_entry trapreceiver "Trap Receiver" ipmitrap.ico

	local DOCS=( *.pdf *.txt )
	einstalldocs
}
