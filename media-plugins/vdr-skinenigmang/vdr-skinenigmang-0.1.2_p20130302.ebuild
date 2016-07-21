# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vdr-plugin-2

HG_REVISION="0147c0ee6222bd10714ef36f42dcee94495bdb92"
HG_REVISION_DATE="20130302"

DESCRIPTION="VDR - Skin Plugin: enigma-ng"
HOMEPAGE="http://andreas.vdr-developer.org/enigmang/"
SRC_URI="http://projects.vdr-developer.org/git/vdr-plugin-skinenigmang.git/snapshot/vdr-plugin-skinenigmang-${HG_REVISION}.tar.gz ->
		vdr-skinenigmang-0.1.2_p${HG_REVISION_DATE}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick"

DEPEND=">=media-video/vdr-1.5.7"

RDEPEND="${DEPEND}
		x11-themes/skinenigmang-logos
		imagemagick? ( media-gfx/imagemagick[cxx] )"

S="${WORKDIR}/vdr-plugin-skinenigmang-${HG_REVISION}"

src_prepare() {
	# remove untranslated languages files
	rm po/{cs_CZ,da_DK,el_GR,et_EE,hr_HR,nn_NO,pl_PL,pt_PT,ro_RO,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare

	use imagemagick && sed -i "s:#HAVE_IMAGEMAGICK:HAVE_IMAGEMAGICK:" Makefile

	sed -i Makefile \
		-e "s:-I/usr/local/include/ImageMagick:\$(shell pkg-config --cflags MagickCore):" \
		-e "s:-lMagick++:\$(shell pkg-config --libs Magick++):"
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*
}
