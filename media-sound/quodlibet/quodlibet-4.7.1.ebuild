# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://quodlibet.readthedocs.io/en/latest/packaging.html
PYTHON_COMPAT=( python3_{11..13} )
inherit edo python-single-r1 virtualx xdg

DESCRIPTION="audio library tagger, manager, and player for GTK+"
HOMEPAGE="https://quodlibet.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+dbus gstreamer +udev"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/keybinder:3[introspection]
	$(python_gen_cond_dep '
		>=dev-python/feedparser-6.0.11[${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.19[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.34.0:3[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.45[${PYTHON_USEDEP}]
	')
	net-libs/libsoup:3.0[introspection]
	x11-libs/gtk+[introspection]
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-meta:1.0
	)
	!gstreamer? ( media-libs/xine-lib )
	dbus? (
		app-misc/media-player-info
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
	udev? ( virtual/udev )
"
BDEPEND="
	dev-util/intltool
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

src_prepare() {
	default

	local qlconfig=quodlibet/config.py

	if ! use gstreamer; then
		sed -i -e '/backend/s:gstbe:xinebe:' ${qlconfig} || die
	fi

	sed -i -e '/gst_pipeline/s:"":"alsasink":' ${qlconfig} || die
}

src_compile() {
	# The package has a complex setuptools-based build system inside
	# of gdist/. Using PEP517 requires some workarounds and isn't
	# really useful here.
	edo ${EPYTHON} setup.py build
}

src_test() {
	EPYTEST_DESELECT=(
		# Network tests
		'tests/plugin/test_covers.py::test_live_cover_download[lastfm-cover]'
		'tests/plugin/test_covers.py::test_live_cover_download[discogs-cover]'
		tests/test_browsers_iradio.py::TInternetRadio::test_click_add_station
		# ?
		tests/plugin/test_replaygain.py::TReplayGain::test_analyze_sinewave
	)

	# https://quodlibet.readthedocs.io/en/latest/development/testing.html#testing
	#virtx edo ${EPYTHON} setup.py test
	virtx epytest || die "Tests failed with ${EPYTHON}"
}

src_install() {
	edo ${EPYTHON} setup.py install --prefix="${EPREFIX}/usr" --root="${D}"
	python_optimize

	dodoc README.rst
}
