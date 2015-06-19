# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ripperx/ripperx-2.7.3.ebuild,v 1.8 2014/08/10 21:11:12 slyfox Exp $

EAPI=5
inherit eutils

MY_P=${P/x/X}
MY_PN=${PN/x/X}

DESCRIPTION="a GTK program to rip CD audio tracks and encode them to the Ogg, MP3, or FLAC formats"
HOMEPAGE="http://sourceforge.net/projects/ripperx"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="media-libs/id3lib
	media-sound/cdparanoia
	media-sound/lame
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# AC_CHECK_LIB(m, ceilf, [], [MATH_LIB="-lm" MATH_LIB=""]) #401867
	sed -i -e '/ripperX_LDADD/s:=:= -lm:' src/Makefile.in || die

	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-pkgconfig.patch
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc BUGS CHANGES FAQ README* TODO
	doicon src/xpms/${MY_PN}-icon.xpm
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN}-icon
}
