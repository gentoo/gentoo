# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_COMMIT=c2a22b3e2590d896d4b0a8fd298f505cc1d787f5 #because upstream refuses to tag commits with version numbers
MY_SHORTCOMMIT=${MY_COMMIT:0:7}

DESCRIPTION="Commandline script to print hardware information for irc and administration."

HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://github.com/smxi/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-3.0
	sys-apps/pciutils
	"

S="${WORKDIR}/smxi-${PN}-${MY_SHORTCOMMIT}"

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
