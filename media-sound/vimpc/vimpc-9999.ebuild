# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="An ncurses based mpd client with vi like key bindings"
HOMEPAGE="https://github.com/boysetsfrog/vimpc"
EGIT_REPO_URI="https://github.com/boysetsfrog/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="boost taglib"

RDEPEND="dev-libs/libpcre
	media-libs/libmpdclient
	boost? ( dev-libs/boost:= )
	taglib? ( media-libs/taglib )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS README.md doc/vimpcrc.example )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable taglib)
}

src_install() {
	default

	# vimpc will look for help.txt
	docompress -x /usr/share/doc/${PF}/help.txt
}
