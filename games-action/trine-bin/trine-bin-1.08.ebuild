# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/trine-bin/trine-bin-1.08.ebuild,v 1.6 2015/03/31 00:48:37 mr_bones_ Exp $

# these are ELFs that include a ZIP (504b0304) appended to it
#   dd if=Trine.64.run of=Trine.64.zip ibs=$((0x342a8)) skip=1
#   dd if=Trine.32.run of=Trine.32.zip ibs=$((0x31c24)) skip=1
# but `unzip` will skip the ELF at the start.  both ELFs contain
# the same zip appended, so only need to hash one of them.

EAPI=5
inherit unpacker games eutils

DESCRIPTION="a physics-based action game where diff characters allow diff solutions to challenges"
HOMEPAGE="http://trine-thegame.com/"
SRC_URI="Trine.64.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=sys-libs/glibc-2.4
	>=sys-devel/gcc-4.3.0
	dev-libs/libx86
	gnome-base/libglade"

S=${WORKDIR}

d=${GAMES_PREFIX_OPT}/${PN}
QA_PRESTRIPPED="${d#/}/trine-launcher ${d#/}/trine-bin ${d#/}/lib*/lib*.so*"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unpack_zip ${A}
	rm lib*/lib{gcc_s,m,rt,selinux}.so.?
}

src_install() {
	local b bb
	local sfx=$(use x86 && echo 32 || echo 64)

	doicon Trine.xpm
	for b in bin launcher ; do
		bb="trine-${b}"
		exeinto ${d}
		newexe ${bb}${sfx} ${bb}
		games_make_wrapper ${bb} "./${bb}" "${d}"
		make_desktop_entry ${bb} "Trine ${b}" Trine
	done

	exeinto ${d}/lib${sfx}
	doexe lib${sfx}/*

	insinto ${d}
	doins -r binds config data dev profiles *.fbz *.glade trine-logo.png

	dodoc Trine_Manual_linux.pdf Trine_updates.txt

	prepgamesdirs
}
