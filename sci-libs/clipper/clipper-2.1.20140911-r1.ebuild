# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran

inherit flag-o-matic fortran-2

DESCRIPTION="Object-oriented libraries for crystallographic data and computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-2.1.20140911_p20160914-fix-c++14.patch.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs test"

RDEPEND="
	sci-libs/libccp4
	sci-libs/fftw:2.1
	sci-libs/mmdb:2"
DEPEND="${RDEPEND}
	test? ( app-shells/tcsh )"

PATCHES=(
	# fix building with GCC 6, #585540
	"${WORKDIR}/${PN}-2.1.20140911_p20160914-fix-c++14.patch"
)

src_configure() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable fortran) \
		--enable-ccp4 \
		--enable-cif \
		--enable-cns \
		--enable-contrib \
		--enable-minimol \
		--enable-mmdb \
		--enable-phs
#		--enable-cctbx
}

src_test() {
	emake -C examples check
	cd examples || die
	sed -e '/mtzdump/d' -i test.csh || die
	PATH="${S}/examples:${PATH}" csh test.csh || die
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
