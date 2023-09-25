# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# see no-download.patch, match with release date if "master"
HASH_C4FS=0130061b804ae2af0d6cd5919275d552eb1f2414
HASH_C4LOG=00066ad7f624556f066f3d60766a2c33aeb3c6f0
HASH_YAMLTS=6e6c296ae9c9d2d5c4134b4b64d01b29ac19ff6f

DESCRIPTION="Library to parse and emit YAML, and do it fast"
HOMEPAGE="https://github.com/biojppm/rapidyaml/"
SRC_URI="
	https://github.com/biojppm/rapidyaml/releases/download/v${PV}/${P}-src.tgz
	test? (
		https://github.com/biojppm/c4fs/archive/${HASH_C4FS}.tar.gz
			-> ${PN}-c4fs-${HASH_C4FS}.tar.gz
		https://github.com/biojppm/c4log/archive/${HASH_C4LOG}.tar.gz
			-> ${PN}-c4log-${HASH_C4LOG}.tar.gz
		https://github.com/yaml/yaml-test-suite/archive/${HASH_YAMLTS}.tar.gz
			-> ${PN}-yaml-test-suite-${HASH_YAMLTS}.tar.gz
	)"
S="${WORKDIR}/${P}-src"

LICENSE="MIT Boost-1.0 BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.0-libdir.patch
	"${FILESDIR}"/${PN}-0.3.0-system-gtest.patch
	"${FILESDIR}"/${PN}-0.4.0-no-download.patch
)

DOCS=( README.md ROADMAP.md changelog )

src_prepare() {
	if use test; then
		# also need c4core, symlink the one included in src.tgz
		mv ../c4fs-${HASH_C4FS} ext/c4fs &&
			rmdir ext/c4fs/ext/c4core &&
			ln -s ../../c4core ext/c4fs/ext || die

		mv ../c4log-${HASH_C4LOG} ext/c4log &&
			rmdir ext/c4log/ext/c4core &&
			ln -s ../../c4core ext/c4log/ext || die

		mv ../yaml-test-suite-${HASH_YAMLTS} ext/yaml-test-suite || die

		eapply "${FILESDIR}"/${PN}-0.3.0-tests-no-install.patch
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGIT=false # don't call git for nothing
		-DRYML_BUILD_TESTS=$(usex test)
		-DRYML_DBG=$(usex debug)
		-D_{ARCHIVE,LIBRARY}_INSTALL_DIR=$(get_libdir)

		# TODO: enable this+tests, should(?) be easier to do with >=0.5.0 but
		# still need looking into (please fill a bug if need this right away)
		-DRYML_BUILD_API=no

		# rapidyaml sets c++11, but >=gtest-1.13 wants >=c++14 (bug #893272)
		-DC4_CXX_STANDARD=17
	)

	cmake_src_configure
}

src_test() {
	cmake_build test
}
