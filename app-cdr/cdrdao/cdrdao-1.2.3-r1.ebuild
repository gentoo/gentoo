# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.2.3-r1.ebuild,v 1.10 2012/09/05 18:26:29 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
if [[ ${PV/*_rc*} ]]
then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
else
	SRC_URI="http://www.poolshark.org/src/${P/_}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="gcdmaster encode mad vorbis"

RDEPEND="virtual/cdrtools
	encode? ( >=media-sound/lame-3.99 )
	gcdmaster? (
		dev-libs/libsigc++:2
		>=dev-cpp/gtkmm-2.4:2.4
		>=dev-cpp/libgnomeuimm-2.6:2.6
		media-libs/libao
		)
	mad? (
		media-libs/libmad
		media-libs/libao
		)
	vorbis? (
		media-libs/libvorbis
		media-libs/libao
		)
	!app-cdr/cue2toc
	!dev-util/pccts"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P/_}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc212.patch
}

src_configure() {
	econf \
		$(use_with gcdmaster xdao) \
		$(use_with vorbis ogg-support) \
		$(use_with mad mp3-support) \
		$(use_with encode lame)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog CREDITS NEWS README{,.PlexDAE}
}
