# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hoh-bin/hoh-bin-1.01.ebuild,v 1.16 2015/06/01 21:33:24 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="PC remake of the spectrum game, Head Over Heels"
HOMEPAGE="http://retrospec.sgn.net/games/hoh/"
SRC_URI="http://retrospec.sgn.net/download.php?id=63\&path=games/hoh/bin/hohlin-${PV/./}.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND="x11-libs/libX11[abi_x86_32(-)]"

S=${WORKDIR}/hoh-install-${PV}

# bug #448420
QA_PREBUILT="
/opt/HoH/data/runtime/libstdc++-libc6.2-2.so.3
/opt/HoH/data/HoH
"

src_compile() {
	cat > "${T}/hoh" <<-EOF
		#!/bin/bash
		export LD_LIBRARY_PATH="${GAMES_PREFIX_OPT}/HoH/data/runtime"
		cd "${GAMES_PREFIX_OPT}/HoH/data"
		exec ./HoH \$@
EOF
}

src_install() {
	local DATADIR="${GAMES_PREFIX_OPT}/HoH/data"
	local DOCDIR="${GAMES_PREFIX_OPT}/HoH/docs"

	dogamesbin "${T}/hoh"
	dodir "${DATADIR}" "${DOCDIR}"
	cp -pPRf data/* "${D}/${DATADIR}/" || die
	cp -pPRf docs/* "${D}/${DOCDIR}/"  || die
	make_desktop_entry hoh "Head Over Heels"
	prepgamesdirs
}
