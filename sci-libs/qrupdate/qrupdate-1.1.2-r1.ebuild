# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils fortran-2 multilib versionator toolchain-funcs

DESCRIPTION="Library for updating of QR and Cholesky decompositions"
HOMEPAGE="https://sourceforge.net/projects/qrupdate"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~ppc-macos"
IUSE="static-libs"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.1.1-Makefiles.patch \
		"${FILESDIR}"/${PN}-1.1.2-install.patch
	sed -i Makeconf \
		-e "s:gfortran:$(tc-getFC):g" \
		-e "s:FFLAGS=.*:FFLAGS=${FFLAGS}:" \
		-e "s:BLAS=.*:BLAS=$($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:LAPACK=.*:LAPACK=$($(tc-getPKG_CONFIG) --libs lapack):" \
		-e "/^LIBDIR=/a\PREFIX=${EPREFIX}/usr" \
		-e "s:LIBDIR=lib:LIBDIR=$(get_libdir):" \
		|| die "Failed to set up Makeconf"
}

src_compile() {
	emake solib
	use static-libs && emake lib
}

src_install() {
	emake DESTDIR="${D}" install-shlib
	dosym libqrupdate.so.$(get_major_version) /usr/$(get_libdir)/libqrupdate.so
	use static-libs && emake DESTDIR="${D}" install-staticlib
	dodoc README ChangeLog
}
