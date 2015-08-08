# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils fortran-2 multilib python toolchain-funcs

DESCRIPTION="Scores crystallographic Laue and space groups"
HOMEPAGE="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/pointless.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	sci-chemistry/ccp4-apps
	>=sci-libs/ccp4-libs-6.1.3-r10
	sci-libs/clipper
	sci-libs/fftw:2.1
	sci-libs/mmdb
	>=sci-libs/cctbx-2010.03.29.2334-r3"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_setup() {
	fortran-2_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/1.5.1-gcc4.4.patch
}

src_compile() {
	emake  \
		-f Makefile.make \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		CLIB="${EPREFIX}/usr/$(get_libdir)" \
		CCTBX_VERSION=2010 \
		ICCP4=-I"${EPREFIX}/usr/include/ccp4" \
		ITBX="-I${EPREFIX}/usr/include" \
		ICLPR="-I${EPREFIX}/$(python_get_sitedir)/" \
		LTBX="-L${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_build/lib -lcctbx" \
		SLIB="-L${EPREFIX}/usr/$(get_libdir) -lgfortran" \
		|| die
}

src_install() {
	dobin pointless othercell || die
}
