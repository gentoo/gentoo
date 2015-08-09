# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

MY_P="${P}-dev2"
S="${WORKDIR}/music-${PV}-dev2"

DESCRIPTION="VDR plugin: music"
HOMEPAGE="http://www.vdr.glaserei-franz.de/vdrplugins.htm"
SRC_URI="http://www.glaserei-franz.de/VDR/Moronimo/files/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+imagemagick debug graphtft sndfile vorbis"

DEPEND=">=media-video/vdr-1.6.0
		media-libs/libmad
		media-libs/libid3tag
		graphtft? ( media-gfx/imagemagick[png] )
		imagemagick? ( media-gfx/imagemagick[png] )
		sndfile? ( media-libs/libsndfile )
		vorbis? ( media-libs/libvorbis )
		!imagemagick? (
			!graphtft? ( media-libs/imlib2[png] )
		)"

RDEPEND="sys-process/at
		media-sound/id3v2
		graphtft? ( >=media-plugins/vdr-graphtft-0.1.5 )"

src_prepare() {
#	# prepare sources with new Makefile handling
#	cp "${FILESDIR}/music.mk" "${S}"/Makefile

	# clean up from untranslated .po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,it_IT,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare

	use !vorbis && sed -i Makefile -e "s:#WITHOUT_LIBVORBISFILE=1:WITHOUT_LIBVORBISFILE=1:"
	use !sndfile && sed -i Makefile -e "s:#WITHOUT_LIBSNDFILE=1:WITHOUT_LIBSNDFILE=1:"
	use !debug && sed -i Makefile -e "s:DEBUG=1:#DEBUG=1:"
	use graphtft || use imagemagick && sed -i Makefile \
		-e "s:#HAVE_MAGICK=1:HAVE_MAGICK=1:" \
		-e "s:#MAGICKDIR=:MAGICKDIR=:"
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/music
	doins -r moronsuite/music/*
	chown -R vdr:vdr "${D}"/etc/vdr/plugins/music
}
