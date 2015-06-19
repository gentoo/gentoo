# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-graphtft/vdr-graphtft-0.3.7.ebuild,v 1.2 2013/06/17 20:08:39 scarabeus Exp $

EAPI="5"

inherit vdr-plugin-2 flag-o-matic

RESTRICT="test"

DESCRIPTION="VDR plugin: GraphTFT"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Graphtft-plugin"
SRC_URI="http://www.jwendel.de/vdr/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

IUSE_THEMES="+theme_deepblue theme_avp theme_deeppurple theme_poetter"
IUSE="${IUSE_THEMES} directfb graphtft-fe imagemagick touchscreen"

DEPEND=">=media-video/vdr-1.7.27[graphtft]
		media-libs/imlib2[png,jpeg]
		gnome-base/libgtop
		>=virtual/ffmpeg-0.4.8_p20090201
		imagemagick? ( media-gfx/imagemagick[png,jpeg,cxx] )
		directfb? ( dev-libs/DirectFB )
		graphtft-fe? ( media-libs/imlib2[png,jpeg,X] )"

RDEPEND="${DEPEND}"

PDEPEND="theme_deepblue? ( =x11-themes/vdrgraphtft-deepblue-0.3.1 )
		theme_avp? ( =x11-themes/vdrgraphtft-avp-0.3.1 )
		theme_deeppurple? ( =x11-themes/vdrgraphtft-deeppurple-0.3.2 )
		theme_poetter? ( =x11-themes/vdrgraphtft-poetter-0.3.2 )"

PATCHES=("${FILESDIR}/${P}_gentoo.diff"
		"${FILESDIR}/${P}_makefile.diff"
		"${FILESDIR}/${P}_gcc-4.4.x.diff")

src_prepare() {

	# remove untranslated Language
	rm "${S}"/po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	sed -i Makefile -e "s:  WITH_X_COMM = 1:#WITH_X_COMM = 1:"

	! use touchscreen && sed -i Makefile  \
		-e "s:WITH_TOUCH = 1:#WITH_TOUCH = 1:"

	use graphtft-fe && sed -i Makefile \
		-e "s:#WITH_X_COMM:WITH_X_COMM:"

	# libav9 support
	sed -i \
		-e 's:avcodec.h>:avcodec.h>\n#include <libavutil/mem.h>:' \
		imlibrenderer/dvbrenderer/mpeg2encoder.c || die

	vdr-plugin-2_src_prepare

	remove_i18n_include graphtft.h setup.h

	# UINT64_C is needed by ffmpeg headers
	append-cxxflags -D__STDC_CONSTANT_MACROS

	if has_version ">=media-video/vdr-1.7.33"; then
		sed -i dspitems.c \
			-e "s:int timerMatch = 0:eTimerMatch timerMatch = tmNone:"
	fi
}

src_compile() {
	vdr-plugin-2_src_compile

	if use graphtft-fe; then
		cd "${S}"/graphtft-fe
		emake
	fi
}

src_install() {
	vdr-plugin-2_src_install

	dodoc "${S}"/documents/{README,HISTORY,HOWTO.Themes,INSTALL}

	if use graphtft-fe; then
		cd "${S}"/graphtft-fe && dobin graphtft-fe
		doinit graphtft-fe
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	if use graphtft-fe; then
		echo
		elog "Graphtft-fe user:"
		elog "Edit /etc/conf.d/vdr.graphtft"
		elog "/etc/init.d/graphtft-fe start"
		echo
	fi
}
