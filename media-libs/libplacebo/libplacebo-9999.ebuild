# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python3_{7,8,9} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/libplacebo.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~ppc64 ~x86"
	SRC_URI="https://code.videolan.org/videolan/libplacebo/-/archive/v${PV}/libplacebo-v${PV}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
fi

inherit meson multilib-minimal python-any-r1

DESCRIPTION="Reusable library for GPU-accelerated image processing primitives"
HOMEPAGE="https://code.videolan.org/videolan/libplacebo"

LICENSE="LGPL-2.1+"
# Please add a sub-slot for releases depending on libplacebo.so version
SLOT="0"
IUSE="glslang lcms +opengl +shaderc test +vulkan"
REQUIRED_USE="vulkan? ( || ( glslang shaderc ) )"
RESTRICT="!test? ( test )"

RDEPEND="glslang? ( dev-util/glslang[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms:2[${MULTILIB_USEDEP}] )
	opengl? ( media-libs/libepoxy[${MULTILIB_USEDEP}] )
	shaderc? ( >=media-libs/shaderc-2017.2[${MULTILIB_USEDEP}] )
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig
	vulkan? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/mako[${PYTHON_USEDEP}]')
	)"

python_check_deps() {
	has_version -b "dev-python/mako[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use vulkan && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature glslang)
		$(meson_feature lcms)
		$(meson_feature opengl)
		$(meson_feature shaderc)
		$(meson_feature vulkan)
		$(meson_use test tests)
		# hard-code path from dev-util/vulkan-headers
		-Dvulkan-registry=/usr/share/vulkan/registry/vk.xml
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test -t 10
}

multilib_src_install() {
	meson_src_install
}
