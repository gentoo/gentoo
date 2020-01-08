# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="a command line utility to split mp3 and ogg files without decoding"
HOMEPAGE="http://mp3splt.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ppc ~ppc64 sparc x86"
IUSE="flac"

RDEPEND=">=media-libs/libmp3splt-0.9.2-r1[flac?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_configure() {
	econf \
		--enable-oggsplt_symlink \
		$(use_enable flac flacsplt_symlink) \
		--disable-dependency-tracking
}

src_install() {
	default
	dodoc AUTHORS ChangeLog NEWS README TODO
}
