# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Single-user single-tasking operating system for 32 bit Atari computer emulators"
HOMEPAGE="http://emutos.sourceforge.net"
SRC_URI="mirror://sourceforge/emutos/${PN}-512k-${PV}.zip
	mirror://sourceforge/emutos/${PN}-256k-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN}
	doins */*.img
	dodoc ${PN}-512k-${PV}/{readme,doc/{announce,authors,changelog,status}}.txt
}
