# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/drm.git"
PYTHON_COMPAT=( python3_{10..12} )

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} python-any-r1 meson-multilib

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="https://dri.freedesktop.org/ https://gitlab.freedesktop.org/mesa/drm"
if [[ ${PV} != 9999* ]]; then
	SRC_URI="https://dri.freedesktop.org/libdrm/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

VIDEO_CARDS="amdgpu exynos freedreno intel nouveau omap radeon tegra vc4 vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

LICENSE="MIT"
SLOT="0"
IUSE="${IUSE_VIDEO_CARDS} test tools udev valgrind"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	valgrind? ( dev-debug/valgrind )"
RDEPEND="${COMMON_DEPEND}
	video_cards_amdgpu? (
		tools? ( >=dev-util/cunit-2.1 )
		test?  ( >=dev-util/cunit-2.1 )
	)
	udev? ( virtual/udev )"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')"

python_check_deps() {
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," \
		symbols-check.py || die # bug #925550
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use udev)
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
		$(meson_native_use_bool tools install-test-programs)
	)

	if use test || { multilib_is_native_abi && use tools; }; then
		emesonargs+=( -Dtests=true  )
	else
		emesonargs+=( -Dtests=false )
	fi
	meson_src_configure
}
