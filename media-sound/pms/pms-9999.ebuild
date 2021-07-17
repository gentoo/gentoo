# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms"

EGIT_REPO_URI="https://github.com/ambientsound/pms.git"
EGIT_BRANCH="0.42.x" # todo: package the golang version

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
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
