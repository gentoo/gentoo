# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Online radio streaming player"
HOMEPAGE="http://radiotray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-apps/dbus[X]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-ugly:0.10
	media-plugins/gst-plugins-alsa:0.10
	media-plugins/gst-plugins-libmms:0.10
	media-plugins/gst-plugins-ffmpeg:0.10
	media-plugins/gst-plugins-mad:0.10
	media-plugins/gst-plugins-ogg:0.10
	media-plugins/gst-plugins-soup:0.10
	media-plugins/gst-plugins-vorbis:0.10"

DEPEND="dev-python/pyxdg[${PYTHON_USEDEP}]"
