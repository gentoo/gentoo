# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#AUTOTOOLS_AUTORECONF=true

FORTRAN_NEEDED=fortran

inherit autotools-utils eutils fortran-2 flag-o-matic

#MY_PV=${PV/_p/-}
#MY_P="${PN}-${MY_PV}"

DESCRIPTION="Object-oriented libraries for crystallographic data and crystallographic computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs test"

RDEPEND="
	sci-libs/libccp4
	sci-libs/fftw:2.1
	sci-libs/mmdb:2"
DEPEND="${RDEPEND}
	test? ( app-shells/tcsh )"

src_configure() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	local myeconfargs=(
#		--enable-cctbx
		--enable-ccp4
		--enable-cif
		--enable-cns
		--enable-contrib
		--enable-minimol
		--enable-mmdb
		--enable-phs
		$(use_enable fortran)
		)
	autotools-utils_src_configure
}

src_test() {
	emake -C "${AUTOTOOLS_BUILD_DIR}"/examples check
	cd "${AUTOTOOLS_BUILD_DIR}"/examples || die
	cp "${S}"/examples/{test.csh,*mtz} . || die
	sed -e '/mtzdump/d' -i test.csh || die
	PATH="${AUTOTOOLS_BUILD_DIR}/examples:${PATH}" csh test.csh || die
}
