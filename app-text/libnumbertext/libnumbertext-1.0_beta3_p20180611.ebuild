# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=53ee927a1d431aea09a4f844213d608d8c10defd
inherit autotools

DESCRIPTION="Number to number name and money text conversion libraries"
HOMEPAGE="https://github.com/Numbertext/libnumbertext"
SRC_URI="https://github.com/Numbertext/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc test"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

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
