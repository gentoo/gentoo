# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	media-plugins/gst-plugins-meta:1.0[flac?,mp3?,vorbis?,wavpack?]
"

src_install() {
	distutils-r1_src_install
	doman build/man/*
}
