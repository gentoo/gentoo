# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

DESCRIPTION="Epic fantasy role-playing adventure in an enormous and unique world"
HOMEPAGE="https://www.spiderwebsoftware.com/avadon"
SRC_URI="avadon-linux-${PV#*_p}-bin.txt" # .txt is odd but that's what Humble Bundle sends.
S="${WORKDIR}/data"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

QA_PREBUILT="opt/${PN}/Avadon"

RDEPEND="
	media-libs/libsdl[opengl,video]
	media-libs/openal"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir=/opt/${PN}

	insinto ${dir}
	doins -r "avadon files" icon.bmp

	exeinto ${dir}
	newexe Avadon-$(usex amd64 amd64 x86) Avadon
	dosym ../..${dir}/Avadon /usr/bin/${PN}

	newicon Avadon.png ${PN}.png
	make_desktop_entry ${PN} "Avadon: The Black Fortress"

	dodoc README-linux.txt
}
