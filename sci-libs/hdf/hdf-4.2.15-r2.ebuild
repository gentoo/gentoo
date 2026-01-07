# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit fortran-2 toolchain-funcs autotools flag-o-matic

DESCRIPTION="General purpose library and format for storing scientific data"
HOMEPAGE="https://www.hdfgroup.org/hdf4.html"
SRC_URI="https://support.hdfgroup.org/ftp/HDF/releases/${PN^^}${PV}/src/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-4.2.15-arch-patches-1.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${PN}-4.2.15-arch-patches-1.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"
IUSE="examples fortran szip static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( szip )"

RDEPEND="net-libs/libtirpc:=
	virtual/zlib:=
	virtual/jpeg:0
	szip? ( virtual/szip )"
DEPEND="${RDEPEND}
	test? ( virtual/szip )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.15-enable-fortran-shared.patch
	"${FILESDIR}"/${PN}-4.2.15-fix-rpch-location.patch

	# May need to extend these for more arches in future.
	# bug #664856
	"${WORKDIR}"/${PN}-4.2.15-arch-patches/

	# backport fix for Modern C
	"${FILESDIR}"/hdf4-c99.patch

	# These tools were dropped upstream. Get them from netcdf...
	"${FILESDIR}"/0001-simply-do-not-build-the-mfhdf-tools-ncgen-ncdump.patch
)

src_prepare() {
	default

	sed -i -e 's/-R/-L/g' config/commence.am || die #rpath
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862720
	#
	# Do not trust with LTO either, just because of strict-aliasing.
	# But also because it does have blatant LTO errors too.
	append-flags -fno-strict-aliasing
	filter-lto

	[[ $(tc-getFC) = *gfortran ]] && append-fflags -fno-range-check
	# GCC 10 workaround
	# bug #723014
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	econf \
		--enable-shared \
		--enable-production=gentoo \
		--disable-netcdf \
		$(use_enable fortran) \
		$(use_enable static-libs static) \
		$(use_with szip szlib) \
		CC="$(tc-getCC)"
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	dodoc release_notes/{RELEASE,HISTORY,bugs_fixed,misc_docs}.txt

	cd "${ED}/usr" || die
	if use examples; then
		mv  share/hdf4_examples share/doc/${PF}/examples || die
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -r share/hdf4_examples || die
	fi
}
