# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QA_PKGCONFIG_VERSION="$(ver_cut 1-3)"

# Release signer can vary per version but not clear if others will be doing
# them in future, so gone with Even Rouault for now as he does other geosci
# stuff too like PROJ, GDAL. Previous release manager of TIFF was
# GraphicsMagick maintainer Bob Friesenhahn. Please be careful when verifying
# who made releases.
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/rouault.asc
inherit multilib-minimal verify-sig libtool flag-o-matic

MY_P="${P/_rc/rc}"
DESCRIPTION="Tag Image File Format (TIFF) library (compat package for libtiff.so.5)"
HOMEPAGE="http://libtiff.maptools.org"
SRC_URI="https://download.osgeo.org/libtiff/${MY_P/-compat}.tar.xz"
SRC_URI+=" verify-sig? ( https://download.osgeo.org/libtiff/${MY_P/-compat}.tar.xz.sig )"
S="${WORKDIR}/${PN/-compat}-$(ver_cut 1-3)"

LICENSE="libtiff"
SLOT="4"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="+cxx jbig jpeg lzma test webp zlib zstd"
RESTRICT="!test? ( test )"

# bug #483132
REQUIRED_USE="test? ( jpeg )"

RDEPEND="
	jbig? ( >=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-1.3.7-r1:=[${MULTILIB_USEDEP}] )
	!=media-libs/tiff-4.4*
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-evenrouault )"

# Easier to keep this even though we remove the headers to avoid
# triggering multilib header check
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
)

PATCHES=(
	"${FILESDIR}"/${PN/-compat}-4.4.0_rc1-skip-thumbnail-test.patch
	"${FILESDIR}"/${P/-compat}-hylafaxplus-regression.patch
)

src_prepare() {
	default

	# Added to fix cross-compilation
	elibtoolize
}

multilib_src_configure() {
	append-lfs-flags

	local myeconfargs=(
		--without-x
		$(use_enable cxx)
		$(use_enable jbig)
		$(use_enable jpeg)
		$(use_enable lzma)
		$(use_enable webp)
		$(use_enable zlib)
		$(use_enable zstd)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	sed -i \
		-e 's/ tools//' \
		-e 's/ contrib//' \
		-e 's/ man//' \
		-e 's/ html//' \
		Makefile || die
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/include || die
	rm -r "${ED}"/usr/share || die
	rm -r "${ED}"/usr/lib*/pkgconfig || die
	rm -r "${ED}"/usr/lib*/*.so || die

	find "${ED}" -type f -name '*.la' -delete || die
}
