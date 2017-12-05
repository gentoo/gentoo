# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# these are ELFs that include a ZIP (504b0304) appended to it
#   dd if=Trine.64.run of=Trine.64.zip ibs=$((0x342a8)) skip=1
#   dd if=Trine.32.run of=Trine.32.zip ibs=$((0x31c24)) skip=1
# but `unzip` will skip the ELF at the start.  both ELFs contain
# the same zip appended, so only need to hash one of them.

EAPI=6
inherit unpacker eutils

DESCRIPTION="A physics-based action game with character-dependent solutions to challenges"
HOMEPAGE="http://trine-thegame.com/"
SRC_URI="Trine.64.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND="
	dev-libs/libx86
	gnome-base/libglade
	>=sys-devel/gcc-4.3.0
	>=sys-libs/glibc-2.4"

S=${WORKDIR}

d=/opt/${PN}
QA_PREBUILT="${d#/}/trine-launcher ${d#/}/trine-bin ${d#/}/lib*/lib*.so*"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unpack_zip ${A}
	rm lib*/lib{gcc_s,m,rt,selinux}.so.? || die
}

src_install() {
	local b bb
	local sfx=$(usex x86 32 64)

	doicon Trine.xpm
	for b in bin launcher ; do
		bb="trine-${b}"
		exeinto ${d}
		newexe ${bb}${sfx} ${bb}
		make_wrapper ${bb} "./${bb}" "${d}"
		make_desktop_entry ${bb} "Trine ${b}" Trine
	done

	exeinto ${d}/lib${sfx}
	doexe lib${sfx}/*

	insinto ${d}
	doins -r binds config data dev profiles *.fbz *.glade trine-logo.png

	dodoc Trine_Manual_linux.pdf Trine_updates.txt
}
