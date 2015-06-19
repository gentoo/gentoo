# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tagtool/tagtool-0.12.3.ebuild,v 1.11 2012/05/05 08:53:12 mgorny Exp $

EAPI=2

DESCRIPTION="Audio Tag Tool Ogg/Mp3 Tagger"
HOMEPAGE="http://pwp.netcabo.pt/paol/tagtool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="vorbis mp3"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2.6
	mp3? ( >=media-libs/id3lib-3.8.3-r6 )
	vorbis? ( >=media-libs/libvorbis-1 )
	!mp3? ( !vorbis? ( >=media-libs/libvorbis-1 ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf

	use mp3 || myconf="${myconf} --disable-mp3"
	use vorbis || myconf="${myconf} --disable-vorbis"

	if ! use mp3 && ! use vorbis; then
		einfo "One of USE flags is required, enabling vorbis for you."
		myconf="--disable-mp3"
	fi

	econf ${myconf}
}

src_install() {
	emake \
		DESTDIR="${D}" \
		GNOME_SYSCONFDIR="${D}/etc" \
		sysdir="${D}/usr/share/applets/Multimedia" \
		install || die

	dodoc ChangeLog NEWS README TODO THANKS
}
