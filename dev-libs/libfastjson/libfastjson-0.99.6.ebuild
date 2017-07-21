# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Fork of the json-c library, which is optimized for liblognorm processing"
HOMEPAGE="http://www.rsyslog.com/tag/libfastjson/"
SRC_URI="http://download.rsyslog.com/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0/4.1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE="static-libs"

DEPEND=">=sys-devel/autoconf-archive-2015.02.04"
RDEPEND=""

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-compile-warnings=yes
		$(use_enable static-libs static)
		--disable-rdrand
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog )
	default

	find "${ED}"usr/lib* -name '*.la' -delete || die
}
