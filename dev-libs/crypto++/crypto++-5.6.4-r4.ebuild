# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib flag-o-matic

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com"
SRC_URI="mirror://sourceforge/cryptopp/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
SLOT="0/5.6" # subslot is so version
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"
IUSE="static-libs test"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_configure() {
	append-flags -fPIC # bug#597514

	local mycmakeargs=(
		-DBUILD_SHARED=ON
		-DBUILD_STATIC=$(usex static-libs ON $(usex test ON OFF))
		-DBUILD_TESTING=$(usex test ON OFF)

		# ASM isn't Darwin/Mach-O ready, #479554
		-DDISABLE_ASM=$([[ ${CHOST} == *-darwin* ]] && echo ON || echo OFF)
	)
	cp config.recommend config.h || die
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	# remove leftovers as build system sucks
	rm -fr "${ED}"/usr/bin "${ED}"/usr/share/cryptopp
	use static-libs || rm -f "${ED}${EPREFIX}"/usr/$(get_libdir)/*.a

	# compatibility
	dosym cryptopp "${EPREFIX}"/usr/include/crypto++
	for f in "${ED}${EPREFIX}"/usr/$(get_libdir)/*; do
		ln -s "$(basename "${f}")" "$(echo "${f}" | sed 's/cryptopp/crypto++/')" || die
	done
}

pkg_preinst() {
	# we switched directory to symlink
	# make sure portage digests that
	rm -fr "${EROOT}/usr/include/crypto++"
	rm -fr "${EROOT}/usr/include/cryptopp"
}
