# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Release signer can vary per version but not clear if others will be doing
# them in future, so gone with Even Rouault for now as he does other geosci
# stuff too like PROJ, GDAL. Previous release manager of TIFF was
# GraphicsMagick maintainer Bob Friesenhahn. Please be careful when verifying
# who made releases.
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/evenrouault.asc
inherit libtool multilib-minimal verify-sig flag-o-matic

MY_P="${P/_rc/rc}"
DESCRIPTION="Tag Image File Format (TIFF) library"
HOMEPAGE="http://libtiff.maptools.org"
SRC_URI="https://download.osgeo.org/libtiff/${MY_P}.tar.xz"
SRC_URI+=" verify-sig? ( https://download.osgeo.org/libtiff/${MY_P}.tar.xz.sig )"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="libtiff"
SLOT="0/6"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE="+cxx jbig jpeg lerc libdeflate lzma opengl static-libs test webp zlib zstd"
RESTRICT="!test? ( test )"

# lerc?( zlib ): bug #953883
# test? ( jpeg ): bug #483132
REQUIRED_USE="
	lerc? ( zlib )
	libdeflate? ( zlib )
	test? ( jpeg )
"

RDEPEND="
	jbig? ( >=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lerc? ( media-libs/lerc:=[${MULTILIB_USEDEP}] )
	libdeflate? ( app-arch/libdeflate[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/freeglut virtual/opengl )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( >=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-1.3.7-r1:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-evenrouault-20250913 )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
)

src_prepare() {
	default

	# Added to fix cross-compilation
	elibtoolize
}

multilib_src_configure() {
	append-lfs-flags

	local myeconfargs=(
		--disable-sphinx
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cxx)
		$(use_enable jbig)
		$(use_enable jpeg)
		$(multilib_native_use_enable opengl)
		$(use_enable lerc)
		$(use_enable libdeflate)
		$(use_enable lzma)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable webp)
		$(use_enable zlib)
		$(use_enable zstd)

		$(multilib_native_enable docs)
		$(multilib_native_enable contrib)
		$(multilib_native_enable tools)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/{README*,RELEASE-DATE,TODO,VERSION} || die
}
