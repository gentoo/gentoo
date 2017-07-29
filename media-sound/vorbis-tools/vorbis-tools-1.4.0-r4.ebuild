# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="tools for using the Ogg Vorbis sound file format"
HOMEPAGE="http://www.vorbis.com"
SRC_URI="http://downloads.xiph.org/releases/vorbis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="flac kate nls +ogg123 speex"

RDEPEND=">=media-libs/libvorbis-1.3.0
	flac? ( media-libs/flac )
	kate? ( media-libs/libkate )
	ogg123? (
		>=media-libs/libao-1.0.0
		net-misc/curl
	)
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS="AUTHORS CHANGES README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	epatch "${FILESDIR}"/${P}-format-security.patch
	epatch "${FILESDIR}"/${P}-CVE-2014-9640.patch
	epatch "${FILESDIR}"/${P}-CVE-2014-9638.patch
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #515220
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable ogg123) \
		$(use_with flac) \
		$(use_with speex) \
		$(use_with kate)
}
