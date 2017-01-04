# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="programmer's text editor and development environment"
HOMEPAGE="http://zoinks.mikelockwood.com"
SRC_URI="http://${PN}.mikelockwood.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libXt"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}/${PN}-cpp14.patch" )

src_prepare() {
	default
	sed -i -e 's:-g -Werror::g' configure* || die
}

src_configure() {
	econf $(use_enable nls)	--disable-imlib
}

src_install() {
	default
	doicon ide/Pixmaps/${PN}.xpm
	make_desktop_entry ${PN} "Zoinks!" ${PN} "Utility;TextEditor"
}

pkg_postinst() {
	if ! [[ ${REPLACING_VERSIONS} ]]; then
		elog "If you see this message when starting zoinks:"
		elog "zoinks: TFont.cpp:40: TFont::TFont(const char*): Assertion \`fFontSet' failed."
		elog "You need to install media-fonts/font-adobe-{75,100dpi}"
	fi
}
