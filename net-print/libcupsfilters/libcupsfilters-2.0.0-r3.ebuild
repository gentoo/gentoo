# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="library for developing printing features, split out of cups-filters"
HOMEPAGE="https://github.com/OpenPrinting/libcupsfilters"
SRC_URI="https://github.com/OpenPrinting/libcupsfilters/releases/download/${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="dbus exif jpeg pdf +poppler +postscript png test tiff"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

RESTRICT="!test? ( test )"

RDEPEND="
	>=app-text/qpdf-8.3.0:=
	media-libs/fontconfig
	media-libs/lcms:2
	>=net-print/cups-2
	!<net-print/cups-filters-2.0.0

	exif? ( media-libs/libexif )
	dbus? ( sys-apps/dbus )
	jpeg? ( media-libs/libjpeg-turbo:= )
	pdf? ( app-text/mupdf )
	postscript? ( app-text/ghostscript-gpl[cups] )
	poppler? ( >=app-text/poppler-0.32[cxx] )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	test? ( media-fonts/dejavu )
"

PATCHES=(
	"${FILESDIR}/${P}-r3-c++17.patch"
)

src_prepare() {
	default

	# respect --as-needed
	elibtoolize
}

src_configure() {
	local myeconfargs=(
		--enable-imagefilters
		--localstatedir="${EPREFIX}"/var
		--with-cups-rundir="${EPREFIX}"/run/cups

		$(use_enable exif)
		$(use_enable dbus)
		$(use_enable poppler)
		$(use_enable postscript ghostscript)
		$(use_enable pdf mutool)
		$(use_with jpeg)
		$(use_with png)
		$(use_with tiff)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
