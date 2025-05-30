# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ bindings for libh2o"
HOMEPAGE="https://github.com/projg2/libh2oxx/"
SRC_URI="
	https://github.com/projg2/libh2oxx/releases/download/${P}/${P}.tar.bz2
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=sci-libs/libh2o-0.2:0=
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local myconf=(
		$(use_enable debug)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
