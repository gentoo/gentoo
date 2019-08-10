# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_DATE="$(ver_cut 4)"
MY_PN="${PN/smc-/}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Updates the BIOS and IPMI firmware and system settings on Supermicro mainboards"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_PN}_${MY_PV}_Linux_x86_64_${MY_DATE}.tar.gz"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="module"

RDEPEND="module? ( sys-apps/smc-sum-driver )"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}/${MY_PN}_${MY_PV}_Linux_x86_64"

DOCS=( "ReleaseNote.txt" "SUM_UserGuide.pdf" "sumrc.sample" "ExternalData/SMCIPID.txt" "ExternalData/VENID.txt" )

QA_PREBUILT="usr/bin/smc-sum"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=SUM"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	newbin sum smc-sum

	einstalldocs
}
