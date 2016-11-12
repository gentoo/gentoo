# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit bash-completion-r1

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="iconv"

RDEPEND=">=media-libs/libmpdclient-2.9
	iconv? ( virtual/libiconv )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README doc/mpd-m3u-handler.sh doc/mppledit doc/mpd-pls-handler.sh )

src_configure() {
	econf \
		$(use_enable iconv) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default
	newbashcomp doc/mpc-completion.bash ${PN}
}
