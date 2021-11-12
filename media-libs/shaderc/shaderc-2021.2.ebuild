# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8,3_9} )

CMAKE_ECLASS=cmake

inherit cmake-multilib python-any-r1

DESCRIPTION="Collection of tools, libraries and tests for shader compilation"
HOMEPAGE="https://github.com/google/shaderc"
EGIT_COMMIT="d0d8d7e7ea5074cb107499a73a22ce14bec3fb10"
SRC_URI="https://github.com/google/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 x86"
IUSE="doc test"

RDEPEND="
	>=dev-util/glslang-11.6.0[${MULTILIB_USEDEP}]
	>=dev-util/spirv-tools-20210825[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/spirv-headers-20210817
	doc? ( dev-ruby/asciidoctor )
	test? (
		dev-cpp/gtest
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
	)
"

PATCHES=(
		"${FILESDIR}"/${PN}-2020.4-fix-build.patch
)

# https://github.com/google/shaderc/issues/470
RESTRICT=test

python_check_deps() {
	if use test; then
		has_version --host-root "dev-python/nose[${PYTHON_USEDEP}]"
	fi
}

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
		-DSHADERC_SKIP_TESTS="$(usex !test)"
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
