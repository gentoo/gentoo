# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eapi7-ver

MY_DATE="$(ver_cut 4)"
MY_PN="IPMIView"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="A GUI application that allows to manage multiple target systems through BMC"
HOMEPAGE="https://www.supermicro.com/"
SRC_URI="amd64? ( ftp://ftp.supermicro.com/utility/${MY_PN}/Linux/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux_x64.tar.gz )
	x86? ( ftp://ftp.supermicro.com/utility/${MY_PN}/Linux/${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux.tar.gz )"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="net-misc/stunnel
	virtual/jre"

RESTRICT="bindist fetch mirror strip"

S="${WORKDIR}"

QA_PREBUILT="opt/ipmiview/libiKVM*.so
	opt/ipmiview/libSharedLibrary*.so"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=IPMI"
	elog "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack ${A}

	# Extract *.jar to get *.ico logos for the menu entries
	unpack ${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux$(usex amd64 '_x64')/IPMIView20.jar
}

src_install() {
	local my_arch="${MY_PN}_${MY_PV}_build.${MY_DATE}_bundleJRE_Linux$(usex amd64 '_x64')"

	exeinto /opt/ipmiview
	doexe ${my_arch}/iKVM ${my_arch}/IPMIView20 ${my_arch}/JViewerX9 ${my_arch}/TrapReceiver

	exeinto /opt/ipmiview
	doexe ${my_arch}/$(usex amd64 '*64' '*32').so

	if use amd64; then
		exeinto /opt/ipmiview
		doexe ${my_arch}/*64.jnilib
	fi

	touch "${T}"/account.properties "${T}"/email.properties "${T}"/IPMIView.properties "${T}"/timeout.properties || die
	insinto /opt/ipmiview
	doins ${my_arch}/*.jar ${my_arch}/*.lax "${T}"/*.properties

	dosym ../../etc/java-config-2/current-system-vm/jre /opt/ipmiview/jre

	insinto /opt/ipmiview/BMCSecurity
	doins ${my_arch}/BMCSecurity/*.crt ${my_arch}/BMCSecurity/*.key ${my_arch}/BMCSecurity/*.pem ${my_arch}/BMCSecurity/*.txt

	insinto /opt/ipmiview/BMCSecurity/linux
	doins ${my_arch}/BMCSecurity/linux/stunnel.conf

	dosym ../../../../usr/bin/stunnel /opt/ipmiview/BMCSecurity/linux/stunnel$(usex amd64 64 32)

	newicon images/Ipmiview.ico ipmiview.ico
	newicon images/Ipmitrap.ico ipmitrap.ico

	make_desktop_entry ipmiview IPMIView /usr/share/pixmaps/ipmiview.ico Network Path=/opt/ipmiview
	make_desktop_entry trapreceiver "Trap Receiver" /usr/share/pixmaps/ipmitrap.ico Network Path=/opt/ipmiview

	dodir /opt/bin
	dosym ../ipmiview/iKVM /opt/bin/ikvm
	dosym ../ipmiview/IPMIView20 /opt/bin/ipmiview
	dosym ../ipmiview/JViewerX9 /opt/bin/jviewerx9
	dosym ../ipmiview/TrapReceiver /opt/bin/trapreceiver

	local DOCS=( "${my_arch}/IPMIView20_User_Guide.pdf" "${my_arch}/IPMIView_MicroBlade_User_Guide.pdf" "${my_arch}/IPMIView_SuperBlade_User_Guide.pdf" "${my_arch}/ReleaseNotes.txt" )
	einstalldocs
}
