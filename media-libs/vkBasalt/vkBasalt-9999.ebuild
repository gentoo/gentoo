# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

DESCRIPTION="A Vulkan post processing layer for Linux"
HOMEPAGE="https://github.com/DadSchoorse/vkBasalt"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/DadSchoorse/${PN}.git"
	KEYWORDS=""
	inherit git-r3
else
	SRC_URI="https://github.com/DadSchoorse/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="ZLIB"
SLOT="0"

IUSE="+reshade-shaders"

RDEPEND="
	reshade-shaders? ( media-gfx/reshade-shaders )
	>=x11-libs/libX11-1.6.2:=[${MULTILIB_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-util/glslang:0=[${MULTILIB_USEDEP}]
	media-libs/vulkan-layers
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
"

multilib_src_configure() {
	local emesonargs=()

	emesonargs+=(
		-Dwith_so=true
		-Dwith_json=true
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	if use reshade-shaders; then
		sed -i 's@\#reshadeTexturePath = \*path/to/reshade-shaders/Textures\*@reshadeTexturePath = /usr/share/reshade-shaders/Textures@g' config/${PN}.conf || die
		sed -i 's@\#reshadeIncludePath = \*path/to/reshade-shaders/Shaders\*@reshadeIncludePath = /usr/share/reshade-shaders/Shaders@g' config/${PN}.conf || die
	fi
	insinto /usr/share/${PN}
	doins config/${PN}.conf

	einstalldocs
}
