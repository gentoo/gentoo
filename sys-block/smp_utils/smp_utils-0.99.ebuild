# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilities for SAS management protocol (SMP)"
HOMEPAGE="http://sg.danny.cz/sg/smp_utils.html"
MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_p/r}"
MY_P="${PN}-${MY_PV}"
SRC_URI="http://sg.danny.cz/sg/p/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog COVERAGE CREDITS README )

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
