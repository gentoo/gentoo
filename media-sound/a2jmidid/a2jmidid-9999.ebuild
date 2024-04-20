# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit meson python-single-r1 git-r3

DESCRIPTION="Daemon for exposing ALSA sequencer applications in JACK MIDI system"
HOMEPAGE="https://a2jmidid.ladish.org"
EGIT_REPO_URI="https://gitea.ladish.org/LADI/a2jmidid.git"
EGIT_BRANCH="main"
EGIT_SUBMODULES=( waf-autooptions waftoolchainflags siginfo )

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus"
REQUIRED_USE="dbus? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	media-libs/alsa-lib
	virtual/jack
	dbus? ( sys-apps/dbus ${PYTHON_DEPS} )
"
RDEPEND="${CDEPEND}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.rst NEWS.rst README internals.txt )

src_configure() {
	local emesonargs=(
		-Ddisable-dbus=$(usex dbus false true)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use dbus; then
		python_fix_shebang "${ED}"
	fi
}
