# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/virgl/virglrenderer.git"
	inherit git-r3
else
	MY_P="${PN}-${P}"
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${P}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="amd64 ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test venus vaapi video_cards_amdgpu video_cards_asahi video_cards_freedreno X"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/libdrm-2.4.121
	media-libs/libepoxy[X?]
	media-libs/mesa
	venus? ( media-libs/vulkan-loader )
	vaapi? ( media-libs/libva:= )
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep "
		dev-python/pyyaml[\${PYTHON_USEDEP}]
	")
"

python_check_deps() {
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" || return 1
}

src_configure() {
	local -a gpus=()
	use video_cards_amdgpu && gpus+=( amdgpu-experimental )
	use video_cards_asahi && gpus+=( asahi )
	use video_cards_freedreno && gpus+=( msm )

	# Build egl unconditionally. Tests and vaapi require it.
	local -a platforms=( egl )
	use X && platforms+=( glx )

	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Ddrm-renderers=$(IFS=,; echo "${gpus[*]}")
		-Dplatforms=$(IFS=,; echo "${platforms[*]}")
		-Dvulkan-dload=false
		$(meson_use test tests)
		$(meson_use venus)
		$(meson_use vaapi video)
	)

	meson_src_configure
}

src_test() {
	# Most of the testsuite cannot run in our sandboxed environment, just don't
	# deal with it for now.  Instead lets run a subset of tests atleast.
	meson_src_test test_virgl_gbm_resources test_fuzzer_formats
}
