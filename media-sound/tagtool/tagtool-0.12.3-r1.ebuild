# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Audio Tag Tool Ogg/Mp3 Tagger"
HOMEPAGE="http://pwp.netcabo.pt/paol/tagtool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="mp3 +vorbis"
REQUIRED_USE="|| ( mp3 vorbis )"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2.6
	mp3? ( >=media-libs/id3lib-3.8.3-r6 )
	vorbis? ( >=media-libs/libvorbis-1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
)

src_prepare() {
	# QA fix for wrong boolean value
	sed -i -e 's/Terminal=False/Terminal=false/' data/tagtool.desktop.in || die

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mp3) \
		$(use_enable vorbis)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		GNOME_SYSCONFDIR="${D}/etc" \
		sysdir="${D}/usr/share/applets/Multimedia" \
		install

	dodoc ChangeLog NEWS README TODO THANKS
}
