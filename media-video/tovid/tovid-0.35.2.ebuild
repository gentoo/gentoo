# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/tovid/tovid-0.35.2.ebuild,v 1.3 2015/06/09 01:39:16 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils

DESCRIPTION="A collection of DVD authoring tools"
HOMEPAGE="http://tovid.wikia.com/wiki/Tovid_Wiki"
SRC_URI="https://github.com/tovid-suite/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-cdr/dvd+rw-tools
	dev-tcltk/tix
	|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[imagemagick,png] )
	media-sound/normalize
	>=media-sound/sox-14.3.2
	media-video/dvdauthor
	>=media-video/mjpegtools-2.0.0
	|| ( >=media-video/mplayer-1.0_rc4_p20110101[dvdnav] media-video/mpv[libmpv,dvdnav] )
	sys-devel/bc
	virtual/ffmpeg"
DEPEND="app-text/txt2tags"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	python_optimize

	# punt at least .install.log
	find "${D}" -name '*.log' -exec rm -f {} +
}

pkg_preinst() {
#	REPLACING_VERSIONS="media-video/tovid-0.34"
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "######################################################################"
	elog "You can install media-video/transcode for additional functionality. It"
	elog "will speed up the creation of animated submenus with faster seeking."
	elog "Otherwise FFmpeg/Libav will be used."
	elog "######################################################################"
	elog""
	gnome2_icon_cache_update
}
pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
