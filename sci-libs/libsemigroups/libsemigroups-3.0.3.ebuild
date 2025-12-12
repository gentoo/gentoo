# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ library for semigroups and monoids"
HOMEPAGE="https://github.com/libsemigroups/libsemigroups"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

# Source headers have "or any later version"
LICENSE="GPL-3+"
SLOT="0/3"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="cpu_flags_x86_popcnt eigen"

# These two deps are packaged, but both are bundled in the third_party
# directory, and the build system hard-codes the location to them:
#
#  * dev-cpp/catch
#  * dev-cpp/magic_enum
#
# Eigen is a set of headers, not a shared library.
BDEPEND="eigen? ( dev-cpp/eigen:= )"
DEPEND="dev-libs/libfmt"
RDEPEND="${DEPEND}"

src_prepare() {
	# Remove bundled deps that we should not be using.
	rm -rf third_party/fmt-* \
	   third_party/eigen-* \
	   third_party/HPCombi || die

	default
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable eigen) \
		$(use_with eigen external-eigen) \
		--disable-hpcombi \
		--with-external-fmt
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
