# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils flag-o-matic meson

DESCRIPTION="Limiter, auto volume and many other plugins for PipeWire applications"
HOMEPAGE="https://github.com/wwmm/easyeffects"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wwmm/easyeffects"
else
	SRC_URI="https://github.com/wwmm/easyeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="calf +doc mda-lv2 zamaudio"

# Tests fail since 6.1.0 due to upstream changes to the metainfo file.
# TODO: check this every release.
RESTRICT="test"

DEPEND=">=dev-cpp/glibmm-2.68:2.68
	>=dev-cpp/gtkmm-4.2.0:4.0
	dev-cpp/nlohmann_json
	dev-cpp/tbb
	>=dev-libs/glib-2.56:2
	>=dev-libs/libsigc++-3.0.6:3
	media-libs/libbs2b
	>=media-libs/libebur128-1.2.0
	media-libs/libsndfile
	>=media-libs/lilv-0.22
	>=media-libs/lv2-1.18.2
	media-libs/rnnoise
	media-libs/rubberband[ladspa]
	media-libs/speexdsp
	>=media-libs/zita-convolver-3.0.0
	>=media-video/pipewire-0.3.31
	sci-libs/fftw:3.0
	>=gui-libs/gtk-4.2.1:4"
RDEPEND="${DEPEND}
	>=media-libs/lsp-plugins-1.1.24[lv2]
	sys-apps/dbus
	calf? ( >=media-plugins/calf-0.90.1[lv2] )
	doc? ( gnome-extra/yelp )
	mda-lv2? ( media-plugins/mda-lv2 )
	zamaudio? ( media-plugins/zam-plugins )"
# Only header files are used from libsamplerate so put it here rather than DEPEND
# to avoid unnecessary cross-compilation.
BDEPEND="dev-libs/appstream-glib
	dev-util/desktop-file-utils
	dev-util/itstool
	media-libs/libsamplerate
	sys-devel/gettext
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if ! test-flag-CXX -std=c++20 ; then
			die "You need at least GCC 8 or Clang 10 for C++20-specific compiler flags"
		fi
	fi
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_icon_cache_update
}
