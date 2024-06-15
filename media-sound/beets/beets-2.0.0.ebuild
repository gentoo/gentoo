# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite"

# These envvars are used to treat github tarball builds differently
# from pypi sources. Enable where required
: ${IS_VCS_SOURCE="no"}
: ${UPDATE_VERSION="no"}

inherit distutils-r1 bash-completion-r1 multiprocessing pypi optfeature

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/beetbox/beets.git"
	inherit git-r3
else
	SRC_URI="$(pypi_sdist_url)"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Media library management system for obsessive music geeks"
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
		>=dev-python/musicbrainzngs-0.4[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/confuse[${PYTHON_USEDEP}]
		dev-python/mediafile[${PYTHON_USEDEP}]
		dev-python/reflink[${PYTHON_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
	')"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? (
		dev-python/sphinx
		dev-python/pydata-sphinx-theme
	)
	$(python_gen_cond_dep '
		test? (
			dev-db/sqlite[icu]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/bluelet[${PYTHON_USEDEP}]
			dev-python/python3-discogs-client[${PYTHON_USEDEP}]
			dev-python/flask[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pyacoustid[${PYTHON_USEDEP}]
			dev-python/pylast[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/python-mpd2[${PYTHON_USEDEP}]
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

# Beets uses sphinx to generate manpages; these are not available
# directly in VCS sources, only pypi tarballs, so handle the dependency
# here automagically.
if [[ ${PV} == "9999" ]] || [[ ${IS_VCS_SOURCE} == "yes" ]]; then
	BDEPEND+="
		dev-python/sphinx
	"
fi

DOCS=( README.rst docs/changelog.rst )

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# https://github.com/beetbox/beets/commit/8b4983fe7cae9397acd3e23602e419d8dc1041d4
	# merged code coverage into standard test runs; since we disable coverage globally
	# we need to sed out some 'addopts' for coverage in setup.cfg that cause tests to choke.
	sed -i -e "/--cov=beets/,+9d" setup.cfg || die "Failed to disable code coverage options in setup.cfg"
	# Update the version if we're not building from pypy; it's probably a _pre or live ebuild.
	if  [[ ${PV} == "9999" ]] || [[ ${UPDATE_VERSION} == "yes" ]]; then
		    sed -i -e "s/version=\".*\"/version=\"${PV}\"/" setup.py || die "Failed to update version in VCS sources"
			sed -i -e "s/__version__ = \".*\"/__version__ = \"${PV}\"/" beets/__init__.py
	fi
	default
}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		sphinx-build -b html docs docs/build/html || die
	fi
	# If building from VCS sources we need to generate manpages, then copy them to ${S}/man
	# We could install mans from the sphinx build path, but to be consistent with pypi for src_install
	# we'll instead generate them and copy to the same install location if building from VCS sources.
	if [[ ${PV} == "9999" ]] || [[ ${IS_VCS_SOURCE} == "yes" ]]; then
		einfo "Building man pages"
		sphinx-build -b man docs docs/build/man || die "Failed to generate man pages"
		mkdir "${S}/man" || die
		cp docs/build/man/{beet.1,beetsconfig.5} "${S}/man" || die
	fi
}

python_test() {
	# https://github.com/beetbox/beets/issues/5243 testing bash completions is broken.
	local EPYTEST_DESELECT=(
		test/test_ui.py::CompletionTest::test_completion
	)
	epytest -n$(makeopts_jobs) -v
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/*
	use doc && local HTML_DOCS=( docs/build/html/. )
	einstalldocs
	# Generate the bash completions; we'll set PYTHONPATH for this invocation so that beets can start.
	PYTHONPATH="${ED}/usr/lib/${PYTHON}:$PYTHONPATH" ${PYTHON} "${ED}/usr/bin/beet" completion > "${T}/beet.bash" || die
	newbashcomp "${T}/beet.bash" beet
	insinto /usr/share/zsh/site-functions
	newins "${S}/extra/_beet" _beet

	optfeature "badfiles support" "media-libs/flac media-sound/mp3val"
	optfeature "chromaprint support" "dev-python/pyacoustid media-libs/chromaprint[tools]"
	optfeature "discogs support" dev-python/python3-discogs-client
	optfeature "ffmpeg support" media-video/ffmpeg[encode]
	optfeature "gstreamer support" "media-libs/gst-plugins-bad media-libs/gst-plugins-good"
	optfeature "icu support" dev-db/sqlite[icu]
	optfeature "lastfm support" dev-python/pylast
	optfeature "mpd support" "dev-python/bluelet dev-python/python-mpd2"
	optfeature "replaygain with gstreamer support" "dev-python/pygobject media-plugins/gst-plugins-libav"
	optfeature "replaygain without gstreamer support" media-sound/mp3gain
	optfeature "thumbnail support" dev-python/pyxdg "dev-python/pillow media-gfx/imagemagick"
	optfeature "webserver support" dev-python/flask
	optfeature "webserver cors support" dev-python/flask-cors
}
