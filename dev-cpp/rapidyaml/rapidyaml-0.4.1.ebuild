# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# see *-no-download.patch
C4FS_COMMIT="f78cbd86a77c976395c9834726a14a1bba059af0"
C4LOG_COMMIT="e29915ceeaf9fffb18ba43fb9d6d446d20a1cb4d"
YAMLTS_COMMIT="6e6c296ae9c9d2d5c4134b4b64d01b29ac19ff6f"
C4FS_P="c4fs-${C4FS_COMMIT}"
C4LOG_P="c4log-${C4LOG_COMMIT}"
YAMLTS_P="yaml-test-suite-${YAMLTS_COMMIT}"

DESCRIPTION="Library to parse and emit YAML, and do it fast"
HOMEPAGE="https://github.com/biojppm/rapidyaml/"
SRC_URI="
	https://github.com/biojppm/rapidyaml/releases/download/v${PV}/${P}-src.tgz
	test? (
		https://github.com/biojppm/c4fs/archive/${C4FS_COMMIT}.tar.gz -> ${C4FS_P}.tar.gz
		https://github.com/biojppm/c4log/archive/${C4LOG_COMMIT}.tar.gz -> ${C4LOG_P}.tar.gz
		https://github.com/yaml/yaml-test-suite/archive/${YAMLTS_COMMIT}.tar.gz -> ${YAMLTS_P}.tar.gz
	)"
S="${WORKDIR}/${P}-src"

LICENSE="MIT Boost-1.0 BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 arm64 ppc64 x86"
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
		mv ../${C4FS_P} ext/c4fs &&
			rmdir ext/c4fs/ext/c4core &&
			ln -s ../../c4core ext/c4fs/ext || die

		mv ../${C4LOG_P} ext/c4log &&
			rmdir ext/c4log/ext/c4core &&
			ln -s ../../c4core ext/c4log/ext || die

		mv ../${YAMLTS_P} ext/yaml-test-suite || die

		PATCHES+=( "${FILESDIR}"/${PN}-0.3.0-tests-no-install.patch )
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGIT=false # don't call git nor fail if missing, not a repo
		-DRYML_BUILD_API=no # TODO if a python consumer needs it
		-DRYML_BUILD_TESTS=$(usex test)
		-DRYML_DBG=$(usex debug)
		-D_{ARCHIVE,LIBRARY}_INSTALL_DIR=$(get_libdir)
	)

	cmake_src_configure
}

src_test() {
	cmake_build test
}

src_install() {
	cmake_src_install

	# remove shared private library that is statically linked
	rm "${ED}"/usr/$(get_libdir)/libc4core.so* || die
}
