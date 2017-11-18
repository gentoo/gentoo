# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=5
inherit games

DESCRIPTION="The Killer Quake Patch"
HOMEPAGE="http://kqp.horoy.com/"
SRC_URI="http://www.gamers.org/pub/idgames2/quakec/compilations/kqp220z.zip
	mirror://gentoo/kqp220z.zip"

LICENSE="quake1-killer"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	echo ">>> Unpacking kqp220z.zip to ${PWD}"
	unzip -qoL "${DISTDIR}"/kqp220z.zip || die "unpacking kqp220z.zip failed"
}

src_install() {
	insinto "${GAMES_DATADIR}/quake1/killer"
	doins -r *
	prepgamesdirs
}
