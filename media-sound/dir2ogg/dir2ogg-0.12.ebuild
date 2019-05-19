# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MY_PR=$(ver_cut 1-2)
DESCRIPTION="Converts mp3, m4a, wma, and wav files to Ogg Vorbis format"
HOMEPAGE="https://jak-linux.org/projects/dir2ogg/"
SRC_URI="https://jak-linux.org/projects/${PN}/${MY_PR}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="aac flac mac mp3 musepack wavpack wma"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=media-libs/mutagen-1.11[${PYTHON_USEDEP}]
	media-sound/vorbis-tools[ogg123]
	aac? ( || (
		media-libs/faad2
		media-video/mplayer ) )
	flac? ( || (
		media-libs/flac
		media-video/mplayer ) )
	mac? ( || (
		media-sound/mac
		media-video/mplayer ) )
	mp3? ( || (
		media-sound/mpg123
		media-sound/lame
		media-video/mplayer
		media-sound/mpg321 ) )
	musepack? ( || (
		>=media-sound/musepack-tools-444
		media-video/mplayer ) )
	wavpack? ( || (
		media-sound/wavpack
		media-video/mplayer ) )
	wma? ( media-video/mplayer )"

src_install() {
	python_doscript dir2ogg
	doman dir2ogg.1
	einstalldocs
}
