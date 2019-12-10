# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran

inherit fortran-2 toolchain-funcs autotools flag-o-matic

MYP=${P/_p/-patch}

DESCRIPTION="General purpose library and format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/hdf4.html"
SRC_URI="http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/${MYP}.tar.bz2"

SLOT="0"
LICENSE="NCSA-HDF"
KEYWORDS="amd64 ia64 ppc -sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples fortran szip static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( szip )"

RDEPEND="
	net-libs/libtirpc
	sys-libs/zlib
	virtual/jpeg:0
	szip? ( virtual/szip )"
DEPEND="${RDEPEND}
	test? ( virtual/szip )"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.11-fix-szip-detection.patch
	"${FILESDIR}"/${PN}-4.2.11-enable-fortran-shared.patch
	"${FILESDIR}"/${PN}-4.2.13-fix-xdr-configure.patch
	"${FILESDIR}"/${PN}-4.2.13-linux-tirpc.patch
)

src_prepare() {
	default
	sed -i -e 's/-R/-L/g' config/commence.am || die #rpath
	eautoreconf
	[[ $(tc-getFC) = *gfortran ]] && append-fflags -fno-range-check
}

src_configure() {
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
	use static-libs || prune_libtool_files --all
	dodoc release_notes/{RELEASE,HISTORY,bugs_fixed,misc_docs}.txt
	cd "${ED}"usr
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
