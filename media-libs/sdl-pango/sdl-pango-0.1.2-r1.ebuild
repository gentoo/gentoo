# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="connect the text rendering engine of GNOME to SDL"
HOMEPAGE="http://sdlpango.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlpango/SDL_Pango-${PV}.tar.gz
	http://zarb.org/~gc/t/SDL_Pango-0.1.2-API-adds.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"
IUSE="static-libs"

RDEPEND="x11-libs/pango
	media-libs/libsdl[video]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/SDL_Pango-${PV}"

src_unpack() {
	unpack SDL_Pango-${PV}.tar.gz
}

src_prepare() {
	default
	eapply -p0 "${DISTDIR}"/SDL_Pango-0.1.2-API-adds.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
	find "${ED}" -name "*.la" -delete || die
}
