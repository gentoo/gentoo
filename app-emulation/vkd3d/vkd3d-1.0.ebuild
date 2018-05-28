# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://source.winehq.org/git/vkd3d.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://dev.gentoo.org/~sarnex/distfiles/vkd3d-${PV}.tar.xz"
	S="${WORKDIR}/${PN}"
fi

IUSE="spirv-tools"
RDEPEND="spirv-tools? ( dev-util/spirv-tools:=[${MULTILIB_USEDEP}] )
		 x11-libs/xcb-util-keysyms:=[${MULTILIB_USEDEP}]"

DEPEND="${RDEPEND}"

DESCRIPTION="D3D12 to Vulkan translation library"
HOMEPAGE="https://source.winehq.org/git/vkd3d.git/"

LICENSE="LGPL-2.1"
SLOT="0"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_with spirv-tools)
	)

	ECONF_SOURCE=${S} econf "${myconf[@]}"
}
