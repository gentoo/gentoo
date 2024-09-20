# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2)"
IUSE="+aom gdk-pixbuf go rav1e svt-av1 test +threads x265"
REQUIRED_USE="test? ( go )"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-cpp/catch
		dev-lang/go
	)
"
DEPEND="
	media-libs/dav1d:=[${MULTILIB_USEDEP}]
	media-libs/libde265:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	media-libs/tiff:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )
	go? ( dev-lang/go )
	rav1e? ( media-video/rav1e:= )
	svt-av1? ( media-libs/svt-av1:=[${MULTILIB_USEDEP}] )
	x265? ( media-libs/x265:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

# https://github.com/strukturag/libheif/issues/1249
PATCHES=( "${FILESDIR}"/${P}-prepend_DESTDIR_when_generating_heif-convert_symlink.patch )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libheif/heif_version.h
)

src_prepare() {
	if use test ; then
		# bug 865351
		rm tests/catch.hpp || die
		ln -s "${ESYSROOT}"/usr/include/catch2/catch.hpp tests/catch.hpp || die
	fi

	cmake_src_prepare

	multilib_copy_sources
}

multilib_src_configure() {
	export GO111MODULE=auto
	local mycmakeargs=(
		-DENABLE_PLUGIN_LOADING=true
		-DWITH_LIBDE265=true
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_RAV1E="$(multilib_native_usex rav1e)"
		-DWITH_SvtEnc="$(usex svt-av1)"
		-DWITH_X265=$(usex x265)
		-DWITH_KVAZAAR=true
		-DWITH_JPEG_DECODER=true
		-DWITH_JPEG_ENCODER=true
		-DWITH_OpenJPEG_DECODER=true
		-DWITH_OpenJPEG_ENCODER=true
	)
	cmake_src_configure
}

multilib_src_compile() {
	default
	cmake_src_compile
}

multilib_src_test() {
	default
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	einstalldocs
}
