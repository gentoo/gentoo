# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="http://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+client +server gui vlc"
REQUIRED_USE="vlc? ( client )
	gui? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
# TODO: investigate the possibility of enabling PyQt5 gui
# possible licensing concerns
RDEPEND="${PYTHON_DEPS}
	|| (
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		dev-python/twisted-core[${PYTHON_USEDEP}]
	)
	gui? ( dev-python/pyside[${PYTHON_USEDEP}] )
	vlc? ( media-video/vlc[lua] )"

src_prepare() {
	default
	if ! use gui; then
		sed -i 's/"noGui": False,/"noGui": True,/' \
			syncplay/ui/ConfigurationGetter.py \
		|| die "Failed to patch ConfigurationGetter.py"
	fi
}

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
