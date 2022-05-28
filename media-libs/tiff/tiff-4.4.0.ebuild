# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QA_PKGCONFIG_VERSION="$(ver_cut 1-3)"

# Release signer can vary per version but not clear if others will be doing
# them in future, so gone with Even Rouault for now as he does other geosci
# stuff too like PROJ, GDAL. Previous release manager of TIFF was
# GraphicsMagick maintainer Bob Friesenhahn. Please be careful when verifying
# who made releases.
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/rouault.asc
inherit multilib-minimal verify-sig

MY_P="${P/_rc/rc}"
DESCRIPTION="Tag Image File Format (TIFF) library"
HOMEPAGE="http://libtiff.maptools.org"
SRC_URI="https://download.osgeo.org/libtiff/${MY_P}.tar.xz"
SRC_URI+=" verify-sig? ( https://download.osgeo.org/libtiff/${MY_P}.tar.xz.sig )"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="libtiff"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="+cxx jbig jpeg lzma static-libs test webp zlib zstd"
RESTRICT="!test? ( test )"

# bug #483132
REQUIRED_USE="test? ( jpeg )"

RDEPEND="jbig? ( >=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-1.3.7-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-evenrouault )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
)

PATCHES=(
	"${FILESDIR}"/${PN}-4.4.0_rc1-skip-thumbnail-test.patch
)

multilib_src_configure() {
	local myeconfargs=(
		--without-x
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cxx)
		$(use_enable jbig)
		$(use_enable jpeg)
		$(use_enable lzma)
		$(use_enable static-libs static)
		$(use_enable webp)
		$(use_enable zlib)
		$(use_enable zstd)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	# Remove components (like tools) that are irrelevant for the multilib
	# build which we only want libraries for.
	# TODO: upstream options to disable these properly
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ tools//' \
			-e 's/ contrib//' \
			-e 's/ man//' \
			-e 's/ html//' \
			Makefile || die
	fi
}

multilib_src_test() {
	if ! multilib_is_native_abi ; then
		emake -C tools
	fi

	emake check
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/{COPYRIGHT,README*,RELEASE-DATE,TODO,VERSION} || die
}
