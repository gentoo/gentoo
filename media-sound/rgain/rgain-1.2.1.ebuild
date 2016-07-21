# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Set of programmes and Python modules to deal with Replay Gain information"
HOMEPAGE="https://bitbucket.org/fk/rgain"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 vorbis wavpack"

DEPEND=">=dev-python/docutils-0.9"
RDEPEND="media-libs/mutagen
	dev-python/pygobject:3[$PYTHON_USEDEP]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-base:1.0[vorbis?]
	flac? ( media-plugins/gst-plugins-flac:1.0 )
	mp3? ( media-plugins/gst-plugins-mad:1.0 )
	wavpack? ( media-plugins/gst-plugins-wavpack:1.0 )
"

src_install() {
	distutils-r1_src_install
	doman build/man/*
}
