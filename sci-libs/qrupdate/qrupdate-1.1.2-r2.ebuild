# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 flag-o-matic multilib toolchain-funcs

DESCRIPTION="Library for updating of QR and Cholesky decompositions"
HOMEPAGE="https://sourceforge.net/projects/qrupdate"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ppc ppc64 ~riscv ~sparc ~x86"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-Makefiles.patch
	"${FILESDIR}"/${PN}-1.1.2-install.patch
)

src_prepare() {
	default

	# bug #878989
	filter-lto

	# GCC 10 workaround
	# bug #741524
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	sed -i Makeconf \
		-e "s|gfortran|$(tc-getFC)|g" \
		-e "s|FFLAGS=.*|FFLAGS=${FFLAGS}|" \
		-e "s|BLAS=.*|BLAS=$($(tc-getPKG_CONFIG) --libs blas)|" \
		-e "s|LAPACK=.*|LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)|" \
		-e "/^LIBDIR=/a\PREFIX=${EPREFIX}/usr" \
		-e "s|LIBDIR=lib|LIBDIR=$(get_libdir)|" \
		|| die "Failed to set up Makeconf"
}

src_compile() {
	emake solib
}

src_install() {
	emake DESTDIR="${D}" install-shlib
	dosym libqrupdate.so.$(ver_cut 1) /usr/$(get_libdir)/libqrupdate.so
	dodoc README ChangeLog
}
