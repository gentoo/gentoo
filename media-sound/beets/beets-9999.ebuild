# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 bash-completion-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/beetbox/beets.git"
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
else
	MY_PV=${PV/_beta/-beta.}
	MY_P=${PN}-${MY_PV}
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Media library management system for obsessive-compulsive music geeks"
HOMEPAGE="http://beets.io/ https://pypi.org/project/beets/"

LICENSE="MIT"
SLOT="0"
IUSE="badfiles chromaprint discogs doc ffmpeg gstreamer icu lastfm mpd replaygain test thumbnail webserver"

RDEPEND="${DEPEND}"
DEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/wheel[${PYTHON_MULTI_USEDEP}]
			dev-python/beautifulsoup[${PYTHON_MULTI_USEDEP}]
			dev-python/flask[${PYTHON_MULTI_USEDEP}]
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/rarfile[${PYTHON_MULTI_USEDEP}]
			dev-python/responses[${PYTHON_MULTI_USEDEP}]
			dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
			dev-python/requests-oauthlib[${PYTHON_MULTI_USEDEP}]
		)
		>=dev-python/jellyfish-0.7.1[${PYTHON_MULTI_USEDEP}]
		dev-python/munkres[${PYTHON_MULTI_USEDEP}]
		>=dev-python/python-musicbrainz-ngs-0.4[${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_MULTI_USEDEP}]
		>=dev-python/six-1.9[${PYTHON_MULTI_USEDEP}]
		dev-python/unidecode[${PYTHON_MULTI_USEDEP}]
		>=media-libs/mutagen-1.33[${PYTHON_MULTI_USEDEP}]
		>=dev-python/confuse-1.0.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/mediafile-0.2.0[${PYTHON_MULTI_USEDEP}]
		badfiles? (
			media-libs/flac
			media-sound/mp3val
		)
		chromaprint? (
			dev-python/pyacoustid[${PYTHON_MULTI_USEDEP}]
			media-libs/chromaprint[tools]
		)
		discogs? ( dev-python/discogs-client[${PYTHON_MULTI_USEDEP}] )
		ffmpeg? ( media-video/ffmpeg:0[encode] )
		gstreamer? (
			media-libs/gst-plugins-good:1.0
			media-libs/gst-plugins-bad:1.0
		)
		icu? ( dev-db/sqlite[icu] )
		lastfm? ( dev-python/pylast[${PYTHON_MULTI_USEDEP}] )
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
			dev-python/flask-cors[${PYTHON_MULTI_USEDEP}]
		)
	')"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
	')"

DOCS=( README.rst docs/changelog.rst )

distutils_enable_tests pytest

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
		rm test/test_mpdstats.py || die
	fi
	if ! use webserver; then
		rm test/test_web.py || die "Failed to remove test_web.py"
	fi
	if use test; then
		# Those test need network
		rm test/test_art.py || die
		rm test/test_discogs.py || die
		rm test/test_embyupdate.py || die
		rm test/test_lastgenre.py || die
		rm test/test_spotify.py || die
		# rm test/test_plexupdate.py
		rm test/test_thumbnails.py || die
		# Not working
		rm test/test_replaygain.py || die
		# Not working
		rm test/test_convert.py || die
	fi
}

python_compile_all() {
	esetup.py build_sphinx -b man --build-dir=docs/build
	use doc && esetup.py build_sphinx -b html --build-dir=docs/build
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/build/man/*
	use doc && local HTML_DOCS=( docs/build/html/. )
	einstalldocs

	"${D}$(python_get_scriptdir)/beet" completion > "${T}/beet.bashcomp"
	newbashcomp "${T}/beet.bashcomp" beet
}
