# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="22000M"
CHECKREQS_DISK_USR="21600M"
inherit check-reqs desktop wrapper

DESCRIPTION="Sequel to 1988 Wasteland, post-apocalyptic computer RPG inspiration for Fallout"
HOMEPAGE="https://wasteland.inxile-entertainment.com/"
SRC_URI="gog_wasteland_2_${PV}.tar.gz"
S="${WORKDIR}/Wasteland 2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist fetch"

QA_PREBUILT="opt/${PN}/*"

RDEPEND="
	dev-libs/atk[abi_x86_32(-)]
	dev-libs/glib:2[abi_x86_32(-)]
	media-libs/fontconfig:1.0[abi_x86_32(-)]
	media-libs/freetype:2[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]"

pkg_nofetch() {
	einfo "Please buy Wasteland 2"
	einfo "from https://www.gog.com/ and"
	einfo "download ${SRC_URI}"
	einfo "and move it to your DISTDIR directory."
	einfo
	einfo "This ebuild was tested with the CLASSICAL edition."
	einfo "If it works with the deluxe edition too, please"
	einfo "open a bug report. If not, open a bug report too."
}

src_install() {
	local dir=/opt/${PN}

	# over 20GB of data
	dodir ${dir}
	mv game/WL2_Data "${ED}"/${dir}/ || die

	exeinto ${dir}
	doexe game/WL2

	make_wrapper ${PN} ./WL2 ${dir}

	newicon support/gog-wasteland-2.png ${PN}.png
	make_desktop_entry ${PN} "Wasteland 2"

	dodoc docs/*.pdf
}
