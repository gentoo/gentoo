# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="connect the text rendering engine of GNOME to SDL"
HOMEPAGE="https://sdlpango.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/sdlpango/SDL_Pango-${PV}.tar.gz
	http://zarb.org/~gc/t/SDL_Pango-0.1.2-API-adds.patch"
S="${WORKDIR}/SDL_Pango-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"
IUSE="static-libs"

DEPEND="
	x11-libs/pango
	media-libs/libsdl[video]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/SDL_Pango-0.1.2-fedora-c99.patch"
)

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
		find "${ED}" -type f -name "*.a" -delete || die
	fi
	find "${ED}" -type f -name "*.la" -delete || die
}
