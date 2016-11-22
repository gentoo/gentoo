# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="city simulation game"
HOMEPAGE="https://savannah.nongnu.org/projects/senken/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="
	>=media-libs/libsdl-1.2.4
	media-libs/sdl-image
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-warnings.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:/usr/local/share:/usr/share:" \
		lib/utils.h || die
}
src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	#dodir "${GAMES_DATADIR}"
	#mv "${D}/${GAMES_PREFIX}/share/senken" "${D}/${GAMES_DATADIR}/" || die
	#rm -rf "${D}/${GAMES_PREFIX}"/{include,lib,man,share} || die

	insinto /usr/share/senken/img
	doins img/*.png

	find "${D}/usr/share/" -type f -exec chmod a-x \{\} +
	find "${D}/usr/share/" -name "Makefile.*" -exec rm -f \{\} +
}
