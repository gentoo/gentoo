# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com"
SRC_URI="mirror://sourceforge/cryptopp/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
SLOT="0/5.6" # subslot is so version
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"
IUSE="static-libs"

DEPEND="app-arch/unzip"

S="${WORKDIR}"
PATCHES=(
	# Building with -march=native breaks when one wants to build for older CPUs.
	"${FILESDIR}/${P}-nonative.patch"
)

src_configure() {
	cp config.recommend config.h || die
}

src_compile() {
	# higher optimizations cause problems
	replace-flags -O3 -O2
	# ASM isn't Darwin/Mach-O ready, #479554, buildsys doesn't grok CPPFLAGS
	[[ ${CHOST} == *-darwin* ]] && append-flags -DCRYPTOPP_DISABLE_X86ASM

	CXX="$(tc-getCXX)" \
	emake -f GNUmakefile \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		PREFIX="${EPREFIX}/usr" \
		all shared
}

src_test() {
	# ensure that all test vectors have Unix line endings
	local file
	for file in TestVectors/* ; do
		edos2unix "${file}"
	done

	if ! CXX="$(tc-getCXX)" emake test ; then
		eerror "Crypto++ self-tests failed."
		eerror "Try to remove some optimization flags and reemerge Crypto++."
		die "emake test failed"
	fi
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install

	# remove leftovers as build system sucks
	rm -fr "${ED}"/usr/bin "${ED}"/usr/share/cryptopp
	use static-libs || rm -f "${ED}${EPREFIX}"/usr/$(get_libdir)/*.a

	# compatibility
	dosym cryptopp "${EPREFIX}"/usr/include/crypto++
	for f in "${ED}${EPREFIX}"/usr/$(get_libdir)/*; do
		ln -s "$(basename "${f}")" "$(echo "${f}" | sed 's/cryptopp/crypto++/')" || die
	done
}
