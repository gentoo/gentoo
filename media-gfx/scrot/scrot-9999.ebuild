# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/scrot"
EGIT_REPO_URI="https://github.com/resurrecting-open-source-projects/${PN}"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=media-libs/giblib-1.2.3
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	|| (
		media-libs/imlib2[gif]
		media-libs/imlib2[jpeg]
		media-libs/imlib2[png]
		media-libs/imlib2[tiff]
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DOCS=(
	AUTHORS ChangeLog CONTRIBUTING.md README TODO
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	newbashcomp "${FILESDIR}"/${PN}-1.2.bash-completion ${PN}
}
