# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# - media-libs/libzen (if a release is available)
# - media-libs/libmediainfo
# - media-video/mediainfo

MY_PN="MediaInfo"
inherit autotools edos2unix flag-o-matic

DESCRIPTION="MediaInfo libraries"
HOMEPAGE="https://mediaarea.net/en/MediaInfo https://github.com/MediaArea/MediaInfoLib"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"
S="${WORKDIR}"/${MY_PN}Lib

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="curl doc mms"

# Tests try to fetch data from online sources
RESTRICT="test"

# The libzen dep usually needs to be bumped for each release!
RDEPEND="
	dev-libs/tinyxml2:=
	>=media-libs/libzen-0.4.41
	virtual/zlib:=
	curl? ( net-misc/curl )
	mms? ( >=media-libs/libmms-0.6.1 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-24.11-gcc17.patch
)

src_prepare() {
	default

	cd Project/GNU/Library || die

	sed -i 's:-O2::' configure.ac || die

	append-cppflags -DMEDIAINFO_LIBMMS_DESCRIBE_SUPPORT=0

	eautoreconf
}

src_configure() {
	cd Project/GNU/Library || die
	econf \
		--enable-shared \
		--disable-static \
		--disable-staticlibs \
		--with-libtinyxml2 \
		$(use_with curl libcurl) \
		$(use_with mms libmms)
}

src_compile() {
	cd Project/GNU/Library || die
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

	cd Project/GNU/Library || die

	default

	edos2unix ${PN}.pc #414545
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Archive Audio Duplicate Export Image Multiple Reader Tag Text Video; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${S}"/Source/${MY_PN}/${x}/*.h
	done

	insinto /usr/include/${MY_PN}DLL
	doins "${S}"/Source/${MY_PN}DLL/*.h

	dodoc "${S}"/*.txt

	find "${ED}" -name '*.la' -delete || die
}
