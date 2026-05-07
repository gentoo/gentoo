# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite"
inherit optfeature python-single-r1 xdg

DESCRIPTION="GTK+ based media player aiming to be similar to Amarok"
HOMEPAGE="https://www.exaile.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exaile/exaile.git"
else
	MY_PV="${PV/_/-}"
	SRC_URI="
		https://github.com/exaile/exaile/releases/download/${MY_PV}/exaile-${MY_PV}.tar.gz
	"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="nls test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=media-libs/gstreamer-1.16[introspection]
	>=media-libs/gst-plugins-base-1.16:1.0
	>=media-libs/gst-plugins-good-1.16:1.0
	>=media-plugins/gst-plugins-meta-1.16:1.0
	>=x11-libs/gtk+-3.24:3[introspection]
	$(python_gen_cond_dep '
		dev-python/berkeleydb[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.44[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=dev-python/gst-python-1.16:1.0[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.24:3[${PYTHON_USEDEP}]
	')
"
BDEPEND="${PYTHON_DEPS}
	sys-apps/help2man
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	emake completion desktop_files$(use nls || echo _no_locale)
	use nls && emake locale

	# Do it by hand to avoid decompressing gzip
	LC_ALL=C help2man -n "music manager and player" -N ./exaile > build/exaile.1 || die
}

src_test() {
	local -x EXAILE_DIR="${S}"
	epytest
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR=/usr/$(get_libdir) \
		DESTDIR="${D}" \
		PYTHON3_CMD="${EPYTHON}" \
		install$(use nls || echo _no_locale)

	doman build/exaile.1

	python_optimize "${D}/usr/$(get_libdir)/${PN}"
	python_optimize "${D}/usr/share/${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	# https://github.com/exaile/exaile/blob/master/DEPS
	optfeature "device detection" sys-fs/udisks
	optfeature "CD info" dev-python/discid dev-python/musicbrainzngs
	#optfeature "DAAP plugins" dev-python/spydaap dev-python/zeroconf # spydaap unpackaged
	optfeature "Last.FM integration" dev-python/pylast
	optfeature "Lyrics from lyricsmania.com" dev-python/lxml
	optfeature "Musicbrainz covers" dev-python/musicbrainzngs
	optfeature "Podcast plugin" dev-python/feedparser
	optfeature "Wikipedia info" net-libs/webkit-gtk:4.1[introspection]
	optfeature "Xlib-based hotkeys" dev-libs/keybinder:3[introspection]
	optfeature "scalable icons" gnome-base/librsvg:2
	optfeature "native notifications" x11-libs/libnotify[introspection]
	optfeature "recording streams" media-sound/streamripper
	#optfeature "Moodbar plugin" media-sound/moodbar # moodbar unpackaged
	optfeature "BPM counter plugin" media-plugins/gst-plugins-soundtouch

	# Extras not mentioned in upstream DEPS file
	optfeature "Internet Radio" media-plugins/gst-plugins-soup
}
