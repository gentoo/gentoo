# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="Jigsaw Download is a tool designed to ease the distribution of large files, for example DVD images"
HOMEPAGE="http://atterer.net/jigdo/"
SRC_URI="http://atterer.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk nls berkdb"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	berkdb? ( >=sys-libs/db-3.2 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-strip.patch
}

src_configure() {
	local myconf
	use berkdb || myconf="${myconf} --without-libdb"
	econf $(use_enable nls) ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	doicon gfx/jigdo-icon.png
	make_desktop_entry "${PN}" "${PN}" jigdo-icon
	dodoc changelog README THANKS doc/{Hacking,README-bindist,TechDetails}.txt
	dohtml doc/*.html
}
