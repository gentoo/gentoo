# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson-multilib python-any-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/libplacebo.git"
	inherit git-r3
else
	GLAD_PV=2.0.4
	FASTFLOAT_PV=5.2.0
	SRC_URI="
		https://code.videolan.org/videolan/libplacebo/-/archive/v${PV}/libplacebo-v${PV}.tar.bz2
		https://github.com/fastfloat/fast_float/archive/refs/tags/v${FASTFLOAT_PV}.tar.gz
			-> fast_float-${FASTFLOAT_PV}.tar.gz
		opengl? (
			https://github.com/Dav1dde/glad/archive/refs/tags/v${GLAD_PV}.tar.gz
				-> ${PN}-glad-${GLAD_PV}.tar.gz
		)
	"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Reusable library for GPU-accelerated image processing primitives"
HOMEPAGE="
	https://libplacebo.org/
	https://code.videolan.org/videolan/libplacebo/
"

LICENSE="
	LGPL-2.1+
	|| ( Apache-2.0 Boost-1.0 MIT )
	opengl? ( MIT )
"
SLOT="0/$(ver_cut 2 ${PV}.9999)" # soname
IUSE="glslang +lcms llvm-libunwind +opengl +shaderc test unwind +vulkan +xxhash"
RESTRICT="!test? ( test )"
REQUIRED_USE="vulkan? ( || ( glslang shaderc ) )"

# dlopen: libglvnd (glad)
RDEPEND="
	lcms? ( media-libs/lcms:2[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/libglvnd[${MULTILIB_USEDEP}] )
	shaderc? ( media-libs/shaderc[${MULTILIB_USEDEP}] )
	!shaderc? ( glslang? ( dev-util/glslang:=[${MULTILIB_USEDEP}] ) )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${MULTILIB_USEDEP}] )
	)
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )
"
# vulkan-headers is required even with USE=-vulkan (bug #882065)
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
	xxhash? ( dev-libs/xxhash[${MULTILIB_USEDEP}] )
"
BDEPEND="
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.229.1-llvm-libunwind.patch
	"${FILESDIR}"/${PN}-5.229.1-python-executable.patch
)

python_check_deps() {
	python_has_version "dev-python/jinja[${PYTHON_USEDEP}]"
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		local EGIT_SUBMODULES=(
			3rdparty/fast_float
			$(usev opengl 3rdparty/glad)
		)
		git-r3_src_unpack
	else
		default

		rmdir "${S}"/3rdparty/fast_float || die
		mv fast_float-${FASTFLOAT_PV} "${S}"/3rdparty/fast_float || die

		if use opengl; then
			rmdir "${S}"/3rdparty/glad || die
			mv glad-${GLAD_PV} "${S}"/3rdparty/glad || die
		fi
	fi
}

src_prepare() {
	default

	# typically auto-skipped, but may assume usable opengl/vulkan then hang
	sed -i "/tests += 'opengl_surfaceless.c'/d" src/opengl/meson.build || die
	sed -i "/tests += 'vulkan.c'/d" src/vulkan/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		-Ddemos=false #851927
		$(meson_use test tests)
		$(meson_feature lcms)
		-Dlibdovi=disabled # TODO: package libdovi, ask if you need this
		$(meson_feature opengl)
		$(meson_feature opengl gl-proc-addr)
		$(meson_feature shaderc)
		$(usex shaderc -Dglslang=disabled $(meson_feature glslang))
		$(meson_feature unwind)
		$(meson_feature vulkan)
		$(meson_feature vulkan vk-proc-addr)
		-Dvulkan-registry="${ESYSROOT}"/usr/share/vulkan/registry/vk.xml
		$(meson_feature xxhash)
	)

	meson_src_configure
}
