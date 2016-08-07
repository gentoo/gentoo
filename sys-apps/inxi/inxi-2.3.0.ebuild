# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# change MY_COMMITID for trivial BUMP
MY_COMMITID=ebf6ff7
MY_GITUSERNAME=smxi

DESCRIPTION="Commandline script to print hardware information for irc and administration."

# Avoid variables in HOMEPAGE
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://github.com/${MY_GITUSERNAME}/${PN}/tarball/${MY_COMMITID} -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-3.0
	sys-apps/pciutils
	"

S="${WORKDIR}/${MY_GITUSERNAME}-${PN}-${MY_COMMITID}"

src_install() {
	dobin ${PN}
	doman ${PN}.1.gz
}

pkg_postinst() {
	einfo "To view a short or full system information."
	einfo "inxi -b for short information."
	einfo "inxi -F for full information."
	einfo "inxi provides seven verbose levels -v1 to -v7."
	einfo "inxi -h for help."
}
