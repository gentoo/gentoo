# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A cue player designed for stage productions"
HOMEPAGE="https://www.linux-show-player.org/ https://github.com/FrancescoCeruti/linux-show-player/"
SRC_URI="https://github.com/FrancescoCeruti/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa jack midi pulseaudio timecode"

RDEPEND="$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/sortedcontainers[${PYTHON_USEDEP}]
	')
	media-libs/gstreamer[introspection]
	alsa? ( media-libs/gst-plugins-base[alsa] )
	jack? (
		$(python_gen_cond_dep '
			dev-python/jack-client[${PYTHON_USEDEP}]
		')
		media-plugins/gst-plugins-jack
	)
	midi? (
		$(python_gen_cond_dep '
			dev-python/mido[${PYTHON_USEDEP}]
		')
	)
	pulseaudio? ( media-plugins/gst-plugins-pulse )
	timecode? (
		app-misc/ola[python,${PYTHON_SINGLE_USEDEP}]
	)
"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "${PN} uses GStreamer as its audio back-end so make sure you have plug-ins installed for all the audio formats you want to use"
	fi

	if use timecode; then
		elog "Remember to start an OLA session on your computer if you want ${PN} to send timecodes"
	fi
}
