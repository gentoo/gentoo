# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ftrvxmtrx/split2flac.git"
else
	SRC_URI="https://github.com/ftrvxmtrx/split2flac/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="sh script to split an APE/FLAC/WV/WAV audio image with CUE sheet into tracks"
HOMEPAGE="https://github.com/ftrvxmtrx/split2flac"

LICENSE="MIT"
SLOT="0"
IUSE="enca flake imagemagick mac mp3 mp4 ogg replaygain wavpack"

RDEPEND="
	app-cdr/cuetools
	media-sound/shntool[mac?]
	virtual/libiconv
	media-libs/flac
	enca? ( app-i18n/enca )
	flake? ( media-sound/flake )
	mp3? ( media-sound/lame || ( media-libs/mutagen media-libs/id3lib ) )
	mp4? ( media-libs/faac media-libs/libmp4v2:0[utils] )
	ogg? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		ogg? ( media-sound/vorbisgain )
	)
	imagemagick? ( media-gfx/imagemagick )"

src_install() {
	dobin ${PN}
	newbashcomp ${PN}-bash-completion.sh ${PN}

	dosym ${PN} /usr/bin/split2wav

	local i
	for i in mp3 mp4 ogg; do
		use $i && dosym ${PN} /usr/bin/split2${i/mp4/m4a}
	done

	einstalldocs
}
