# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit unpacker games

DESCRIPTION="Quake4 SDK"
HOMEPAGE="https://www.iddevnet.com/quake4/"
SRC_URI="mirror://idsoftware/quake4/source/linux/quake4-linux-${PV}-sdk.x86.run"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist mirror strip"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
	rm -rf setup.{sh,data} || die
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	doins -r *
	prepgamesdirs
}
