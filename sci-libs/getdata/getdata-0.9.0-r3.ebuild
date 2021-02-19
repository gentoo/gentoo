# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_STANDARD="95"
FORTRAN_NEEDED=fortran
inherit autotools fortran-2 flag-o-matic

DESCRIPTION="Reference implementation of the Dirfile, format for time-ordered binary data"
HOMEPAGE="http://getdata.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.xz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 cxx debug flac fortran lzma perl static-libs"

DEPEND="
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-remove-python-test.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# GCC 10 workaround
	# bug #723076
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	econf \
		--disable-idl \
		--disable-matlab \
		--disable-php \
		--with-libz \
		--without-libslim \
		--without-libzzip \
		$(use_with bzip2 libbz2) \
		$(use_enable cxx cplusplus) \
		$(use_enable debug) \
		$(use_with flac libFLAC) \
		$(use_enable fortran) \
		$(use_enable fortran fortran95) \
		$(use_with lzma liblzma) \
		$(use_enable perl) \
		$(usex perl --with-perl-dir=vendor) \
		--disable-python \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
