# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6})
inherit bash-completion-r1 distutils-r1 readme.gentoo-r1

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://rg3.github.com/youtube-dl/"
SRC_URI="https://youtube-dl.org/downloads/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="+offensive test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/nose[coverage(+)] )
"

S="${WORKDIR}/${PN}"

python_prepare_all() {
	if ! use offensive; then
		sed -i -e "/..version../s|'$|+gentoo.no.offensive.sites'|g" \
			youtube_dl/version.py || die
		# these have single line import statements
		local xxx=(
			alphaporno anysex behindkink camwithher chaturbate eporner
			eroprofile extremetube foxgay goshgay hellporno hentaistigma
			hornbunny keezmovies lovehomeporn mofosex myvidster porn91 porncom
			pornflip pornhd pornotube pornovoisines pornoxo ruleporn sexu
			slutload spankbang spankwire sunporno thisav tube8 vporn
			watchindianporn xbef xnxx xtube xvideos xxxymovies youjizz youporn
		)
		# these have multi-line import statements
		local mxxx=(
			drtuber fourtube motherless pornhub redtube tnaflix xhamster
		)
		# do single line imports
		sed -i \
			-e $( printf '/%s/d;' ${xxx[@]} ) \
			youtube_dl/extractor/extractors.py \
			|| die

		# do multiple line imports
		sed -i \
			-e $( printf '/%s/,/)/d;' ${mxxx[@]} ) \
			youtube_dl/extractor/extractors.py \
			|| die

		sed -i \
			-e $( printf '/%s/d;' ${mxxx[@]} ) \
			youtube_dl/extractor/generic.py \
			|| die

		rm \
			$( printf 'youtube_dl/extractor/%s.py ' ${xxx[@]} ) \
			$( printf 'youtube_dl/extractor/%s.py ' ${mxxx[@]} ) \
			test/test_age_restriction.py \
			|| die
	fi

	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile
}

python_test() {
	emake test
}

python_install_all() {
	dodoc README.txt
	doman ${PN}.1

	newbashcomp ${PN}.bash-completion ${PN}

	insinto /usr/share/zsh/site-functions
	newins youtube-dl.zsh _youtube-dl

	insinto /usr/share/fish/completions
	doins youtube-dl.fish

	distutils-r1_python_install_all

	rm -r "${ED}"/usr/etc || die
	rm -r "${ED}"/usr/share/doc/youtube_dl || die
}

pkg_postinst() {
	elog "youtube-dl(1) / https://bugs.gentoo.org/355661 /"
	elog "https://github.com/rg3/youtube-dl/blob/master/README.md#faq :"
	elog
	elog "${PN} works fine on its own on most sites. However, if you want"
	elog "to convert video/audio, you'll need avconf (media-video/libav) or"
	elog "ffmpeg (media-video/ffmpeg). On some sites - most notably YouTube -"
	elog "videos can be retrieved in a higher quality format without sound."
	elog "${PN} will detect whether avconv/ffmpeg is present and"
	elog "automatically pick the best option."

	elog
	elog "Videos or video formats streamed via RTMP protocol can only be"
	elog "downloaded when rtmpdump (media-video/rtmpdump) is installed."
	elog "Downloading MMS and RTSP videos requires either mplayer"
	elog "(media-video/mplayer) or mpv (media-video/mpv) to be installed."
}
