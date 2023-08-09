# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An ncurses based mpd client with vi-like key bindings"
HOMEPAGE="https://github.com/boysetsfrog/vimpc"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/boysetsfrog/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/boysetsfrog/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="boost taglib"

RDEPEND="
	dev-libs/libpcre
	media-libs/libmpdclient
	boost? ( dev-libs/boost:= )
	taglib? ( media-libs/taglib )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-boost.patch
	"${FILESDIR}"/${P}-wformat-security.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Tests here seem to make cppunit linked into the main vimpc binary
	# Not clear how to run them either
	econf \
		$(use_enable boost) \
		$(use_enable taglib) \
		--disable-test
}

src_install() {
	local DOCS=( AUTHORS README.md doc/vimpcrc.example )
	default

	# vimpc will look for help.txt
	docompress -x /usr/share/doc/${PF}/help.txt
}
