# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/35"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs test threads bindist"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/gmp:0=
	>=dev-libs/gf2x-0.9"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"

pkg_setup() {
	replace-flags -O[3-9] -O2
}

src_configure() {
	# Currently the build system can build a static library or
	# both static and shared libraries. But not only shared libraries.
	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		SHARED=on \
		NTL_GMP_LIP=on NTL_GF2X_LIB=on \
		$(usex threads NTL_THREADS= NTL_THREADS= on off) \
		$(usex bindist NATIVE= NATIVE= off on) \
		|| die "DoConfig failed"
}

src_install() {
	default
	if ! use static-libs; then
		prune_libtool_files --all
		rm -f "${ED}"/usr/$(get_libdir)/libntl.a
	fi

	cd ..
	rm -rf "${ED}"/usr/share/doc/NTL
	dodoc README
	if use doc ; then
		dodoc doc/*.txt
		docinto html
		dodoc doc/*.html doc/*.gif
	fi
}
