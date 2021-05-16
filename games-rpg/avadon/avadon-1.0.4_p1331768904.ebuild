# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils unpacker

DESCRIPTION="Epic fantasy role-playing adventure in an enormous and unique world"
HOMEPAGE="https://www.spiderwebsoftware.com/avadon"
SRC_URI="avadon-linux-${PV#*_p}-bin.txt" # .txt is odd but that's what Humble Bundle sends.
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch bindist"

QA_PREBUILT="opt/${PN}/Avadon"

RDEPEND="media-libs/libsdl[opengl,video]
	media-libs/openal"

DEPEND="app-arch/unzip"

S="${WORKDIR}/data"

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

	insinto "${dir}"
	doins -r "avadon files" icon.bmp

	exeinto "${dir}"
	newexe Avadon-$(usex amd64 amd64 x86) Avadon
	dosym "../..${dir}"/Avadon /usr/bin/${PN}

	newicon -s 512 Avadon.png ${PN}.png
	make_desktop_entry ${PN} "Avadon: The Black Fortress"

	dodoc README-linux.txt
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
