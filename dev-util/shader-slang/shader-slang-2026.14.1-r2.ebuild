# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Making it easier to work with shaders"
HOMEPAGE="https://shader-slang.org/"
# tarball is same as upstream except for including git submodules
SRC_URI="https://distfiles.gentoo.org/pub/dev/ionen@gentoo.org/${P}.tar.xz"

LICENSE="
	Apache-2.0-with-LLVM-exceptions
	Apache-2.0 Boost-1.0 CC-BY-4.0 MIT Unlicense UoI-NCSA
"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"

# needs an annoying submodule that fetches many things, the tests do
# runtime compilation that fail due to missing headers, and they also
# need special care and be fed a list of expected failures -- would
# rather not bother when what the (current) maintainer want is just
# a bin/slangc that works to build x11-terms/kitty as a test
RESTRICT="test"

RDEPEND="
	app-arch/lz4:=
	dev-libs/miniz:=
	dev-util/glslang:=
	dev-util/spirv-tools
"
DEPEND="
	${RDEPEND}
	>=dev-util/spirv-headers-1.4.350
	dev-util/vulkan-headers
"

PATCHES=(
	"${FILESDIR}"/${PN}-2026.14.1-includedir.patch
	"${FILESDIR}"/${PN}-2026.14.1-libdir.patch
	"${FILESDIR}"/${PN}-2026.14.1-lz4.patch
	"${FILESDIR}"/${PN}-2026.14.1-system-glslang.patch
)

# triggers on examples and other unused subdirs
CMAKE_QA_COMPAT_SKIP=1

# these are modules and do not need a soname
QA_SONAME="
	usr/lib.*/libslang-glsl-module-.*.so
	usr/lib.*/libslang-glslang-.*.so
"

src_configure() {
	# https://github.com/shader-slang/slang/issues/6330
	use elibc_musl && append-lfs-flags

	local mycmakeargs=(
		-DSLANG_ENABLE_PCH=no
		-DSLANG_ENABLE_SLANG_GLSLANG=yes
		-DSLANG_ENABLE_SPLIT_DEBUG_INFO=no
		-DSLANG_USE_SYSTEM_GLSLANG=yes
		-DSLANG_USE_SYSTEM_LZ4=yes
		-DSLANG_USE_SYSTEM_MINIZ=yes
		-DSLANG_USE_SYSTEM_SPIRV_HEADERS=yes
		-DSLANG_USE_SYSTEM_SPIRV_TOOLS=yes
		-DSLANG_USE_SYSTEM_VULKAN_HEADERS=yes
		-DSLANG_VERSION_{FULL,NUMERIC}=${PV}

		# avoid collisions with sys-libs/slang
		-DCMAKE_INSTALL_INCLUDEDIR=include/${PN}
		-DSLANG_ENABLE_SLANG_PROXY=no

		# options disabled for simplicity, will revisit only if needed
		# (some have issues ranging from build failure to live fetching)
		-DSLANG_ENABLE_AFTERMATH=no
		-DSLANG_ENABLE_CUDA=no
		-DSLANG_ENABLE_DXIL=no
		-DSLANG_ENABLE_EXAMPLES=no
		-DSLANG_ENABLE_GFX=no
		-DSLANG_ENABLE_OPTIX=no
		-DSLANG_ENABLE_SLANG_RHI=no
		-DSLANG_ENABLE_TESTS=no
		-DSLANG_SLANG_LLVM_FLAVOR=DISABLE
	)

	cmake_src_configure
}

src_install() {
	local DOCS=()
	cmake_src_install

	mv -- "${ED}"/usr/share/doc/{slang,${PF}} || die
}
