# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-audiorecorder/vdr-audiorecorder-0.1.0_pre14-r3.ebuild,v 1.1 2014/04/19 09:45:24 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

MY_P=${P/_pre/-pre}

DESCRIPTION="VDR plugin: automatically record radio-channels and split it into tracks according to RadioText-Info"
HOMEPAGE="http://www.a-land.de/audiorecorder/"
SRC_URI="http://www.zulu-entertainment.de/files/${PN}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S=${WORKDIR}/${MY_P#vdr-}

DEPEND=">=media-video/vdr-1.6.0
		media-libs/taglib
		virtual/ffmpeg[encode,mp3]
		>=dev-libs/tinyxml-2.6.1[stl]"

RDEPEND="${DEPEND}"

src_prepare() {
	# remove untranslated po files
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,it_IT,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	epatch "${FILESDIR}/${P}-shared-tinyxml.diff"

	vdr-plugin-2_src_prepare

	sed -i "s:include <avcodec.h>:include <libavcodec/avcodec.h>:" convert.h audiorecorder.c
	sed -i "s:RegisterI18n:// RegisterI18n:" audiorecorder.c

	# UINT64_C is needed by ffmpeg headers
	append-cxxflags -D__STDC_CONSTANT_MACROS

	epatch "${FILESDIR}/${P}_obsolete-i18n.diff"
	epatch "${FILESDIR}/${P}-ffmpeg-1.patch"
	epatch "${FILESDIR}/${P}-libav9.patch"
	epatch "${FILESDIR}/${P}_compilefix.diff"
}

src_install() {
	vdr-plugin-2_src_install
	keepdir /var/vdr/audiorecorder
	chown -R vdr:vdr "${D}"/var/vdr

	insinto /etc/vdr/plugins/audiorecorder
	doins "${S}"/contrib/audiorecorder.conf
}
