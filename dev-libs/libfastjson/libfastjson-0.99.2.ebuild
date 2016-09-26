# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Fork of the json-c library, which is optimized for liblognorm processing"
HOMEPAGE="http://www.rsyslog.com/tag/libfastjson/"
SRC_URI="http://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="MIT"

# subslot = soname version
SLOT="0/3.0.0"

KEYWORDS="amd64 ~arm ~arm64 hppa ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-0.99.2-fix-for-implicit-declaration-of-vasprintf.patch
	)

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
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
