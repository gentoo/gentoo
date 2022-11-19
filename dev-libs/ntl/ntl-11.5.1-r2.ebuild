# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs gnuconfig

DESCRIPTION="High-performance and portable C++ number theory library"
HOMEPAGE="https://www.shoup.net/ntl/ https://github.com/libntl/ntl"
SRC_URI="https://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/44"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc static-libs threads cpu_flags_x86_avx2"

BDEPEND="dev-lang/perl"
DEPEND="dev-libs/gmp:0=
	dev-libs/gf2x
	threads? ( >=dev-libs/gf2x-1.2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

DOCS=( "${WORKDIR}/${P}"/README )

src_unpack() {
	default
	gnuconfig_update "${S}/libtool-origin/"
}

src_configure() {
	# The DoConfig script builds its own libtool, but doesn't
	# really try to set up the build environment (bug 718892).
	export CC="$(tc-getCC)"
	export CXX="$(tc-getCXX)"

	# Currently the build system can build a static library or both
	# static and shared libraries, but not only shared libraries. The
	# name NTL_GMP_LIP is *not* a typo.
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
		NTL_GMP_LIP=on \
		NTL_GF2X_LIB=on \
		NTL_THREADS=$(usex threads on off) \
		NTL_ENABLE_AVX_FFT=$(usex cpu_flags_x86_avx2 on off) \
		NATIVE=off \
		|| die "DoConfig failed"

	if use doc; then
		DOCS+=( "${WORKDIR}/${P}"/doc/*.txt )
		HTML_DOCS=( "${WORKDIR}/${P}"/doc/*.html "${WORKDIR}/${P}"/doc/*.gif )
	fi

	# 780534 - Required for rlibtool so it can find the generated libtool
	ln -sf libtool-build/libtool . || die
}

src_install() {
	default

	if ! use static-libs; then
		# bug #775884
		find "${ED}" -name '*.la' -delete || die

		# Use rm -f because the static archive may not be created when
		# using (for example) slibtool-shared.
		rm -f "${ED}/usr/$(get_libdir)"/libntl.a || die
	fi

	rm -r "${ED}"/usr/share/doc/NTL || die
}
