# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

MY_P=${PN}-src-${PV}
MY_PN=imagew

DESCRIPTION="Utility for image scaling and processing"
HOMEPAGE="http://entropymine.com/imageworsener/"
SRC_URI="http://entropymine.com/${PN}/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg png static-libs test webp zlib"

DEPEND="png? ( media-libs/libpng:0 )
	jpeg? ( virtual/jpeg:0 )
	webp? ( >=media-libs/libwebp-0.1.3 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

REQUIRED_USE="test? ( jpeg png webp zlib )"
RESTRICT="!test? ( test )"

src_configure() {
	local switch=''
	use test && switch=test

	econf \
		$(use_enable static-libs static) \
		$(use_with ${switch} jpeg) \
		$(use_with ${switch} png) \
		$(use_with ${switch} webp) \
		$(use_with ${switch} zlib)
}

src_install() {
	default
	dodoc {changelog,readme,technical}.txt
	prune_libtool_files
}

src_test() {
	cd "${S}"/tests || die
	./runtest "${S}"/${MY_PN}
}
