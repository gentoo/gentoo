# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1 readme.gentoo-r1

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://youtube-dl.org/ https://github.com/ytdl-org/youtube-dl/"
SRC_URI="https://youtube-dl.org/downloads/${PV}/${P}.tar.gz"
S=${WORKDIR}/${PN}

LICENSE="public-domain"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
SLOT="0"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

src_prepare() {
	sed -i -e '/flake8/d' Makefile || die
	distutils-r1_src_prepare
}

python_test() {
	emake offlinetest
}

python_install_all() {
	doman youtube-dl.1

	newbashcomp youtube-dl.bash-completion youtube-dl

	insinto /usr/share/zsh/site-functions
	newins youtube-dl.zsh _youtube-dl

	insinto /usr/share/fish/vendor_completions.d
	doins youtube-dl.fish

	distutils-r1_python_install_all

	rm -r "${ED}"/usr/etc || die
	rm -r "${ED}"/usr/share/doc/youtube_dl || die
}

pkg_postinst() {
	if ! has_version media-video/ffmpeg; then
		elog "${PN} works fine on its own on most sites. However, if you want"
		elog "to convert video/audio, you'll need media-video/ffmpeg."
		elog "On some sites - most notably YouTube - videos can be retrieved in"
		elog "a higher quality format without sound. ${PN} will detect whether"
		elog "ffmpeg is present and automatically pick the best option."
	fi
	if ! has_version media-video/rtmpdump; then
		elog
		elog "Videos or video formats streamed via RTMP protocol can only be"
		elog "downloaded when media-video/rtmpdump is installed."
	fi
	if ! has_version media-video/mplayer && ! has_version media-video/mpv; then
		elog
		elog "Downloading MMS and RTSP videos requires either media-video/mplayer"
		elog "or media-video/mpv to be installed."
	fi
	if ! has_version media-video/atomicparsley; then
		elog
		elog "Install media-video/atomicparsley if you want ${PN} to embed thumbnails"
		elog "from the metadata into the resulting MP4/M4A files."
	fi
}
