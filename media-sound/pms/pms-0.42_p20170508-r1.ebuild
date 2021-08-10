# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake vcs-snapshot

REF="8c8918488a4a22924ee04442dc5e5216783d51ff"
DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms"
SRC_URI="https://github.com/ambientsound/${PN}/archive/${REF}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+regex doc"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/pandoc )
"
RDEPEND="
	sys-libs/ncurses:=[unicode(+)]
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOC=$(usex doc)
		-DENABLE_REGEX=$(usex regex)
	)

	cmake_src_configure
}
