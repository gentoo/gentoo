# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/devede/devede-3.22.0.ebuild,v 1.2 2014/08/10 20:57:55 slyfox Exp $

EAPI=4

PYTHON_DEPEND="2:2.7"

inherit multilib python

DESCRIPTION="Program to create video CDs and DVDs, suitable to be played in home DVD players"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="http://www.rastersoft.com/descargas/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# from upstream ChangeLog in 3.21.0: Now uses FFMpeg as the default backend
IUSE="+ffmpeg"

RDEPEND="dev-python/dbus-python
	dev-python/pycairo
	dev-python/pygobject:2
	>=dev-python/pygtk-2.16
	media-video/dvdauthor
	media-video/mplayer
	media-video/vcdimager
	virtual/cdrtools
	ffmpeg? ( virtual/ffmpeg[mp3] )"
DEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_install() {
	./install.sh DESTDIR="${D}" libdir="/usr/$(get_libdir)" \
	pkgdocdir=/usr/share/doc/${PF} prefix=/usr || die
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}
	elog "To create DIVX/MPEG4 files, be sure that MPlayer is compiled with LAME support."
	elog "In this case you want to check for both the encode and mp3 USE flags."
	elog "To change the font used to render the subtitles, choose a TrueType font you like"
	elog "and copy it in \$HOME/.spumux directory, renaming it to devedesans.ttf."
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
