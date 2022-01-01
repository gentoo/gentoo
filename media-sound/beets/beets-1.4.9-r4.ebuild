# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{6..8} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 bash-completion-r1 optfeature

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
IUSE="doc test"
RESTRICT="!test? ( test )"

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
			dev-db/sqlite[icu]
			dev-python/beautifulsoup[${PYTHON_MULTI_USEDEP}]
			dev-python/bluelet[${PYTHON_MULTI_USEDEP}]
			dev-python/discogs-client[${PYTHON_MULTI_USEDEP}]
			dev-python/flask[${PYTHON_MULTI_USEDEP}]
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/pyacoustid[${PYTHON_MULTI_USEDEP}]
			dev-python/pylast[${PYTHON_MULTI_USEDEP}]
			dev-python/python-mpd[${PYTHON_MULTI_USEDEP}]
			dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
			|| (
				dev-python/pillow[${PYTHON_MULTI_USEDEP}]
				media-gfx/imagemagick
			)
			dev-python/rarfile[${PYTHON_MULTI_USEDEP}]
			dev-python/responses[${PYTHON_MULTI_USEDEP}]
			dev-python/wheel[${PYTHON_MULTI_USEDEP}]
			media-libs/chromaprint[tools]
			media-libs/flac
			media-libs/gst-plugins-bad:1.0
			media-libs/gst-plugins-good:1.0
			media-sound/mp3val
			media-sound/mp3gain
			|| (
				dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
				media-plugins/gst-plugins-libav:1.0
			)
			media-video/ffmpeg:0[encode]
		)
	')"

PATCHES=(
	"${FILESDIR}/${PV}-0001-compatibility-with-breaking-changes-to-the-ast-modul.patch"
	"${FILESDIR}/${PV}-0002-Disable-test_completion.patch"
	"${FILESDIR}/${PV}-0003-Try-to-work-around-a-Werkzeug-change.patch"
)

DOCS=( README.rst docs/changelog.rst )

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Tests that need network
	rm test/test_art.py || die "Failed to remove test_art.py"
	rm test/test_discogs.py || die "Failed to remove test_discogs.py"
	rm test/test_embyupdate.py || die "Failed to remove test_embyupdate.py"
	rm test/test_lastgenre.py || die "Failed to remove test_lastgenre.py"
	rm test/test_spotify.py || die "Failed to remove test_spotify.py"
	# Not working and dropped in master
	rm test/test_mediafile.py || die "Failed to remove test_mediafile.py"
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

	elog "Optional dependencies:"
	optfeature "badfiles support" "media-libs/flac media-sound/mp3val"
	optfeature "chromaprint support" "dev-python/pyacoustid media-libs/chromaprint[tools]"
	optfeature "discogs support" dev-python/discogs-client
	optfeature "ffmpeg support" media-video/ffmpeg[encode]
	optfeature "gstreamer support" "media-libs/gst-plugins-bad media-libs/gst-plugins-good"
	optfeature "icu support" dev-db/sqlite[icu]
	optfeature "lastfm support" dev-python/pylast
	optfeature "mpd support" "dev-python/bluelet dev-python/python-mpd"
	optfeature "replaygain with gstreamer support" "dev-python/pygobject media-plugins/gst-plugins-libav"
	optfeature "replaygain without gstreamer support" media-sound/mp3gain
	optfeature "thumbnail support" dev-python/pyxdg "dev-python/pillow media-gfx/imagemagick"
	optfeature "webserver support" dev-python/flask
	optfeature "webserver cors support" dev-python/flask-cors
}
