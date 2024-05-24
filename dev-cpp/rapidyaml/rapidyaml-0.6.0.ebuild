# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# see no-download.patch, match with release date if "master"
HASH_C4FS=0ee9c03d0ef3a7f12db6cb03570aa7606f12ba1b
HASH_C4LOG=457a2997e8ea26ea2a659b8152621f7fead1eb48
HASH_YAMLTS=6e6c296ae9c9d2d5c4134b4b64d01b29ac19ff6f

DESCRIPTION="Library to parse and emit YAML, and do it fast"
HOMEPAGE="https://github.com/biojppm/rapidyaml/"
SRC_URI="
	https://github.com/biojppm/rapidyaml/releases/download/v${PV}/${P}-src.tgz
	test? (
		https://github.com/biojppm/c4fs/archive/${HASH_C4FS}.tar.gz
			-> c4fs-${HASH_C4FS}.tar.gz
		https://github.com/biojppm/c4log/archive/${HASH_C4LOG}.tar.gz
			-> c4log-${HASH_C4LOG}.tar.gz
		https://github.com/yaml/yaml-test-suite/archive/${HASH_YAMLTS}.tar.gz
			-> yaml-test-suite-${HASH_YAMLTS}.tar.gz
	)
"
S=${WORKDIR}/${P}-src

LICENSE="MIT Boost-1.0 BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-no-download.patch
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

	sed -E "/set\(_(ARCHIVE|LIBRARY)_INSTALL/s:lib/:$(get_libdir)/:" \
		-i ext/c4core/cmake/c4Project.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DGIT=false
		-DRYML_BUILD_TESTS=$(usex test)
		-DRYML_DBG=$(usex debug)

		# TODO?: enable this+tests, should(?) be easier to do with >=0.5.0 but
		# still need looking into (please file a bug if actually need this now)
		-DRYML_BUILD_API=no

		# rapidyaml sets c++11, but (system) >=gtest-1.13 wants >=c++14, also
		# see: https://github.com/biojppm/cmake/commit/e344bf0681 (bug #893272)
		-DC4_CXX_STANDARD=17
	)

	cmake_src_configure
}

src_test() {
	cmake_build test
}
