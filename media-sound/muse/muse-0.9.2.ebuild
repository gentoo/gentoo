# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

MY_P=${P/muse/MuSE}

DESCRIPTION="Multiple Streaming Engine, an icecast source streamer"
HOMEPAGE="http://muse.dyne.org"
SRC_URI="ftp://ftp.dyne.org/muse/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="debug gtk"

RDEPEND="media-sound/lame
	media-libs/libvorbis
	media-libs/libsndfile
	media-libs/libogg
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-gcc43.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable gtk gtk2)
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS} -fpermissive" CFLAGS="${CFLAGS}" \
		|| die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" docsdir="/usr/share/doc/${PF}" \
		install || die "emake install failed."
	prepalldocs
}
