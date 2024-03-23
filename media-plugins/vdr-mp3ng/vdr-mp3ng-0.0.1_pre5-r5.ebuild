# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic vdr-plugin-2

MY_PV=0.9.13-MKIV-pre3
MY_P=${PN}-${MY_PV}

DESCRIPTION="VDR Plugin: play mp3 and ogg on VDR"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${PN}-0.9.13-MKIV-pre3.tar.gz
		mirror://gentoo/${PN}-pictures-0.0.1.tar.gz
		mirror://gentoo/${PN}-0.0.1_pre4-span-0.0.3.diff.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="oss vorbis"

DEPEND="media-libs/imlib2
	media-libs/libmad
	media-libs/libid3tag:=
	media-libs/libsndfile
	media-video/vdr
	sys-libs/zlib
	vorbis? ( media-libs/libvorbis )"

DOCS=(HISTORY MANUAL README README-MORONIMO examples/network.sh.example)

S=${WORKDIR}/mp3ng-0.9.13-MKIV-pre3

src_prepare() {
	vdr-plugin-2_src_prepare

	# wrt bug 595248
	append-cxxflags $(test-flags-CXX -std=gnu++03) -std=gnu++03

	eapply -p0 "${FILESDIR}/${PN}-0.0.1_pre4-gentoo.diff"
	eapply "${FILESDIR}/${PN}-0.0.1_pre4-gcc4.diff"
	eapply "${WORKDIR}/${PN}-0.0.1_pre4-span.diff"
	eapply "${FILESDIR}/${PN}-0.0.1_pre4-vdr-1.5.1.diff"
	eapply "${FILESDIR}/${PN}-0.0.1_pre4-glibc-2.10.patch"

	use !vorbis && sed -e "s:#WITHOUT_LIBVORBISFILE:WITHOUT_LIBVORBISFILE:" -i Makefile
	use oss && sed -e "s:#WITH_OSS_OUTPUT:WITH_OSS_OUTPUT:" -i Makefile

	#wrt bug 789687
	sed -e "s:MAKEDEP = g++:MAKEDEP = \$(CXX):" -i Makefile || die

	has_version ">=media-video/vdr-1.3.37" && eapply "${FILESDIR}/${PN}-0.0.1_pre4-1.3.37.diff"
	has_version ">=media-gfx/imagemagick-6.4" && eapply "${FILESDIR}/imagemagick-6.4.x.diff"

	sed -i mp3ng.c -e "s:RegisterI18n:// RegisterI18n:" || die

	# >=vdr-2.1.2
	sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" -i decoder.c || die

	#wrt bug 705372
	eapply "${FILESDIR}/${P}_gcc-9.patch"

	#wrt bug 740247, 786240
	sed -e "s:while(fgets(buffer,sizeof(buffer),f)>0:while(fgets(buffer,sizeof(buffer),f)> (char *)0:" \
		-i data-mp3.c || die
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/mp3ng
	doins	"${FILESDIR}/mp3ngsources"

	insinto /usr/share/vdr/mp3ng
	doins "${WORKDIR}/${PN}-pictures-0.0.1"/*.jpg
	doins "${S}/images/mp3MKIV-spectrum-analyzer-bg.png"

	newbin examples/mount.sh.example mount-mp3ng.sh
}
