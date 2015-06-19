# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/tovid/tovid-0.34_p20120123.ebuild,v 1.2 2013/09/09 04:43:08 floppym Exp $

# svn checkout http://tovid.googlecode.com/svn/trunk/tovid tovid-${PV}
# note: see quickrelease file in the top source directory

EAPI=3

PYTHON_DEPEND="2:2.7"
PYTHON_USE_WITH="tk"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils gnome2-utils

DESCRIPTION="A collection of DVD authoring tools"
HOMEPAGE="http://tovid.wikia.com/wiki/Tovid_Wiki"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.gz"
#SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-cdr/cdrdao
	app-cdr/dvd+rw-tools
	dev-python/pycairo
	dev-tcltk/tix
	|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[imagemagick,png] )
	media-sound/normalize
	>=media-sound/sox-14.3.2
	media-video/dvdauthor
	>=media-video/mjpegtools-2.0.0
	>=media-video/mplayer-1.0_rc4_p20110101
	>=media-video/transcode-1.1.5
	media-video/vcdimager
	sys-devel/bc
	virtual/ffmpeg"
DEPEND="app-text/txt2tags"

DOCS="AUTHORS ChangeLog README"

src_install() {
	distutils_src_install

	# punt at least .install.log
	find "${ED}" -name '*.log' -exec rm -f {} +
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
