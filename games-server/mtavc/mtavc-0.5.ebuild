# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

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

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/${PN}/MTAServer"
QA_EXECSTACK="${GAMES_PREFIX_OPT:1}/${PN}/MTAServer"

src_prepare() {
	sed -i 's:NoName:Gentoo:' mtaserver.conf || die
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	local files="banned.lst motd.txt mtaserver.conf"
	local f

	dogamesbin "${FILESDIR}"/mtavc
	sed -i -e "s:GENTOO_DIR:${dir}:" "${D}${GAMES_BINDIR}"/mtavc

	exeinto "${dir}"
	newexe MTAServer${PV} MTAServer
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins ${files}
	dodoc README CHANGELOG
	for f in ${files} ; do
		dosym "${GAMES_SYSCONFDIR}"/${PN}/${f} "${dir}"/${f}
	done

	prepgamesdirs
}
