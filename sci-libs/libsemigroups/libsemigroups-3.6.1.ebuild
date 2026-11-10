# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

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
# eigen has a subslot
RDEPEND="${DEPEND}
	eigen? ( >=dev-cpp/eigen-5.0.1:= )
	dev-cpp/magic_enum"

src_prepare() {
	default

	# Ensure that these are unbundled.
	rm -r third_party/{Catch2-3.14.0,HPCombi-1.1.2,backward-cpp,eigen-5.0.1,fmt-11.1.4,magic_enum-0.9.7} \
		|| die
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable eigen) \
		$(use_with eigen external-eigen) \
		$(use_with test external-catch) \
		--disable-backward \
		--disable-hpcombi \
		--with-external-fmt \
		--with-external-magic-enum
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
