# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper xdg

MY_TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"

DESCRIPTION="Ghost story, told using first-person gaming technologies"
HOMEPAGE="https://www.thechineseroom.co.uk/games/dear-esther"
SRC_URI="dearesther-linux-${MY_TIMESTAMP}-bin"
S="${WORKDIR}/data"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

QA_PREBUILT="
	opt/${PN}/dearesther_linux
	opt/${PN}/bin/*.so*"

# TODO: unbundle libSDL2
RDEPEND="
	media-libs/freetype[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto /opt/${PN}
	doins -r bin dearesther platform dearesther_linux

	fperms +x /opt/${PN}/dearesther_linux
	make_wrapper ${PN} "./dearesther_linux -game dearesther" /opt/${PN}{,/bin}

	newicon dearesther.png ${PN}.png
	make_desktop_entry ${PN} "Dear Esther"

	dodoc README-linux.txt
}
