# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit fortran-2 toolchain-funcs autotools flag-o-matic

DESCRIPTION="General purpose library and format for storing scientific data"
HOMEPAGE="https://www.hdfgroup.org/hdf4.html"
SRC_URI="https://support.hdfgroup.org/ftp/HDF/releases/${PN^^}${PV}/src/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-4.2.15-arch-patches-1.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${PN}-4.2.15-arch-patches-1.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="examples fortran szip static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( szip )"

RDEPEND="net-libs/libtirpc:=
	sys-libs/zlib
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
)

src_prepare() {
	default

	sed -i -e 's/-R/-L/g' config/commence.am || die #rpath
	eautoreconf
}

src_configure() {
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

	mv bin/ncgen{,-hdf} || die
	mv bin/ncdump{,-hdf} || die
	mv share/man/man1/ncgen{,-hdf}.1 || die
	mv share/man/man1/ncdump{,-hdf}.1 || die
}
