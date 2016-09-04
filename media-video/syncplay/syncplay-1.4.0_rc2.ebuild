# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

MY_PV=${PV/_rc/-RC}

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="http://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client +server gui vlc"
REQUIRED_USE="vlc? ( client )
	gui? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	dev-python/twisted-core[${PYTHON_USEDEP}]
	gui? ( dev-python/pyside[${PYTHON_USEDEP}] )
	vlc? ( media-video/vlc[lua] )"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}/syncplay-1.4.0-rc2-fix-makefile.patch" )

src_compile() {
	:
}

src_install() {
	local MY_MAKEOPTS=( DESTDIR="${D}" PREFIX=/usr )
	use client && \
		emake "${MY_MAKEOPTS[@]}" VLC_SUPPORT=$(usex vlc true false) install-client
	use server && \
		emake "${MY_MAKEOPTS[@]}" install-server
}

pkg_postinst() {
	if use client; then
		einfo "Syncplay supports the following players:"
		einfo "media-video/mpv, media-video/mplayer2, media-video/vlc"
	fi
}
