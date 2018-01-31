# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit gnome2-utils meson python-r1

DESCRIPTION="Limiter, compressor, reverberation, equalizer auto volume effects for Pulseaudio"
HOMEPAGE="https://github.com/wwmm/pulseeffects"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	python_targets_python3_4? ( dev-python/configparser )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/gst-python-1.12.0:1.0[${PYTHON_USEDEP}]
	media-plugins/swh-plugins
	>=x11-libs/gtk+-3.18:3
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.18[${PYTHON_USEDEP}]
	>=media-libs/lilv-0.24.2-r1
	>=media-plugins/calf-0.90.0[lv2]
	>=media-libs/gstreamer-1.12.0:1.0
	>=media-libs/gst-plugins-good-1.12.0:1.0
	>=media-libs/gst-plugins-bad-1.12.0:1.0
	>=media-plugins/gst-plugins-ladspa-1.12.0:1.0
	>=media-plugins/gst-plugins-lv2-1.12.0:1.0
	>=media-plugins/gst-plugins-pulse-1.12.0:1.0
"
RDEPEND="${DEPEND}
	media-sound/pulseaudio[equalizer]
"

pkg_preinst(){
	gnome2_schemas_savelist
}

pkg_postinst(){
	gnome2_gconf_install
	gnome2_schemas_update
}

pkg_postrm(){
	gnome2_gconf_uninstall
	gnome2_schemas_update
}
