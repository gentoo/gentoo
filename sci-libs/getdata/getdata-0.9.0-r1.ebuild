# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_STANDARD="95"
FORTRAN_NEEDED=fortran
PYTHON_COMPAT=( python2_7 )
inherit autotools fortran-2 python-single-r1

DESCRIPTION="Reference implementation of the Dirfile, format for time-ordered binary data"
HOMEPAGE="http://getdata.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.xz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 cxx debug flac fortran lzma perl python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-remove-python-test.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
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
		$(use_enable python) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
