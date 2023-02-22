# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 bash-completion-r1 optfeature

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/beetbox/beets.git"
	inherit git-r3
else
	MY_PV=${PV/_beta/-beta.}
	MY_P=${PN}-${MY_PV}
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
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
		>=dev-python/jellyfish-0.7.1[${PYTHON_USEDEP}]
		dev-python/munkres[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.33[${PYTHON_USEDEP}]
		>=dev-python/python-musicbrainzngs-0.4[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/reflink[${PYTHON_USEDEP}]
		dev-python/confuse[${PYTHON_USEDEP}]
		dev-python/mediafile[${PYTHON_USEDEP}]
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
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/bluelet[${PYTHON_USEDEP}]
			dev-python/discogs-client[${PYTHON_USEDEP}]
			dev-python/flask[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pyacoustid[${PYTHON_USEDEP}]
			dev-python/pylast[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/python-mpd[${PYTHON_USEDEP}]
			dev-python/pyxdg[${PYTHON_USEDEP}]
			dev-python/reflink[${PYTHON_USEDEP}]
			|| (
				dev-python/pillow[${PYTHON_USEDEP}]
				media-gfx/imagemagick
			)
			dev-python/rarfile[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			media-libs/chromaprint[tools]
			media-libs/flac
			media-libs/gst-plugins-bad:1.0
			media-libs/gst-plugins-good:1.0
			media-sound/mp3val
			media-sound/mp3gain
			media-plugins/gst-plugins-libav:1.0
			media-video/ffmpeg:0[encode]
			app-shells/bash-completion
		)
	')"

PATCHES=(
	"${FILESDIR}/${PV}-0001-Remove-test_completion.patch"
	"${FILESDIR}/${PV}-sphinx-6.patch"
	"${FILESDIR}/${PV}-mediafile-test.patch"
	"${FILESDIR}/${PV}-unicode-test.patch"
)

DOCS=( README.rst docs/changelog.rst )

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
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
