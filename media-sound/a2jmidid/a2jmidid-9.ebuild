# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )
PYTHON_REQ_USE="threads(+)"

inherit meson python-single-r1

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system"
HOMEPAGE="https://github.com/linuxaudio/a2jmidid"
SRC_URI="https://github.com/linuxaudio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="dbus python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	media-libs/alsa-lib
	virtual/jack
	dbus? ( sys-apps/dbus )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${CDEPEND}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst internals.txt )

src_configure() {
	local emasonargs=(
		-Ddisable-dbus=$(usex dbus false true)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use python; then
		python_fix_shebang "${ED}"
	else
		rm "${ED}/usr/bin/a2j_control" || die
	fi
}
