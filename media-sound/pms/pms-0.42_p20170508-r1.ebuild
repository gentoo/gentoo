# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

REF="8c8918488a4a22924ee04442dc5e5216783d51ff"
DESCRIPTION="Practical Music Search: open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms"
SRC_URI="https://github.com/ambientsound/${PN}/archive/${REF}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+regex doc"

RDEPEND="
	sys-libs/ncurses:=[unicode(+)]
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( virtual/pandoc )
"

PATCHES=( "${FILESDIR}"/${PN}-0.42_p20170508-gcc12-time.patch )

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOC=$(usex doc)
		-DENABLE_REGEX=$(usex regex)
	)

	cmake_src_configure
}
