# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Number to number name and money text conversion libraries"
HOMEPAGE="https://github.com/Numbertext/libnumbertext"
SRC_URI="https://github.com/Numbertext/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
