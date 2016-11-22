# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2 flag-o-matic

MY_PV=0.9.13-MKIV-pre3
MY_P=${PN}-${MY_PV}

S=${WORKDIR}/mp3ng-0.9.13-MKIV-pre3

DESCRIPTION="VDR Plugin: play mp3 and ogg on VDR"
HOMEPAGE="http://www.glaserei-franz.de/VDR/Moronimo2/vdrplugins.htm"
SRC_URI="http://www.glaserei-franz.de/VDR/Moronimo2/downloads/${MY_P}.tar.gz
		mirror://gentoo/${PN}-pictures-0.0.1.tar.gz
		mirror://gentoo/${PN}-0.0.1_pre4-span-0.0.3.diff.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vorbis oss imagemagick"

DEPEND=">=media-video/vdr-1.6
		media-libs/libmad
		media-libs/libid3tag
		sys-libs/zlib
		media-libs/libsndfile
		vorbis? ( media-libs/libvorbis )
		imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
		!imagemagick? ( media-libs/imlib2 )"

src_prepare() {
	vdr-plugin-2_src_prepare

	# wrt bug 595248
	append-cxxflags $(test-flags-CXX -std=gnu++03) -std=gnu++03

	epatch "${FILESDIR}/${PN}-0.0.1_pre4-gentoo.diff"
	epatch "${FILESDIR}/${PN}-0.0.1_pre4-gcc4.diff"
	epatch "${DISTDIR}/${PN}-0.0.1_pre4-span-0.0.3.diff.tar.gz"
	epatch "${FILESDIR}/${PN}-0.0.1_pre4-vdr-1.5.1.diff"
	epatch "${FILESDIR}/${PN}-0.0.1_pre4-glibc-2.10.patch"

	use !vorbis && sed -i "s:#WITHOUT_LIBVORBISFILE:WITHOUT_LIBVORBISFILE:" Makefile
	use oss && sed -i "s:#WITH_OSS_OUTPUT:WITH_OSS_OUTPUT:" Makefile
	use imagemagick && sed -i Makefile \
		-e "s:HAVE_IMLIB2:#HAVE_IMLIB2:" \
		-e "s:#HAVE_MAGICK:HAVE_MAGICK:"

	has_version ">=media-video/vdr-1.3.37" && epatch "${FILESDIR}/${PN}-0.0.1_pre4-1.3.37.diff"
	has_version ">=media-gfx/imagemagick-6.4" && epatch "${FILESDIR}/imagemagick-6.4.x.diff"

	sed -i mp3ng.c -e "s:RegisterI18n:// RegisterI18n:"

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" -i decoder.c
	fi
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/mp3ng
	doins	"${FILESDIR}/mp3ngsources"

	insinto /usr/share/vdr/mp3ng
	doins "${WORKDIR}/${PN}-pictures-0.0.1"/*.jpg
	doins "${S}/images/mp3MKIV-spectrum-analyzer-bg.png"

	newbin examples/mount.sh.example mount-mp3ng.sh

	dodoc HISTORY MANUAL README README-MORONIMO examples/network.sh.example
}
