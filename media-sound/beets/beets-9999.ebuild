# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 bash-completion-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/beetbox/beets.git"
	inherit git-r3
else
	MY_PV=${PV/_beta/-beta.}
	MY_P=${PN}-${MY_PV}
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Media library management system for obsessive-compulsive music geeks"
HOMEPAGE="https://beets.io/ https://pypi.org/project/beets/"

LICENSE="MIT"
SLOT="0"
IUSE="badfiles chromaprint cors discogs doc ffmpeg gstreamer icu lastfm mpd replaygain test thumbnail webserver"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/jellyfish-0.7.1[${PYTHON_MULTI_USEDEP}]
		dev-python/munkres[${PYTHON_MULTI_USEDEP}]
		>=media-libs/mutagen-1.33[${PYTHON_MULTI_USEDEP}]
		>=dev-python/python-musicbrainz-ngs-0.4[${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		>=dev-python/six-1.9[${PYTHON_MULTI_USEDEP}]
		dev-python/unidecode[${PYTHON_MULTI_USEDEP}]
		badfiles? (
			media-libs/flac
			media-sound/mp3val
		)
		chromaprint? (
			dev-python/pyacoustid[${PYTHON_MULTI_USEDEP}]
			media-libs/chromaprint[tools]
		)
		discogs? (
			dev-python/discogs-client[${PYTHON_MULTI_USEDEP}]
		)
		ffmpeg? (
			media-video/ffmpeg:0[encode]
		)
		gstreamer? (
			media-libs/gst-plugins-bad:1.0
			media-libs/gst-plugins-good:1.0
		)
		icu? (
			dev-db/sqlite[icu]
		)
		lastfm? (
			dev-python/pylast[${PYTHON_MULTI_USEDEP}]
		)
		mpd? (
			dev-python/bluelet[${PYTHON_MULTI_USEDEP}]
			dev-python/python-mpd[${PYTHON_MULTI_USEDEP}]
		)
		replaygain? (
			gstreamer? (
				dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
				media-plugins/gst-plugins-libav:1.0
			)
			!gstreamer? ( media-sound/mp3gain )
		)
		thumbnail? (
			dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
			|| (
				dev-python/pillow[${PYTHON_MULTI_USEDEP}]
				media-gfx/imagemagick
			)
		)
		webserver? (
			dev-python/flask[${PYTHON_MULTI_USEDEP}]
			cors? (
				dev-python/flask-cors[${PYTHON_MULTI_USEDEP}]
			)
		)
	')"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? (
		dev-python/sphinx
	)
	$(python_gen_cond_dep '
		test? (
			dev-python/beautifulsoup[${PYTHON_MULTI_USEDEP}]
			dev-python/flask[${PYTHON_MULTI_USEDEP}]
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
			dev-python/rarfile[${PYTHON_MULTI_USEDEP}]
			dev-python/responses[${PYTHON_MULTI_USEDEP}]
			dev-python/wheel[${PYTHON_MULTI_USEDEP}]
		)
	')"

PATCHES=(
	"${FILESDIR}/${PV}-0001-compatibility-with-breaking-changes-to-the-ast-modul.patch"
	"${FILESDIR}/${PV}-0002-Disable-test_completion.patch"
)

DOCS=( README.rst docs/changelog.rst )

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	rm test/test_art.py || die "Failed to remove test_art.py"
	rm test/test_discogs.py || die "Failed to remove test_discogs.py"
	rm test/test_embyupdate.py || die "Failed to remove test_embyupdate.py"
	rm test/test_lastgenre.py || die "Failed to remove test_lastgenre.py"
	rm test/test_spotify.py || die "Failed to remove test_spotify.py"
	# Not working and dropped in master
	rm test/test_mediafile.py || die "Failed to remove test_mediafile.py"
	if ! use ffmpeg; then
		rm test/test_convert.py || die "Failed to remove test_convert.py"
	fi
	if ! use mpd; then
		rm test/test_player.py || die "Failed to remove test_player.py"
		rm test/test_mpdstats.py || die "Failed to remove test_mpdstats.py"
	fi
	if ! use replaygain; then
		rm test/test_replaygain.py || die "Failed to remove test_replaygain.py"
	fi
	if ! use thumbnail; then
		rm test/test_thumbnails.py || die "Failed to remove test_thumbnails.py"
	fi
	if ! use webserver; then
		rm test/test_web.py || die "Failed to remove test_web.py"
	fi
}

python_compile_all() {
	use doc && esetup.py build_sphinx -b html --build-dir=docs/build
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/*
	use doc && local HTML_DOCS=( docs/build/html/. )
	einstalldocs

	${PYTHON} "${ED}/usr/bin/beet" completion > "${T}/beet.bash" || die
	newbashcomp "${T}/beet.bash" beet
	insinto /usr/share/zsh/site-functions
	newins "${WORKDIR}/${P}/extra/_beet" _beet
}
