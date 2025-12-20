# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_pre*}"
MY_P="pulseaudio-${MY_PV}"

PYTHON_COMPAT=( python3_{10..13} )
inherit python-single-r1

DESCRIPTION="Equalizer interface for equalizer sinks of PulseAudio (networked sound server)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"
SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyqt6[gui,widgets,${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	')
	media-sound/pulseaudio-daemon[dbus,fftw]
"
PATCHES=(
	"${FILESDIR}/pulseaudio-17.0-pr844.patch"
)

src_configure() {
	:; # do nothing
}

src_install() {
	python_doscript src/utils/qpaeq
}

pkg_postinst() {
	elog "You will need to load some extra modules to make qpaeq work."
	elog "You can do that by adding the following two lines in"
	elog "/etc/pulse/default.pa and restarting pulseaudio:"
	elog "load-module module-equalizer-sink"
	elog "load-module module-dbus-protocol"
}
