# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils fortran-2 multilib toolchain-funcs versionator

DESCRIPTION="A library for fast updating of QR and Cholesky decompositions"
HOMEPAGE="http://sourceforge.net/projects/qrupdate"
SRC_URI="mirror://sourceforge/qrupdate/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.1-makefile.patch

	local BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"
	local LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"

	sed -i Makeconf \
		-e "s:gfortran:$(tc-getFC):g" \
		-e "s:FFLAGS=.*:FFLAGS=${FFLAGS}:" \
		-e "s:BLAS=.*:BLAS=${BLAS_LIBS}:" \
		-e "s:LAPACK=.*:LAPACK=${LAPACK_LIBS}:" \
		|| die "Failed to set up Makeconf"
}

src_compile() {
	emake solib || die "emake failed"
}

src_install() {
	newlib.so libqrupdate.so libqrupdate.so.1 \
		|| die "Failed to install libqrupdate.so.1"
	dosym libqrupdate.so.1 /usr/$(get_libdir)/libqrupdate.so
	dodoc README ChangeLog || die "dodoc failed"
}
