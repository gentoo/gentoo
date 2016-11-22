# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="MJPG-streamer takes JPGs from Linux-UVC compatible webcams"
HOMEPAGE="https://sourceforge.net/projects/mjpg-streamer"
SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

INPUT_PLUGINS="input_testpicture input_control input_file input_uvc"
OUTPUT_PLUGINS="output_file output_udp output_http output_autofocus output_rtsp"
IUSE_PLUGINS="${INPUT_PLUGINS} ${OUTPUT_PLUGINS} +input_file +output_http"
IUSE="${IUSE_PLUGINS} www v4l"
REQUIRED_USE="|| ( ${INPUT_PLUGINS} )
	|| ( ${OUTPUT_PLUGINS} )
	v4l? ( input_uvc )"

RDEPEND="virtual/jpeg
	v4l? ( input_uvc? ( media-libs/libv4l ) )"
DEPEND="${RDEPEND}
	input_testpicture? ( media-gfx/imagemagick )"

src_prepare() {
	epatch "${FILESDIR}/${PV}-make-var-instead-of-cmd.patch"

	local flag switch

	for flag in ${IUSE_PLUGINS}; do
		use ${flag} && switch='' || switch='#'
		sed -i \
			-e "s|^#*PLUGINS +\?= ${flag}.so|${switch}PLUGINS += ${flag}.so|" \
			Makefile
	done
}

src_compile() {
	local v4l=$(use v4l && use input_uvc && echo 'USE_LIBV4L2=true')
	emake ${v4l}
}

src_install() {
	into /usr
	dobin ${PN//-/_}
	dolib.so *.so

	if use www ; then
		insinto /usr/share/${PN}
		doins -r www
	fi

	dodoc README TODO

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	elog "Remember to set an input and output plugin for mjpg-streamer."

	if use www ; then
		echo
		elog "An example webinterface has been installed into"
		elog "/usr/share/mjpg-streamer/www for your usage."
	fi
}
