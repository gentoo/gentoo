# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="C++ library for semigroups and monoids"
HOMEPAGE="https://github.com/libsemigroups/libsemigroups"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

# Source headers have "or any later version"
LICENSE="GPL-3+"
SLOT="0/3"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="cpu_flags_x86_popcnt eigen test"

RESTRICT="!test? ( test )"

# eigen, magic_enum, and catch are header-only
BDEPEND="
	dev-cpp/magic_enum
	eigen? ( >=dev-cpp/eigen-5.0.1 )
	test? ( =dev-cpp/catch-3* )"
DEPEND="dev-libs/libfmt"

#...but magic_enum.hpp is included in one of the headers that
# libsemigroups installs, so it needs to be installed too
RDEPEND="${DEPEND}
	dev-cpp/magic_enum"

PATCHES=(
	"${FILESDIR}/libsemigroups-3.5.5-unbundle-magic_enum.patch"
	"${FILESDIR}/libsemigroups-3.5.5-unbundle-catch.patch"
)

src_prepare() {
	default

	# Remove the bundled Catch2 and magic_enum in concert with two
	# patches. Unbundling magic_enum is pretty easy, the patch adds a
	# ./configure flag. Unbundlng Catch2 is a little harder; first we
	# have to update the include paths, and then we have to ensure that
	# the tests link to the shared library on the system.
	sed -e 's~".*catch_amalgamated.hpp"~<catch2/catch_all.hpp>~g' \
		-i tests/test*.cpp || die
	local CATCH_LIBS='$(LDADD) -lCatch2 -lCatch2Main'
	sed -e "s~_SOURCES .*_party/Catch2.*~_LDADD = $CATCH_LIBS~g" \
		-i Makefile.am || die
	rm -r third_party/{Catch2-3.14.0,magic_enum-0.9.7} || die

	# Unbundle these normally.
	rm -r third_party/{backward-cpp,eigen-5.0.1,fmt-11.1.4,HPCombi-1.1.2} \
		|| die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable eigen) \
		$(use_with eigen external-eigen) \
		--disable-backward \
		--disable-hpcombi \
		--with-external-fmt \
		--with-external-magic-enum
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
