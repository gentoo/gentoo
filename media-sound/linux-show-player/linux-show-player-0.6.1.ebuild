# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.12 blocked by pyalsa: https://github.com/alsa-project/alsa-python/issues/8
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="A cue player designed for stage productions"
HOMEPAGE="https://www.linux-show-player.org/ https://github.com/FrancescoCeruti/linux-show-player/"
SRC_URI="https://github.com/FrancescoCeruti/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa jack midi pulseaudio timecode"

# TODO:
#  - network mode - falcon not packaged (QA issues, several unpackaged test dependencies)
#  - Open Sound Control support - pyliblo3 not packaged (last release in 2021, fails to build against modern cython)
RDEPEND="$(python_gen_cond_dep '
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/gst-python[${PYTHON_USEDEP}]
		dev-python/humanize[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/sortedcontainers[${PYTHON_USEDEP}]
	')
	media-libs/gstreamer[introspection]
	alsa? (
		$(python_gen_cond_dep '
			dev-python/pyalsa[${PYTHON_USEDEP}]
		')
		media-libs/gst-plugins-base[alsa]
	)
	jack? (
		$(python_gen_cond_dep '
			dev-python/jack-client[${PYTHON_USEDEP}]
		')
		media-plugins/gst-plugins-jack
	)
	midi? (
		$(python_gen_cond_dep '
			dev-python/mido[rtmidi,${PYTHON_USEDEP}]
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
	else
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 0.6.0; then
				ewarn "Please be warned that current versions of ${PN} *cannot* open 0.5.x save files."
				ewarn "Unfortunately upstream has provided no workaround for this."
				ewarn
				break
			fi
		done
	fi

	if use timecode; then
		elog "Remember to start an OLA session on your computer if you want ${PN} to send timecodes"
	fi
}
