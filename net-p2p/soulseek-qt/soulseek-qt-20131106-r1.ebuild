# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/soulseek-qt/soulseek-qt-20131106-r1.ebuild,v 1.1 2015/03/21 20:03:46 jlec Exp $

EAPI=5

DESCRIPTION="Official binary Qt SoulSeek client"
HOMEPAGE="http://www.soulseekqt.net/"
BINARY_NAME="SoulseekQt-${PV:0:4}-$((${PV:4:2}))-$((${PV:6:2}))"
BASE_URI="http://www.soulseekqt.net/SoulseekQT/Linux/${BINARY_NAME}"
SRC_URI="
	x86? ( ${BASE_URI}.tgz )
	amd64? ( ${BASE_URI}-64bit.tgz )
	"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-qt/qtgui:4
	dev-qt/qtcore:4"

S="${WORKDIR}"

RESTRICT="mirror"

QA_PREBUILT="opt/bin/.*"

src_install() {
	use amd64 && BINARY_NAME="${BINARY_NAME}-64bit"
	into /opt
	newbin "${BINARY_NAME}" "${PN}"
}
