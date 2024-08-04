# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info optfeature systemd

MY_DATE="$(ver_cut 4)"
MY_PN="${PN^^}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Supermicro Thin-Agent Service for monitoring through the BMC/IPMI"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="https://www.supermicro.com/wftp/utility/${MY_PN}/${MY_PN}_${MY_PV}_build.${MY_DATE}.zip"
S="${WORKDIR}"

LICENSE="BSD supermicro"
SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="
	net-misc/networkmanager
	sys-apps/ethtool
	sys-apps/net-tools
	sys-apps/smartmontools
	app-alternatives/bc
	sys-fs/lsscsi
	sys-fs/mdadm"

BDEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

QA_PREBUILT="usr/bin/IPMITAS"

DOCS=(
	"clireadme.txt"
	"ReleaseNotes.txt"
	"software_license_agreement_pv.pdf"
	"TAS_UserGuide.pdf"
)

CONFIG_CHECK="~IPMI_DEVICE_INTERFACE ~IPMI_HANDLER ~IPMI_SI"

src_unpack() {
	unpack ${A}
	unpack "${S}"/${MY_PN}_${MY_PV}_build.${MY_DATE}_Linux.tar.gz
}

src_install() {
	dobin TAS/$(usex amd64 '64' '32')bit/IPMITAS

	insinto /etc/supermicro
	doins "${FILESDIR}"/tas.ini

	dodir /var/log/tas
	local logfiles=( {starttime,tas,tas.com}.log )
	for logfile in ${logfiles[@]}; do
		touch "${ED}"/var/log/tas/${logfile} || die
		dosym ../../var/log/tas/${logfile} /etc/supermicro/${logfile}
	done

	newinitd "${FILESDIR}"/tas.initd tas
	systemd_newunit "${FILESDIR}"/tas.service tas.service

	einstalldocs
}

pkg_postinst() {
	optfeature "Broadcom controller management" sys-block/storcli
	optfeature "LSI controller management" sys-block/sas3ircu
}
