# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop gnome2-utils unpacker wrapper

TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"
DESCRIPTION="Ghost story, told using first-person gaming technologies"
HOMEPAGE="http://dear-esther.com/"
SRC_URI="dearesther-linux-${TIMESTAMP}-bin"
S="${WORKDIR}"/data

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=opt/${PN}
QA_PREBUILT="
	${MYGAMEDIR#/}/dearesther_linux
	${MYGAMEDIR#/}/bin/*.so*
"

# TODO: unbundle libSDL2
RDEPEND="
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto ${MYGAMEDIR}
	doins -r bin dearesther platform dearesther_linux

	doicon -s 256 dearesther.png
	make_desktop_entry "${PN}" "Dear Esther" dearesther
	make_wrapper ${PN} "./dearesther_linux -game dearesther" "${MYGAMEDIR}" "${MYGAMEDIR}/bin"

	dodoc README-linux.txt

	fperms +x ${MYGAMEDIR}/dearesther_linux
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
