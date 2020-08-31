# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic git-r3 toolchain-funcs xdg

EGIT_REPO_URI="https://github.com/darktable-org/${PN}.git"

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="https://www.darktable.org/"

LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"
#KEYWORDS="~amd64 ~arm64"
LANGS=" af ca cs da de el es fi fr gl he hu it ja nb nl pl pt-BR pt-PT ro ru sk sl sq sv th uk zh-CN zh-TW"
# TODO add lua once dev-lang/lua-5.2 is unmasked
IUSE="colord cups cpu_flags_x86_sse3 doc flickr geolocation gnome-keyring gphoto2 graphicsmagick jpeg2k kwallet
	lto nls opencl openmp openexr tools webp
	${LANGS// / l10n_}"

BDEPEND=">=dev-python/jsonschema-3.2.0
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
COMMON_DEPEND="
	dev-db/sqlite:3
	dev-libs/json-glib
	dev-libs/libxml2:2
	>=dev-libs/pugixml-1.8:0=
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
	>=x11-libs/gtk+-3.22:3
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
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# Bug #695658
		if tc-is-gcc; then
			test-flags-CC -floop-block &> /dev/null || \
				die "Please switch to a gcc version built with USE=graphite"
		fi

		if use openmp ; then
			tc-has-openmp || die "Please switch to an openmp compatible compiler"
		fi
	fi
}

src_prepare() {
	use cpu_flags_x86_sse3 && append-flags -msse3

	sed -i -e 's:/appdata:/metainfo:g' data/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PRINT=$(usex cups)
		-DBUILD_CURVE_TOOLS=$(usex tools)
		-DBUILD_NOISE_TOOLS=$(usex tools)
		-DCUSTOM_CFLAGS=ON
		-DRAWSPEED_ENABLE_LTO=$(usex lto)
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
}
