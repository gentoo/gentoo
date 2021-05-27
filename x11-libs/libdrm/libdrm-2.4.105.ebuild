# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/drm.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson multilib-minimal

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="https://dri.freedesktop.org/ https://gitlab.freedesktop.org/mesa/drm"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="https://dri.freedesktop.org/libdrm/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

VIDEO_CARDS="amdgpu exynos freedreno intel nouveau omap radeon tegra vc4 vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} libkms valgrind"
RESTRICT="test" # see bug #236845
LICENSE="MIT"
SLOT="0"

RDEPEND="
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"

multilib_src_configure() {
	local emesonargs=(
		# Udev is only used by tests now.
		-Dudev=false
		-Dcairo-tests=false
		-Damdgpu=$(usex video_cards_amdgpu true false)
		-Dexynos=$(usex video_cards_exynos true false)
		-Dfreedreno=$(usex video_cards_freedreno true false)
		-Dintel=$(usex video_cards_intel true false)
		-Dnouveau=$(usex video_cards_nouveau true false)
		-Domap=$(usex video_cards_omap true false)
		-Dradeon=$(usex video_cards_radeon true false)
		-Dtegra=$(usex video_cards_tegra true false)
		-Dvc4=$(usex video_cards_vc4 true false)
		-Detnaviv=$(usex video_cards_vivante true false)
		-Dvmwgfx=$(usex video_cards_vmware true false)
		-Dlibkms=$(usex libkms true false)
		# valgrind installs its .pc file to the pkgconfig for the primary arch
		-Dvalgrind=$(usex valgrind auto false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
