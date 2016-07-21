# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cdrom games

DESCRIPTION="Warcraft II data for wargus (needs DOS CD)"
HOMEPAGE="http://wargus.sourceforge.net/"
SRC_URI=""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# wargus is needed for wartool (bug #578340)
DEPEND="${RDEPEND}
	games-strategy/wargus
	media-sound/cdparanoia
	media-sound/timidity++
	media-video/ffmpeg2theora"
# wrt bug #419331
RESTRICT="userpriv"

S=${WORKDIR}

src_prepare() {
	export CDROM_NAME="WARCRAFT2"
	cdrom_get_cds data/rezdat.war
}

src_compile() {
	# cdparanoia needs write acces to the cdrom device
	# this fixes sandbox violation wrt #418051
	local save_sandbox_write=${SANDBOX_WRITE}
	addwrite /dev
	"${GAMES_BINDIR}"/wartool -m -v -r "${CDROM_ROOT}"/data "${S}"/ || die
	SANDBOX_WRITE=${save_sandbox_write}
}

src_install() {
	insinto "${GAMES_DATADIR}"/stratagus/wargus
	doins -r *
	prepgamesdirs
}
