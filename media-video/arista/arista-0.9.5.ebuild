# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="xml"

inherit distutils

DESCRIPTION="An easy to use multimedia transcoder for the GNOME Desktop"
HOMEPAGE="http://www.transcoder.org"
SRC_URI="http://programmer-art.org/media/releases/arista-transcoder/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
# Making these USE-defaults since encoding for portable devices is a very
# common use case for Arista. xvid is being added since it's required for
# DVD ripping. No gst-plugins-x264 available at this time.
IUSE="+faac kde nautilus +x264 +xvid"

DEPEND="dev-python/setuptools"
RDEPEND=">=x11-libs/gtk+-2.16:2
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 dev-python/simplejson )
	>=dev-python/pygtk-2.16:2
	dev-python/pygobject:2
	dev-python/pycairo
	dev-python/gconf-python:2
	dev-python/dbus-python
	dev-python/python-gudev
	gnome-base/librsvg
	>=media-libs/gstreamer-0.10.22:0.10
	dev-python/gst-python:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-bad:0.10
	media-plugins/gst-plugins-meta:0.10
	media-plugins/gst-plugins-ffmpeg:0.10
	x11-themes/gnome-icon-theme
	nautilus? ( dev-python/nautilus-python )
	kde? ( dev-python/librsvg-python )
	faac? ( media-plugins/gst-plugins-faac:0.10 )
	x264? ( media-plugins/gst-plugins-x264:0.10 )
	xvid? ( media-plugins/gst-plugins-xvid:0.10 )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

pkg_postinst() {
	distutils_pkg_postinst

	einfo "If you find that a format you want is not supported in Arista,"
	einfo "please make sure that you have the corresponding USE-flag enabled"
	einfo "media-plugins/gst-plugins-meta"
}
