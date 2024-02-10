# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="
	bs ca cs da de el es_AR es_CO es fr hu it ja nl no pl pt_BR pt_PT ru sv tr
	zh_CN zh_TW
"
inherit plocale xdg-utils

DESCRIPTION="MS-Explorer-like minimalist file manager for X"
HOMEPAGE="http://roland65.free.fr/xfe/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug nls startup-notification"

RDEPEND="
	x11-libs/fox:1.6[png,truetype]
	media-libs/fontconfig
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXft
	startup-notification? (
		x11-libs/libxcb:=
		x11-libs/startup-notification
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
	)
"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

src_prepare() {
	default

	cat >po/POTFILES.skip || die <<-EOF
	src/icons.cpp
	xfe.desktop.in.in
	xfi.desktop.in.in
	xfp.desktop.in.in
	xfv.desktop.in.in
	xfw.desktop.in.in
	EOF

	# malformed LINGUAS file
	# recent intltool expects newline for every linguas
	sed -i \
		-e '/^#/!s:\s\s*:\n:g' \
		po/LINGUAS || die

	# remove not selected locales
	rm_locale() { sed -i -e "/${1}/d" po/LINGUAS || die ;}
	plocale_for_each_disabled_locale rm_locale
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable startup-notification sn) \
		--enable-minimalflags
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
