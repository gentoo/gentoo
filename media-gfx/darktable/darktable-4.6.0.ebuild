# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )

inherit cmake flag-o-matic lua-single toolchain-funcs xdg

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="https://www.darktable.org/"
LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/darktable-org/${PN}.git"

	LANGS=" af ca cs da de el es fi fr gl he hu it ja nb nl pl pt-BR pt-PT ro ru sk sl sq sv th uk zh-CN zh-TW"
else
	#DOC_PV=$(ver_cut 1-2)
	DOC_PV="4.4"
	MY_PV="${PV/_/}"
	MY_P="${P/_/.}"

	SRC_URI="https://github.com/darktable-org/${PN}/releases/download/release-${MY_PV}/${MY_P}.tar.xz
		doc? (
			https://docs.darktable.org/usermanual/${DOC_PV}/en/${PN}_user_manual.pdf -> ${PN}-usermanual-${DOC_PV}.en.pdf
			l10n_uk? (
				https://docs.darktable.org/usermanual/${DOC_PV}/uk/${PN}_user_manual.pdf
					-> ${PN}-usermanual-${DOC_PV}.uk.pdf
			)
		)"

	KEYWORDS="amd64 ~arm64 -x86"
	LANGS=" cs de es fi fr hu it ja nl pl pt-BR ru sl sq uk zh-CN zh-TW"
fi

IUSE="avif colord cpu_flags_x86_avx cpu_flags_x86_sse3 cups doc gamepad geolocation keyring gphoto2 graphicsmagick heif jpeg2k jpegxl kwallet lto lua midi nls opencl openmp openexr test tools webp
	${LANGS// / l10n_}"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

# It is sometimes requested, by both users and certain devs, to have sys-devel/gcc[graphite]
# in BDEPEND. This has not been done *on purpose*, for the following reason:
#  - darktable can also be built with sys-devel/clang so we'd have to have that, as an alternative,
#    in BDEPEND too
#  - there are at least two darktable dependencies (media-libs/mesa and virtual/rust) which
#    by default pull in sys-devel/clang
#  - as a result of the above, for most gcc users adding the above to BDEPEND is a no-op
#    (and curiously enough, empirical observations suggest current versions of Portage are
#    more likely to pull in Clang to build darktable with than to request enabling USE=graphite
#    on GCC; that might be a bug though)
BDEPEND="dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( >=dev-python/jsonschema-3.2.0 )"
DEPEND="dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/json-glib
	dev-libs/libxml2:2
	>=dev-libs/pugixml-1.8:=
	gnome-base/librsvg:2
	>=media-gfx/exiv2-0.25-r2:=[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	net-libs/libsoup:2.4
	net-misc/curl
	sys-libs/zlib:=
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango
	avif? ( >=media-libs/libavif-0.8.2:= )
	colord? ( x11-libs/colord-gtk:= )
	cups? ( net-print/cups )
	gamepad? ( media-libs/libsdl2 )
	geolocation? ( >=sci-geosciences/osm-gps-map-1.1.0 )
	keyring? ( >=app-crypt/libsecret-0.18 )
	gphoto2? ( media-libs/libgphoto2:= )
	graphicsmagick? ( media-gfx/graphicsmagick )
	heif? ( media-libs/libheif:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	jpegxl? ( media-libs/libjxl:= )
	lua? ( ${LUA_DEPS} )
	midi? ( media-libs/portmidi )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:= )
	webp? ( media-libs/libwebp:= )"
RDEPEND="${DEPEND}
	kwallet? ( >=kde-frameworks/kwallet-5.34.0-r1 )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0_jsonschema-automagic.patch
	"${FILESDIR}"/${PN}-3.4.1_libxcf-cmake.patch
	"${FILESDIR}"/${PN}-4.2.1_cmake-musl.patch
	"${FILESDIR}"/${PN}-4.4.2_fix-has-attribute-musl.patch
)

S="${WORKDIR}/${P/_/~}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# Bug #695658
		if tc-is-gcc; then
			if ! test-flags-CC -floop-block &> /dev/null; then
				eerror "Building ${PN} with GCC requires Graphite support."
				eerror "Please switch to a version of sys-devel/gcc built with USE=graphite, or use a different compiler."
				die "Selected compiler is sys-devel/gcc[-graphite]"
			fi
		fi

		use openmp && tc-check-openmp
	fi
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use lua && lua-single_pkg_setup
}

src_prepare() {
	use cpu_flags_x86_avx && append-flags -mavx
	use cpu_flags_x86_sse3 && append-flags -msse3

	sed -i -e 's:/appdata:/metainfo:g' data/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CURVE_TOOLS=$(usex tools)
		-DBUILD_NOISE_TOOLS=$(usex tools)
		-DBUILD_PRINT=$(usex cups)
		-DCUSTOM_CFLAGS=ON
		-DDONT_USE_INTERNAL_LUA=ON
		-DRAWSPEED_ENABLE_LTO=$(usex lto)
		-DRAWSPEED_ENABLE_WERROR=OFF
		-DRAWSPEED_MUSL_SYSTEM=$(usex elibc_musl)
		-DTESTBUILD_OPENCL_PROGRAMS=OFF
		-DUSE_AVIF=$(usex avif)
		-DUSE_CAMERA_SUPPORT=$(usex gphoto2)
		-DUSE_COLORD=$(usex colord)
		-DUSE_GMIC=OFF
		-DUSE_GRAPHICSMAGICK=$(usex graphicsmagick)
		-DUSE_HEIF=$(usex heif)
		-DUSE_JXL=$(usex jpegxl)
		-DUSE_KWALLET=$(usex kwallet)
		-DUSE_LIBSECRET=$(usex keyring)
		-DUSE_LUA=$(usex lua)
		-DUSE_MAP=$(usex geolocation)
		-DUSE_NLS=$(usex nls)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENEXR=$(usex openexr)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_PORTMIDI=$(usex midi)
		-DUSE_SDL2=$(usex gamepad)
		-DUSE_WEBP=$(usex webp)
		-DWANT_JSON_VALIDATION=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# This USE flag is masked for -9999
	use doc && dodoc "${DISTDIR}"/${PN}-usermanual-${DOC_PV}.*.pdf

	if use nls; then
		for lang in ${LANGS} ; do
			if ! use l10n_${lang}; then
				rm -r "${ED}"/usr/share/locale/${lang/-/_} || die
			fi
		done
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog
	elog "When updating a major version,"
	elog "please bear in mind that your edits will be preserved during this process,"
	elog "but it will not be possible to downgrade any more."
	elog
	ewarn "It will not be possible to downgrade!"
	ewarn
}
