# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite"

# These envvars are used to treat github tarball builds differently
# from pypi sources. Enable where required
: ${IS_VCS_SOURCE="no"}
: ${UPDATE_VERSION="no"}

inherit distutils-r1 optfeature shell-completion

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/beetbox/beets.git"
	IS_VCS_SOURCE="yes"
	UPDATE_VERSION="yes"
	inherit git-r3
else
	PYPI_VERIFY_REPO=https://github.com/beetbox/beets
	inherit pypi
	MY_PV=${PV/_beta/-beta.}
	MY_P=${PN}-${MY_PV}
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Media library management system for obsessive music geeks"
HOMEPAGE="https://beets.io/ https://pypi.org/project/beets/"

LICENSE="MIT"
SLOT="0"

# TODO: test-full with GITHUB_ACTIONS=true. Would require packaging more dependencies.

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/jellyfish-0.7.1[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.33[${PYTHON_USEDEP}]
		>=dev-python/confuse-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/lap-0.5.12[${PYTHON_USEDEP}]
		>=dev-python/mediafile-0.16.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-2[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/reflink[${PYTHON_USEDEP}]
		>=dev-python/requests-ratelimiter-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		>=dev-python/unidecode-1.3.6[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-db/sqlite[icu]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/bluelet[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
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
			dev-python/requests-mock[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			media-libs/chromaprint[tools]
			media-libs/flac
			media-libs/gst-plugins-bad:1.0
			media-libs/gst-plugins-good:1.0
			media-sound/mp3val
			media-sound/mp3gain
			media-plugins/gst-plugins-libav:1.0
			media-video/ffmpeg[encode(+)]
			app-shells/bash-completion
		)
	')
"

# Beets uses sphinx to generate manpages; these are not available
# directly in VCS sources, only pypi tarballs, so handle the dependency
# here automagically.
if [[ ${PV} == "9999" ]] || [[ ${IS_VCS_SOURCE} == "yes" ]]; then
	BDEPEND+=" $(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')"
fi

DOCS=( README.rst docs/changelog.rst )

EPYTEST_PLUGINS=( pytest-flask )
EPYTEST_IGNORE=(
	# Not relevant downstream
	test/test_release.py
	# Unpackaged test dependencies: titlecase and pytest-factoryboy
	# (These tests aren't included in the sdist)
	test/plugins
)
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if  [[ ${PV} == "9999" ]] || [[ ${UPDATE_VERSION} == "yes" ]]; then
		sed -i -e "s/^version = \".*\"$/version = \"${PV}\"/" \
			pyproject.toml \
			|| die "Failed to update version in VCS sources"
			sed -i -e "s/__version__ = \".*\"/__version__ = \"${PV}\"/" beets/__init__.py
	fi

	# Don't require extra unpackaged sphinx dependencies to generate man pages on live
	sed -e '/sphinx_design/d' \
		-e '/sphinx_copybutton/d' \
		-e '/sphinx_toolbox/d' \
		-i docs/conf.py || die
}

python_compile_all() {
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

python_install_all() {
	distutils-r1_python_install_all

	# remove leftover file in sdist
	if [[ -e man/_sphinx_design_static ]]; then
		rm -rf man/_sphinx_design_static || die
	fi
	doman man/*
	einstalldocs

	# Generate the bash completions; we'll set PYTHONPATH for this invocation so that beets can start.
	PYTHONPATH="${ED}/usr/lib/${PYTHON}:$PYTHONPATH" ${PYTHON} "${ED}/usr/bin/beet" completion > "${T}/beet.bash" || die
	newbashcomp "${T}/beet.bash" beet
	newzshcomp "${S}/extra/_beet" _beet

	optfeature "badfiles support" "media-libs/flac media-sound/mp3val"
	optfeature "chromaprint support" "dev-python/pyacoustid media-libs/chromaprint[tools]"
	optfeature "discogs support" dev-python/python3-discogs-client
	optfeature "ffmpeg support" media-video/ffmpeg
	optfeature "gstreamer support" "media-libs/gst-plugins-bad media-libs/gst-plugins-good"
	optfeature "icu support" dev-db/sqlite[icu]
	optfeature "lastfm support" dev-python/pylast
	optfeature "mpd support" "dev-python/bluelet dev-python/python-mpd2"
	optfeature "replaygain with gstreamer support" "dev-python/pygobject media-plugins/gst-plugins-libav"
	optfeature "replaygain without gstreamer support" media-sound/mp3gain
	optfeature "thumbnail support" dev-python/pyxdg "dev-python/pillow media-gfx/imagemagick"
	optfeature "webserver support" dev-python/flask
	optfeature "webserver cors support" dev-python/flask-cors
	optfeature "Amarok metadata synchronisation" dev-python/dbus-python
}
