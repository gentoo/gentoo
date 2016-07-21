# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils

DESCRIPTION="Music Player For Console"
HOMEPAGE="http://mpfc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="alsa gpm mad vorbis oss wav cdda nls"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.9.0 )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e 's:../src/file.h ../src/file.h:../src/file.h:' \
		libmpfc/Makefile.am || die #335449

	epatch "${FILESDIR}"/${P}-libdir.patch \
		"${FILESDIR}"/${PN}-gcc4.patch \
		"${FILESDIR}"/${P}-mathlib.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-INT_MAX.patch

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa) \
		$(use_enable gpm) \
		$(use_enable mad mp3) \
		$(use_enable vorbis ogg) \
		$(use_enable oss) \
		$(use_enable wav) \
		$(use_enable cdda audiocd) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /etc
	doins mpfcrc || die

	dodoc AUTHORS ChangeLog NEWS README
}
