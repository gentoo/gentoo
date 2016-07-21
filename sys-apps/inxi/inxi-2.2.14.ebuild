# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A newer, better system information script for irc, administration, and system troubleshooters."
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://inxi.googlecode.com/svn/tarballs/${PN}_${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=app-shells/bash-3.0
	sys-apps/coreutils
	sys-apps/gawk
	sys-apps/grep
	sys-apps/pciutils
	sys-process/procps
	sys-apps/sed
	"

S=${WORKDIR}

src_install() {
	dobin ${PN}
	doman ${PN}.1.gz
}

pkg_postinst() {
	einfo "To view a short or full system information."
	einfo "inxi -b for short information."
	einfo "inxi -F for full information."
	einfo "inxi also provides verbose levels '-v1 to -v7'."
	einfo "inxi -h for help."
}
