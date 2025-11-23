# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P="${P/-/_}"

DESCRIPTION="A digital dreamscape simulation game"
HOMEPAGE="https://www.introversion.co.uk/introversion/"
SRC_URI="
	amd64? ( ${MY_P}_amd64.tar.gz )
	x86? ( ${MY_P}_i386.tar.gz )
"
S="${WORKDIR}/${PN}"
LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch mirror strip"

RDEPEND="
	media-libs/libglvnd[X]
	media-libs/libogg
	media-libs/libsdl[opengl,sound,video]
	media-libs/libvorbis
	virtual/glu
"

QA_PREBUILT="opt/${PN}/${PN}"

pkg_nofetch() {
		einfo "This was only available from The Humble Introversion Bundle in 2011."
		einfo "If you bought that, then download ${A} and move"
		einfo "it to your distfiles directory."
}

src_unpack() {
	default

	if use x86; then
		mv ${PN^} ${PN} || die
	fi
}

src_install() {
	exeinto /opt/${PN}
	newexe ${PN}.bin.x86$(usex amd64 '_64' '') ${PN}
	dosym ../../opt/${PN}/${PN} /usr/bin/${PN}

	insinto /opt/${PN}
	doins *.dat

	doicon darwinian.png
	make_desktop_entry ${PN} ${PN^} darwinian

	dodoc {changes,readme-linux}.txt
}
