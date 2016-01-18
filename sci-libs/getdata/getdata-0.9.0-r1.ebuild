# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

FORTRAN_STANDARD="95"
FORTRAN_NEEDED=fortran

inherit autotools eutils fortran-2 python-single-r1

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

PATCHES=(
	"${FILESDIR}/${P}-remove-python-test.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-idl \
		--disable-matlab \
		--disable-php \
		$(use_enable cxx cplusplus) \
		$(use_enable debug) \
		$(use_enable fortran) \
		$(use_enable fortran fortran95) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		--with-libz \
		--without-libslim \
		--without-libzzip \
		$(use_with bzip2 libbz2) \
		$(use_with flac libFLAC) \
		$(use_with lzma liblzma) \
		$(usex perl --with-perl-dir=vendor)
}

src_install() {
	default
	prune_libtool_files --all
}
