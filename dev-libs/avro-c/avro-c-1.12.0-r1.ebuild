# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="c library for the apache avro data serialization system"
HOMEPAGE="https://avro.apache.org/"
SRC_URI="https://archive.apache.org/dist/avro/avro-${PV}/c/avro-c-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/snappy:=
	>=dev-libs/jansson-2.3:=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_test() {
	local CMAKE_SKIP_TESTS=(
		test_avro_commons_schema # commons is only in full distro, not in avro-c
	)

	cmake_src_test
}

src_install() {
	cmake_src_install
	# cmake doesn't have an option to enable/disable static libs
	rm "${ED}"/usr/$(get_libdir)/libavro.a || die
}
