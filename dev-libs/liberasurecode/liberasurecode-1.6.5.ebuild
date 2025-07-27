# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends"
HOMEPAGE="https://opendev.org/openstack/liberasurecode"
SRC_URI="https://github.com/openstack/liberasurecode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-text/doxygen )
	test? (
		dev-libs/isa-l
		dev-libs/jerasure
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# Don't use '-march=native'
		--disable-mmi
		--disable-werror
		$(use_enable doc doxygen)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# 'check' just builds the tests
	emake test
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature_header "Install optional pluggable Erasure Code backeds:"
	optfeature "Intel Storage Acceleration Library - SIMD accelerated backend" dev-libs/isa-l
	optfeature "Erasure Coding library that supports Reed-Solomon, Cauchy backends" dev-libs/jerasure
}
