# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="dedicated server for GTA3 multiplayer"
HOMEPAGE="http://mtavc.com/"
SRC_URI="http://files.gonnaplay.com/201/MTAServer0_5-linux.tar.gz"

LICENSE="MTA-0.5"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

RDEPEND="virtual/libstdc++"
DEPEND=""

S=${WORKDIR}

QA_PREBUILT="/opt/${PN}/MTAServer"
QA_EXECSTACK="/opt/${PN}/MTAServer"

src_prepare() {
	default

	sed -i 's:NoName:Gentoo:' mtaserver.conf || die
}

src_install() {
	local dir=/opt/${PN}
	local files="banned.lst motd.txt mtaserver.conf"
	local f

	dobin "${FILESDIR}"/mtavc
	sed -i -e "s:GENTOO_DIR:${dir}:" "${D}/usr/bin"/mtavc

	exeinto "${dir}"
	newexe MTAServer${PV} MTAServer
	insinto /etc/${PN}
	doins ${files}
	dodoc README CHANGELOG
	for f in ${files} ; do
		dosym /etc/${PN}/${f} "${dir}"/${f}
	done
}
