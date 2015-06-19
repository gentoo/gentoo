# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/coe2/coe2-2007-r1.ebuild,v 1.3 2015/04/15 06:51:01 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Precursor to the Dominions series"
HOMEPAGE="http://www.shrapnelgames.com/Illwinter/CoE2/"
SRC_URI="http://download.shrapnelgames.com/downloads/${PN}_${PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="media-libs/libsdl"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/coe

# bug #430026
QA_PREBUILT="/opt/coe2/coe_linux"

src_prepare() {
	rm -r *.{dll,exe} old || die
	if use amd64 ; then
		mv -f coe_linux64bit coe_linux || die
	fi
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	doins *.{bgm,smp,trp,trs,wrl}
	dodoc history.txt manual.txt readme.txt
	exeinto "${GAMES_PREFIX_OPT}/${PN}"
	doexe coe_linux

	games_make_wrapper ${PN} "./coe_linux" "${GAMES_PREFIX_OPT}/${PN}"
	make_desktop_entry ${PN} "Conquest of Elysium 2"

	# Slots for saved games.
	# The game shows e.g. "EMPTY SLOT 0?", but it works.
	local f slot state_dir=${GAMES_STATEDIR}/${PN}
	dodir "${state_dir}"
	for slot in {0..4} ; do
		f=save${slot}
		dosym "${state_dir}/save${slot}" "${dir}/${f}"
		echo "empty slot ${slot}" > "${D}${state_dir}/${f}" || die "echo"
		fperms 660 "${state_dir}/${f}"
	done

	prepgamesdirs
}
