# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="A desktop session recorder producing Ogg video/audio files"
HOMEPAGE="http://recordmydesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="alsa jack"

RDEPEND="sys-libs/zlib
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXdamage
	media-libs/libvorbis
	media-libs/libogg
	media-libs/libtheora[encode]
	x11-libs/libICE
	x11-libs/libSM
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	sed -i \
		-e 's:shmstr.h:shmproto.h:g' \
		src/rmd_{getzpixmap.c,update_image.c} || die

	# fix weird Framerates with new libtheora
	epatch "${FILESDIR}/${PV}-fix_new_theora.patch"

	# fix check for jack support
	epatch "${FILESDIR}/${PV}-fix-libjack-check.patch"

	eapply_user

	eautoreconf
}

src_configure() {
	econf \
		--enable-dependency-tracking \
		$(use_enable !alsa oss) \
		$(use_enable jack)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README || die
}
