# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-src-${PV}
MY_PN=imagew

DESCRIPTION="Utility for image scaling and processing"
HOMEPAGE="https://entropymine.com/imageworsener/"
SRC_URI="https://entropymine.com/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/3"  # because of libimageworsener.so.3.*.*
KEYWORDS="amd64 x86"
IUSE="jpeg png static-libs test webp zlib"

DEPEND="png? ( media-libs/libpng:0 )
	jpeg? ( media-libs/libjpeg-turbo )
	webp? ( >=media-libs/libwebp-0.1.3 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

REQUIRED_USE="test? ( jpeg png webp zlib )"
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-1.3.5-runtest-exit-code.patch" )

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
	find "${D}" -name '*.la' -delete || die
}

src_test() {
	cd "${S}"/tests || die
	./runtest "${S}"/${MY_PN} || die
}
