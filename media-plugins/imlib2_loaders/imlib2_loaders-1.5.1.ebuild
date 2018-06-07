# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Additional image loaders for Imlib2"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eet xcf"

RDEPEND="
	>=media-libs/imlib2-${PV}
	eet? ( dev-libs/efl[eet] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable eet)
		$(use_enable xcf)
	)

	econf "${myconf[@]}"
}

src_install() {
	V=1 emake install DESTDIR="${D}"
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
