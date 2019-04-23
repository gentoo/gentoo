# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eapi7-ver linux-info systemd

MY_DATE="$(ver_cut 4)"
MY_PN="${PN^^}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Supermicro Thin-Agent Service for monitoring through the BMC/IPMI"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_PN}_${MY_PV}_build.${MY_DATE}.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="BSD supermicro"
SLOT="0"

RDEPEND="net-misc/networkmanager
	sys-apps/ethtool
	sys-apps/net-tools
	sys-apps/smartmontools
	sys-block/storcli
	sys-devel/bc
	sys-fs/lsscsi
	sys-fs/mdadm"
DEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/IPMITAS"

DOCS=(
	"clireadme.txt"
	"ReleaseNotes.txt"
	"software_license_agreement_pv.pdf"
	"TAS_UserGuide.pdf"
)

CONFIG_CHECK="~IPMI_DEVICE_INTERFACE ~IPMI_HANDLER ~IPMI_SI"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=TAS"
	elog "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack ${A}
	unpack "${S}"/${MY_PN}_${MY_PV}_build.${MY_DATE}_Linux.tar.gz
}

src_install() {
	dobin $(usex amd64 '64' '32')bit/IPMITAS

	insinto /etc/supermicro
	doins "${FILESDIR}"/tas.ini

	dodir /var/log/tas
	local logfiles=( {starttime,tas,tas.com}.log )
	for logfile in ${logfiles[@]}; do
		touch "${ED%/}"/var/log/tas/${logfile} || die
		dosym ../../var/log/tas/${logfile} /etc/supermicro/${logfile}
	done

	newinitd "${FILESDIR}"/tas.initd tas
	systemd_newunit "${FILESDIR}"/tas.service tas.service

	einstalldocs
}
