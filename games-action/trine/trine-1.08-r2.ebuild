# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils unpacker

DESCRIPTION="A physics-based action game with character-dependent solutions to challenges"
HOMEPAGE="http://trine-thegame.com/"
SRC_URI="TrineUpdate4.64.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch strip"

DEPEND="
	app-admin/chrpath
	app-arch/unzip
"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libx86
	gnome-base/libglade:2.0
	media-libs/libogg
	media-libs/libpng:1.2
	>=media-libs/libsdl-1.2[opengl,sound,video]
	>=media-libs/libvorbis-1.3
	>=media-libs/openal-1.15
	>=media-libs/tiff-3.9:3
	>=sys-devel/gcc-4.3.0
	>=sys-libs/glibc-2.4
	virtual/jpeg:62
	x11-libs/gtk+:2
"

S="${WORKDIR}"
d="/opt/${PN}"
QA_PREBUILT="*"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default
	rm -v lib*/lib{gcc_s,jpeg,m,ogg,openal,png*,rt,SDL*,selinux,stdc++,tiff,vorbis*}.* || die
	chrpath --replace "${EPREFIX}${d}"/lib trine-{bin,launcher}$(usex x86 32 64) || die
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

	exeinto ${d}/lib
	doexe lib${sfx}/*

	insinto ${d}
	doins -r binds config data dev profiles *.fbz *.glade trine-logo.png

	dodoc Trine_Manual_linux.pdf Trine_updates.txt
}
