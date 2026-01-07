# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature

DESCRIPTION="Utilities to manipulate and convert cue and toc files"
HOMEPAGE="https://github.com/svend/cuetools"
SRC_URI="https://github.com/svend/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	docinto extras
	dodoc extras/{cueconvert.cgi,*.txt}
}

pkg_postinst() {
	optfeature "FLAC support" 'media-libs/flac'
	optfeature "MP3 support" 'media-sound/mp3info'
	optfeature "Vorbis support" 'media-sound/vorbis-tools'
}
