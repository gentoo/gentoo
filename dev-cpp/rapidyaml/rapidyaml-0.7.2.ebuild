# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

# see no-download.patch, match with release date if "master"
HASH_C4FS=59cfbae26b821f4d4c50ff0775219cb739fa7f46
HASH_C4LOG=f4cf64caedd622a739aaa3ecb67a5aac105c2919
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
# Bumped fwiw, but believe the future of this package is to be last-rited --
# its build system is a maintenance headache and the only remaining revdep
# (jsonnet) is not only incompatible with this version but upstream has
# switched to single-header version and will not be able to easily use
# system's anymore: https://github.com/google/jsonnet/commit/4003c4df8ee
#
# Leaving unkeyworded rather than do extra work until likely last-rites.
# If kept, will be dropped to m-n given I no longer need this. Feel free
# to take over and drop this comment if needed.
#KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
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
	# not looked into, but tests fail with lto and USE=debug fails to build
	filter-lto

	local mycmakeargs=(
		-DGIT=false
		-DRYML_BUILD_TESTS=$(usex test)
		-DRYML_DBG=$(usex debug)
		-DRYML_TEST_FUZZ=no

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
