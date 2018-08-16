# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enlightenment image viewer written with EFL"
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
SRC_URI="http://www.smhouston.us/stuff/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/efl-1.18.0[eet,X]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local myconf=(
		$(use_enable nls)
	)

	econf "${myconf[@]}"
}
