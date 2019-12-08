# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1

DESCRIPTION="Media library management system for obsessive-compulsive music geeks"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="http://beets.io/ https://pypi.org/project/beets/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="MIT"
IUSE="badfiles chromaprint discogs doc ffmpeg gstreamer icu lastfm mpd replaygain test thumbnail webserver"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
DEPEND="
	>=dev-python/jellyfish-0.7.1[${PYTHON_USEDEP}]
	dev-python/munkres[${PYTHON_USEDEP}]
	>=dev-python/python-musicbrainz-ngs-0.4[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.33[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	badfiles? (
		media-libs/flac
		media-sound/mp3val
	)
	chromaprint? (
		dev-python/pyacoustid[${PYTHON_USEDEP}]
		media-libs/chromaprint[tools]
	)
	discogs? ( dev-python/discogs-client[${PYTHON_USEDEP}] )
	ffmpeg? ( media-video/ffmpeg:0[encode] )
	gstreamer? (
		media-libs/gst-plugins-good:1.0
		media-libs/gst-plugins-bad:1.0
	)
	icu? ( dev-db/sqlite[icu] )
	lastfm? ( dev-python/pylast[${PYTHON_USEDEP}] )
	mpd? (
		dev-python/bluelet[${PYTHON_USEDEP}]
		dev-python/python-mpd[${PYTHON_USEDEP}]
	)
	replaygain? (
		gstreamer? (
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			media-plugins/gst-plugins-libav:1.0
		)
		!gstreamer? ( media-sound/mp3gain )
	)
	thumbnail? (
		dev-python/pyxdg[${PYTHON_USEDEP}]
		virtual/python-pathlib[${PYTHON_USEDEP}]
		|| (
			dev-python/pillow[${PYTHON_USEDEP}]
			media-gfx/imagemagick
		)
	)
	webserver? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

RESTRICT="test" # tests broken in 1.4.3 already

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	rm_use_plugins() {
		[[ -n "${1}" ]] || die "rm_use_plugins: No use option given"
		local use=${1}
		local plugins=${use}
		use ${use} && return
		einfo "no ${use}:"
		[[ $# -gt 1 ]] && plugins="${@:2}"
		for arg in ${plugins[@]}; do
			einfo "  removing ${arg}"
			if [[ -e "beetsplug/${arg}.py" ]]; then
				rm beetsplug/${arg}.py || die "Unable to remove ${arg} plugin"
			fi
			if [[ -d "beetsplug/${arg}" ]]; then
				rm -r beetsplug/${arg} || die "Unable to remove ${arg} plugin"
			fi
			sed -e "s:'beetsplug.${arg}',::" -i setup.py || \
				die "Unable to disable ${arg} plugin "
		done
	}

	rm_use_plugins chromaprint chroma
	rm_use_plugins ffmpeg convert
	rm_use_plugins icu loadext
	rm_use_plugins lastfm lastgenre lastimport
	rm_use_plugins mpd bpd mpdstats
	rm_use_plugins webserver web
	rm_use_plugins thumbnail thumbnails

	# remove plugins that do not have appropriate dependencies installed
	for flag in badfiles discogs replaygain; do
		rm_use_plugins ${flag}
	done

	if ! use mpd; then
		rm test/test_player.py || die
	fi
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd test || die
	if ! use webserver; then
		rm test_web.py || die "Failed to remove test_web.py"
	fi
	"${EPYTHON}" testall.py || die "Testsuite failed"
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/beet.1 man/beetsconfig.5
	use doc && local HTML_DOCS=( docs/_build/html/. )
	einstalldocs
}
