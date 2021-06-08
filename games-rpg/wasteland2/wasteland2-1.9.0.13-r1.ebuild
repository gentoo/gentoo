# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="22000M"
CHECKREQS_DISK_USR="21600M"
inherit check-reqs desktop gnome2-utils wrapper

DESCRIPTION="Sequel to 1988 Wasteland, post-apocalyptic computer RPG inspiration for Fallout"
HOMEPAGE="https://wasteland.inxile-entertainment.com/"
SRC_URI="gog_wasteland_2_${PV}.tar.gz"
S="${WORKDIR}/Wasteland 2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist fetch mirror"

QA_PREBUILT="opt/${PN}/*"

RDEPEND="
	>=dev-libs/atk-2.12.0-r1[abi_x86_32(-)]
	>=dev-libs/glib-2.40.0-r1:2[abi_x86_32(-)]
	>=media-libs/fontconfig-2.10.92:1.0[abi_x86_32(-)]
	>=media-libs/freetype-2.5.3-r1:2[abi_x86_32(-)]
	>=x11-libs/cairo-1.12.16-r2[abi_x86_32(-)]
	>=x11-libs/gdk-pixbuf-2.30.8:2[abi_x86_32(-)]
	>=x11-libs/gtk+-2.24.24:2[abi_x86_32(-)]
	>=x11-libs/pango-1.36.5[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
	>=virtual/glu-9.0-r1[abi_x86_32(-)]
	virtual/opengl
"

pkg_nofetch() {
	einfo
	einfo "Please buy Wasteland 2"
	einfo "from https://www.gog.com/ and"
	einfo "download ${SRC_URI}"
	einfo "and move it to your DISTDIR directory."
	einfo
	einfo "This ebuild was tested with the CLASSICAL edition."
	einfo "If it works with the deluxe edition too, please"
	einfo "open a bug report. If not, open a bug report too."
	einfo
}

src_install() {
	local dir=/opt/${PN}

	# over 20GB of data
	dodir ${dir}
	mv game/WL2_Data "${ED}/${dir}"/ || die
	exeinto ${dir}
	doexe game/WL2

	make_wrapper ${PN} ./WL2 "${dir}"
	newicon -s 256 support/gog-wasteland-2.png ${PN}.png
	make_desktop_entry ${PN} "Wasteland 2"

	dodoc docs/*.pdf
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
