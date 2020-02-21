# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/scrot"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sh ~sparc ~x86"

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
