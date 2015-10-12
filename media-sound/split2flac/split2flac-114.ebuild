# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_REPO_URI="https://github.com/ftrvxmtrx/split2flac.git"

inherit bash-completion-r1
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="sh script to split one big APE/FLAC/WV/WAV audio image with CUE sheet into tracks"
HOMEPAGE="https://github.com/ftrvxmtrx/split2flac"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/ftrvxmtrx/split2flac/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
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
		mp4? ( media-sound/aacgain )
		ogg? ( media-sound/vorbisgain )
	)
	imagemagick? ( media-gfx/imagemagick )
"

src_configure() { :; }

src_compile() { :; }

src_install() {
	dobin ${PN}
	newbashcomp ${PN}-bash-completion.sh ${PN}

	dosym ${PN} /usr/bin/split2wav
	for i in mp3 mp4 ogg
	do
		use $i && dosym ${PN} /usr/bin/split2${i/mp4/m4a}
	done
}
