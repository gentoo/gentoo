# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic pam

DESCRIPTION="Just another screensaver application for X"
HOMEPAGE="http://www.tux.org/~bagleyd/xlockmore.html"
SRC_URI="http://www.tux.org/~bagleyd/xlock/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt debug gtk imagemagick motif nas opengl pam truetype xinerama xlockrc"

REQUIRED_USE="
	|| ( crypt pam )
	pam? ( !xlockrc )
	xlockrc? ( !pam )
"
RDEPEND="
	gtk? ( x11-libs/gtk+:2 )
	imagemagick? ( media-gfx/imagemagick )
	motif? ( >=x11-libs/motif-2.3:0 )
	nas? ( media-libs/nas )
	opengl? (
		virtual/opengl
		virtual/glu
		truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
	)
	pam? ( virtual/pam )
	truetype? ( media-libs/freetype:2 )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xineramaproto
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.46-freetype261.patch
	eautoreconf
}

src_configure() {
	local myconf=""

	if use opengl && use truetype; then
			myconf="${myconf} --with-ftgl"
			append-flags -DFTGL213
		else
			myconf="${myconf} --without-ftgl"
	fi

	econf \
		$(use_enable pam) \
		$(use_enable xlockrc) \
		$(use_with crypt) \
		$(use_with debug editres) \
		$(use_with gtk gtk2) \
		$(use_with imagemagick magick) \
		$(use_with motif) \
		$(use_with nas) \
		$(use_with opengl mesa) \
		$(use_with opengl) \
		$(use_with truetype freetype) \
		$(use_with truetype ttf) \
		$(use_with xinerama) \
		--disable-mb \
		--enable-appdefaultdir=/usr/share/X11/app-defaults \
		--enable-syslog \
		--enable-vtlock \
		--without-esound \
		--without-gtk \
		${myconf}
}

src_install() {
	einstall xapploaddir="${D}/usr/share/X11/app-defaults" \
		mandir="${D}/usr/share/man/man1" INSTPGMFLAGS=""

	pamd_mimic_system xlock auth

	if use pam; then
		fperms 755 /usr/bin/xlock
	else
		fperms 4755 /usr/bin/xlock
	fi

	dohtml docs/xlock.html
	dodoc README docs/{3d.howto,cell_automata,HACKERS.GUIDE,Purify,Revisions,TODO}
}
