# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake-multilib python-any-r1

DESCRIPTION="Collection of tools, libraries and tests for shader compilation"
HOMEPAGE="https://github.com/google/shaderc"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="
	>=dev-util/glslang-7.10[${MULTILIB_USEDEP}]
	dev-util/spirv-tools[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/spirv-headers
	doc? ( dev-ruby/asciidoctor )
	test? (
		dev-cpp/gtest
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
	)
"

# https://github.com/google/shaderc/issues/470
RESTRICT=test

PATCHES=( "${FILESDIR}/${P}-fix-glslang-link-order.patch" )

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

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DSHADERC_SKIP_TESTS="$(usex !test)"
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi && use doc; then
		cmake-utils_src_make glslc_doc_README
	fi
	cmake-utils_src_compile
}

multilib_src_install() {
	if multilib_is_native_abi; then
		use doc && local HTML_DOCS=( "${BUILD_DIR}/glslc/README.html" )
	fi
	cmake-utils_src_install
}
