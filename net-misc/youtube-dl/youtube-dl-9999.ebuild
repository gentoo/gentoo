# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1 git-r3 optfeature

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://youtube-dl.org/"
EGIT_REPO_URI="https://github.com/ytdl-org/${PN}.git"

LICENSE="Unlicense"
SLOT="0"
IUSE="+yt-dlp"
# tests need deprecated nose, and given upstream is still refusing to make new
# releases or modernize anything (wants to support old python more) it will
# likely be last rited along with any revdeps that still can't use yt-dlp
RESTRICT="test"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	yt-dlp? ( >=net-misc/yt-dlp-2022.2.4-r1 )
	!yt-dlp? ( !net-misc/yt-dlp )"

#distutils_enable_tests nose

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i '/flake8/d' Makefile || die
}

python_compile_all() {
	emake youtube-dl.{bash-completion,fish,zsh}
}

python_test() {
	emake offlinetest
}

python_install_all() {
	dodoc AUTHORS ChangeLog README.md docs/supportedsites.md
	#doman youtube-dl.1 # would require pandoc in live ebuild

	newbashcomp youtube-dl.bash-completion youtube-dl

	insinto /usr/share/zsh/site-functions
	newins youtube-dl.zsh _youtube-dl

	insinto /usr/share/fish/vendor_completions.d
	doins youtube-dl.fish

	# keep man pages / completions either way given they are useful
	# for yt-dlp's compatibility wrapper which tries to mimic options
	use !yt-dlp || rm -r "${ED}"/usr/{lib/python-exec,bin} || die
}

pkg_postinst() {
	optfeature "converting and merging tracks on some sites" media-video/ffmpeg
	optfeature "embedding metadata thumbnails in MP4/M4A files" media-video/atomicparsley
	optfeature "downloading videos streamed via RTMP" media-video/rtmpdump
	optfeature "downloading videos streamed via MMS/RTSP" media-video/mplayer media-video/mpv

	ewarn "Note that it is preferable to use net-misc/yt-dlp over youtube-dl for"
	ewarn "latest features and site support. youtube-dl is only kept maintained for"
	ewarn "compatibility with older software (notably its python module, yt-dlp has"
	ewarn "a 'bin/youtube-dl' compatibility wrapper but not for the module)."

	if use yt-dlp; then
		ewarn
		ewarn "USE=yt-dlp is enabled, so said compatibility wrapper will be used. Man pages"
		ewarn "and completions for youtube-dl were still installed but may have slight usage"
		ewarn "differences and does not read the same configuration files. It is recommended"
		ewarn "to use the yt-dlp command directly instead."
	fi
}
