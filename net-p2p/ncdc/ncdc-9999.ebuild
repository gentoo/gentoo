# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="ncurses directconnect client"
HOMEPAGE="http://dev.yorhel.nl/ncdc"
EGIT_REPO_URI="git://g.blicky.net/ncdc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="geoip"

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/glib:2
	net-libs/gnutls
	sys-libs/ncurses:0[unicode]
	sys-libs/zlib
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	dev-util/makeheaders
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-git-version \
		$(use_with geoip)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
