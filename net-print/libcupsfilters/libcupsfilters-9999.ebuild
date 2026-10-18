# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="library for developing printing features, split out of cups-filters"
HOMEPAGE="https://github.com/OpenPrinting/libcupsfilters"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OpenPrinting/libcupsfilters"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/OpenPrinting/libcupsfilters/releases/download/${MY_PV}/${MY_P}.tar.xz"
	S="${WORKDIR}"/${MY_P}

	KEYWORDS="~amd64 ~arm"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="dbus exif fontconfig jpeg jpegxl pdf +postscript png test tiff"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-text/pdfio-1.6.4
	app-text/poppler[utils]
	media-libs/lcms:2
	>=net-print/cups-2.2.2
	!<net-print/cups-filters-2.0.0

	exif? ( media-libs/libexif )
	dbus? ( sys-apps/dbus )
	fontconfig? ( >=media-libs/fontconfig-2.0.0 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpegxl? ( >=media-libs/libjxl-0.7.0:= )
	pdf? ( >=app-text/mupdf-1.15:= )
	postscript? ( app-text/ghostscript-gpl[cups] )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	test? ( media-fonts/dejavu )
"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		# respect --as-needed
		elibtoolize
	fi
}

src_configure() {
	local myeconfargs=(
		--enable-imagefilters
		--localstatedir="${EPREFIX}"/var
		--with-cups-rundir="${EPREFIX}"/run/cups
		$(use_enable exif)
		$(use_enable dbus)
		$(use_enable postscript ghostscript)
		$(use_enable pdf mutool)
		$(use_with fontconfig)
		$(use_with jpeg)
		$(use_with jpegxl)
		$(use_with png)
		$(use_with tiff)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Don't try to use ASAN which will fail under sandbox
	local -x SAN_FLAGS=" "

	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
