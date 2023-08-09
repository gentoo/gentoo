# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit cmake-multilib multibuild python-any-r1

DESCRIPTION="Collection of tools, libraries and tests for shader compilation"
HOMEPAGE="https://github.com/google/shaderc"
EGIT_COMMIT="${PV}"
SRC_URI="https://github.com/google/${PN}/archive/v${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc"

RDEPEND="
	>=dev-util/glslang-1.3.250:=[${MULTILIB_USEDEP}]
	>=dev-util/spirv-tools-1.3.250[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/spirv-headers-1.3.250"

BDEPEND="doc? ( dev-ruby/asciidoctor )"

PATCHES=(
	"${FILESDIR}"/${PN}-2020.4-fix-build.patch
)

# https://github.com/google/shaderc/issues/470
RESTRICT=test

src_prepare() {
	cmake_comment_add_subdirectory examples

	# Unbundle glslang, spirv-headers, spirv-tools
	cmake_comment_add_subdirectory third_party
	sed -i \
		-e "s|\$<TARGET_FILE:spirv-dis>|${EPREFIX}/usr/bin/spirv-dis|" \
		glslc/test/CMakeLists.txt || die

	# Disable git versioning
	sed -i -e '/build-version/d' glslc/CMakeLists.txt || die

	# Manually create build-version.inc as we disabled git versioning
	cat <<- EOF > glslc/src/build-version.inc || die
		"${P}\n"
		"$(best_version dev-util/spirv-tools)\n"
		"$(best_version dev-util/glslang)\n"
	EOF

	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DSHADERC_SKIP_TESTS="true"
		-DSHADERC_ENABLE_WERROR_COMPILE="false"
	)
	cmake_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi && use doc; then
		cmake_src_compile glslc_doc_README
	fi
	cmake_src_compile
}

multilib_src_install() {
	if multilib_is_native_abi; then
		use doc && local HTML_DOCS=( "${BUILD_DIR}/glslc/README.html" )
	fi
	cmake_src_install
}
