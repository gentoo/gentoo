# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda
inherit meson-multilib flag-o-matic

DESCRIPTION="C libary for Netflix's Perceptual video quality assessment"
HOMEPAGE="https://github.com/Netflix/vmaf"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Netflix/vmaf.git"
	S="${WORKDIR}/libvmaf-${PV}"
else
	SRC_URI="
		https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/Netflix/vmaf/commit/85098c0bd6d4accc56013471f0bc05d1f12e7c79.patch -> ${PN}-3.0.0-PR1397.patch
	"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
	S="${WORKDIR}/vmaf-${PV}"
fi

LICENSE="BSD-2-with-patent"
SLOT="0/$(ver_cut 1)"
IUSE="+asm cuda +doc +embed-models +float test"

CPU_FEATURES_MAP=(
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vl
)
IUSE+=" ${CPU_FEATURES_MAP[*]}"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/nasm
	embed-models? ( app-editors/vim-core )
"

DEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"

RDEPEND="
	${BDEPEND}
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.0-cuda-inc-dirs.patch"
	"${FILESDIR}/${PN}-3.0.0-nvtx3-is-header-only.patch"
	"${FILESDIR}/${PN}-3.0.0-cuda-fix-crappy-memory-handling.patch"
	"${DISTDIR}/${PN}-3.0.0-PR1397.patch"
)

src_prepare() {
	default

	if use cuda; then
		cuda_src_prepare

		sed \
			-e "s#/usr/local/cuda/include#${CUDA_PATH:-${ESYSROOT}/opt/cuda}/include#g" \
			-i libvmaf/src/meson.build \
			|| die
	fi

	# Workaround for https://bugs.gentoo.org/837221
	# The paths in the tests are hard coded to look for the model folder as "../../model"
	sed -i "s|\"../../model|\"../vmaf-${PV}/model|g" "${S}"/libvmaf/test/* || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dcpp_std=c++17
		$(meson_use asm enable_asm)
		$(meson_use cuda enable_cuda)
		$(meson_use cuda enable_nvtx)
		$(meson_use doc enable_docs)
		$(meson_use embed-models built_in_models)
		$(meson_use float enable_float)
		$(meson_use test enable_tests)
	)

	if
		use asm &&
		use cpu_flags_x86_avx512bw &&
		use cpu_flags_x86_avx512cd &&
		use cpu_flags_x86_avx512dq &&
		use cpu_flags_x86_avx512f &&
		use cpu_flags_x86_avx512vbmi &&
		use cpu_flags_x86_avx512vl; then
		emesonargs+=(
			-Denable_avx512="true"
		)
	fi

	if use cuda; then
		export NVCC_CCBIN="$(cuda_gccdir)"

		cuda_add_sandbox -w
		addpredict "/dev/char/"
	fi

	append-cflags -Wno-error=incompatible-pointer-types -Wno-error=int-conversion -Wno-error=implicit-function-declaration
	filter-lto

	EMESON_SOURCE="${S}/libvmaf"
	meson_src_configure
}

multilib_src_test() {
	if use cuda; then
		cuda_add_sandbox -w
	fi

	meson_src_test -j1
}

multilib_src_install() {
	meson_src_install
	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}

multilib_src_install_all() {
	einstalldocs

	insinto "/usr/share/vmaf"
	doins -r "${S}/model"
}
