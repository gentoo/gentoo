# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic pax-utils toolchain-funcs xdg

DOC_PV="2.6.0"
MY_PV="${PV/_/}"
MY_P="${P/_/.}"

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="https://www.darktable.org/"
SRC_URI="https://github.com/darktable-org/${PN}/releases/download/release-${MY_PV}/${MY_P}.tar.xz
	doc? ( https://github.com/darktable-org/${PN}/releases/download/release-${DOC_PV}/${PN}-usermanual.pdf -> ${PN}-usermanual-${DOC_PV}.pdf )"

LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS=" ca cs de es fi fr hu ja nb nl pl pt-BR ru sl"
# TODO add lua once dev-lang/lua-5.2 is unmasked
IUSE="colord cups cpu_flags_x86_sse3 doc flickr geolocation gnome-keyring gphoto2 graphicsmagick jpeg2k kwallet
nls opencl openmp openexr pax_kernel webp
${LANGS// / l10n_}"

BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
COMMON_DEPEND="
	dev-db/sqlite:3
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-libs/pugixml:0=
	gnome-base/librsvg:2
	>=media-gfx/exiv2-0.25-r2:0=[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3:0=
	media-libs/libpng:0=
	media-libs/tiff:0
	net-libs/libsoup:2.4
	net-misc/curl
	sys-libs/zlib:=
	virtual/jpeg:0
	x11-libs/cairo
	>=x11-libs/gtk+-3.14:3
	x11-libs/pango
	colord? ( x11-libs/colord-gtk:0= )
	cups? ( net-print/cups )
	flickr? ( media-libs/flickcurl )
	geolocation? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	gphoto2? ( media-libs/libgphoto2:= )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg2k? ( media-libs/openjpeg:2= )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:0= )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${COMMON_DEPEND}
	opencl? (
		>=sys-devel/clang-4
		>=sys-devel/llvm-4
	)
"
RDEPEND="${COMMON_DEPEND}
	kwallet? ( >=kde-frameworks/kwallet-5.34.0-r1 )
"

PATCHES=(
	"${FILESDIR}"/"${PN}"-find-opencl-header.patch
	"${FILESDIR}"/"${PN}"-2.6.2-exiv2-0.27.patch
)

S="${WORKDIR}/${P/_/~}"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	use cpu_flags_x86_sse3 && append-flags -msse3

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PRINT=$(usex cups)
		-DCUSTOM_CFLAGS=ON
		-DUSE_CAMERA_SUPPORT=$(usex gphoto2)
		-DUSE_COLORD=$(usex colord)
		-DUSE_FLICKR=$(usex flickr)
		-DUSE_GRAPHICSMAGICK=$(usex graphicsmagick)
		-DUSE_KWALLET=$(usex kwallet)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_LUA=OFF
		-DUSE_MAP=$(usex geolocation)
		-DUSE_NLS=$(usex nls)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENEXR=$(usex openexr)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_WEBP=$(usex webp)
	)
	CMAKE_BUILD_TYPE="RELWITHDEBINFO"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc "${DISTDIR}"/${PN}-usermanual-${DOC_PV}.pdf

	if use nls ; then
		for lang in ${LANGS} ; do
			if ! use l10n_${lang}; then
				rm -r "${ED}"/usr/share/locale/${lang/-/_} || die
			fi
		done
	fi

	if use pax_kernel && use opencl ; then
		pax-mark Cm "${ED}"/usr/bin/${PN} || die
		eqawarn "USE=pax_kernel is set meaning that ${PN} will be run"
		eqawarn "under a PaX enabled kernel. To do so, the ${PN} binary"
		eqawarn "must be modified and this *may* lead to breakage! If"
		eqawarn "you suspect that ${PN} is broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "when updating from the currently stable 1.6 series,"
	elog "please bear in mind that your edits will be preserved during this process,"
	elog "but it will not be possible to downgrade from 2.0 to 1.6 any more."
	echo
	ewarn "It will not be possible to downgrade!"
}
