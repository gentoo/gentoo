# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Extracts audio tracks from audio CD image to separate tracks"
HOMEPAGE="https://code.google.com/p/flacon/"
SRC_URI="https://flacon.googlecode.com/files/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="flac mac mp3 mp4 ogg replaygain tta wavpack"

RDEPEND="
	dev-python/PyQt4[X]
	dev-python/chardet
	media-sound/shntool[mac?]
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	mp4? ( media-libs/faac )
	ogg? ( media-sound/vorbis-tools )
	tta? ( media-sound/ttaenc )
	wavpack? ( media-sound/wavpack )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		ogg? ( media-sound/vorbisgain )
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .

	sed -e '/cd $(INST_DIR) && python -mcompileall ./d' -i Makefile || die
}

src_compile() { :; }

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
