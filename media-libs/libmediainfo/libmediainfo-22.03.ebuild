# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with media-video/mediainfo!

MY_PN="MediaInfo"
inherit autotools edos2unix flag-o-matic

DESCRIPTION="MediaInfo libraries"
HOMEPAGE="https://mediaarea.net/mediainfo/ https://github.com/MediaArea/MediaInfoLib"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"
S="${WORKDIR}"/${MY_PN}Lib/Project/GNU/Library

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="curl doc mms"

# Tests try to fetch data from online sources
RESTRICT="test"

RDEPEND="dev-libs/tinyxml2:=
	>=media-libs/libzen-0.4.37
	sys-libs/zlib
	curl? ( net-misc/curl )
	mms? ( >=media-libs/libmms-0.6.1 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	default

	sed -i 's:-O2::' configure.ac || die

	append-cppflags -DMEDIAINFO_LIBMMS_DESCRIBE_SUPPORT=0

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		--disable-staticlibs \
		--with-libtinyxml2 \
		$(use_with curl libcurl) \
		$(use_with mms libmms)
}

src_compile() {
	default

	if use doc; then
		cd "${WORKDIR}"/${MY_PN}Lib/Source/Doc || die
		doxygen Doxyfile || die
	fi
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${WORKDIR}"/${MY_PN}Lib/Doc/*.html )
	fi

	default

	edos2unix ${PN}.pc #414545
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Archive Audio Duplicate Export Image Multiple Reader Tag Text Video; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}/${x}/*.h
	done

	insinto /usr/include/${MY_PN}DLL
	doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}DLL/*.h

	dodoc "${WORKDIR}"/${MY_PN}Lib/*.txt

	find "${ED}" -name '*.la' -delete || die
}
