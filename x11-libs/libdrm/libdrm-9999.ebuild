# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/drm.git"
PYTHON_COMPAT=( python3_{9..11} )

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} python-any-r1 meson-multilib

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="https://dri.freedesktop.org/ https://gitlab.freedesktop.org/mesa/drm"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="https://dri.freedesktop.org/libdrm/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

VIDEO_CARDS="amdgpu exynos freedreno intel nouveau omap radeon tegra vc4 vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} valgrind"
RESTRICT="test" # see bug #236845
LICENSE="MIT"
SLOT="0"

RDEPEND="
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')"

python_check_deps() {
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

multilib_src_configure() {
	local emesonargs=(
		# Udev is only used by tests now.
		-Dudev=false
		-Dcairo-tests=disabled
		$(meson_feature video_cards_amdgpu amdgpu)
		$(meson_feature video_cards_exynos exynos)
		$(meson_feature video_cards_freedreno freedreno)
		$(meson_feature video_cards_intel intel)
		$(meson_feature video_cards_nouveau nouveau)
		$(meson_feature video_cards_omap omap)
		$(meson_feature video_cards_radeon radeon)
		$(meson_feature video_cards_tegra tegra)
		$(meson_feature video_cards_vc4 vc4)
		$(meson_feature video_cards_vivante etnaviv)
		$(meson_feature video_cards_vmware vmwgfx)
		# valgrind installs its .pc file to the pkgconfig for the primary arch
		-Dvalgrind=$(usex valgrind auto disabled)
		-Dtests=false # Tests are restricted
	)
	meson_src_configure
}
