# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
NO_WAF_LIBDIR=1

inherit python-single-r1 toolchain-funcs waf-utils eutils

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system"
HOMEPAGE="https://repo.or.cz/a2jmidid.git"
SRC_URI="http://download.gna.org/a2jmidid/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="media-libs/alsa-lib
	virtual/jack
	dbus? ( sys-apps/dbus )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS README NEWS internals.txt)

src_prepare() {
	# Bug 518382
	epatch "${FILESDIR}"/${PN}-link.patch
}

src_configure() {
	if use dbus ; then
		waf-utils_src_configure
	else
		waf-utils_src_configure --disable-dbus
	fi
}

src_install() {
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
