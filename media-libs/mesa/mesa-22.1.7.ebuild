# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit llvm meson-multilib python-any-r1 linux-info

MY_P="${P/_/-}"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	SRC_URI="https://archive.mesa3d.org/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
RESTRICT="!test? ( test )"

RADEON_CARDS="r300 r600 radeon radeonsi"
VIDEO_CARDS="${RADEON_CARDS} freedreno intel lima nouveau panfrost v3d vc4 virgl vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	cpu_flags_x86_sse2 d3d9 debug gles1 +gles2 +llvm
	lm-sensors opencl osmesa selinux test unwind vaapi valgrind vdpau vulkan
	vulkan-overlay wayland +X xa xvmc zink +zstd"

REQUIRED_USE="
	d3d9?   ( || ( video_cards_intel video_cards_r300 video_cards_r600 video_cards_radeonsi video_cards_nouveau video_cards_vmware ) )
	vulkan? ( video_cards_radeonsi? ( llvm ) )
	vulkan-overlay? ( vulkan )
	video_cards_radeon? ( x86? ( llvm ) amd64? ( llvm ) )
	video_cards_r300?   ( x86? ( llvm ) amd64? ( llvm ) )
	video_cards_radeonsi?   ( llvm )
	xa? ( X )
	xvmc? ( X )
	zink? ( vulkan )
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.110"
RDEPEND="
	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=media-libs/libglvnd-1.3.2[X?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8[${MULTILIB_USEDEP}]
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	llvm? (
		video_cards_radeonsi? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		video_cards_r600? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		video_cards_radeon? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
	)
	lm-sensors? ( sys-apps/lm-sensors:=[${MULTILIB_USEDEP}] )
	opencl? (
				>=virtual/opencl-3[${MULTILIB_USEDEP}]
				dev-libs/libclc
				virtual/libelf:0=[${MULTILIB_USEDEP}]
			)
	vaapi? (
		>=x11-libs/libva-1.7.3:=[${MULTILIB_USEDEP}]
	)
	vdpau? ( >=x11-libs/libvdpau-1.1:=[${MULTILIB_USEDEP}] )
	xvmc? ( >=x11-libs/libXvMC-1.0.8:=[${MULTILIB_USEDEP}] )
	selinux? ( sys-libs/libselinux[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.18.0:=[${MULTILIB_USEDEP}]
	)
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_intel?,video_cards_nouveau?,video_cards_vc4?,video_cards_vivante?,video_cards_vmware?,${MULTILIB_USEDEP}]
	vulkan-overlay? ( dev-util/glslang:0=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxshmfence-1.1:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.13:=[${MULTILIB_USEDEP}]
		x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	)
	zink? ( media-libs/vulkan-loader:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
for card in ${RADEON_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done
RDEPEND="${RDEPEND}
	video_cards_radeonsi? ( ${LIBDRM_DEPSTRING}[video_cards_amdgpu] )
"

# Please keep the LLVM dependency block separate. Since LLVM is slotted,
# we need to *really* make sure we're not pulling one than more slot
# simultaneously.
#
# How to use it:
# 1. List all the working slots (with min versions) in ||, newest first.
# 2. Update the := to specify *max* version, e.g. < 10.
# 3. Specify LLVM_MAX_SLOT, e.g. 9.
LLVM_MAX_SLOT="14"
LLVM_DEPSTR="
	|| (
		sys-devel/llvm:14[${MULTILIB_USEDEP}]
		sys-devel/llvm:13[${MULTILIB_USEDEP}]
	)
	<sys-devel/llvm-$((LLVM_MAX_SLOT + 1)):=[${MULTILIB_USEDEP}]
"
LLVM_DEPSTR_AMDGPU=${LLVM_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
CLANG_DEPSTR=${LLVM_DEPSTR//llvm/clang}
CLANG_DEPSTR_AMDGPU=${CLANG_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
RDEPEND="${RDEPEND}
	llvm? (
		opencl? (
			video_cards_r600? (
				${CLANG_DEPSTR_AMDGPU}
			)
			!video_cards_r600? (
				video_cards_radeonsi? (
					${CLANG_DEPSTR_AMDGPU}
				)
			)
			!video_cards_r600? (
				!video_cards_radeonsi? (
					video_cards_radeon? (
						${CLANG_DEPSTR_AMDGPU}
					)
				)
			)
			!video_cards_r600? (
				!video_cards_radeon? (
					!video_cards_radeonsi? (
						${CLANG_DEPSTR}
					)
				)
			)
		)
		!opencl? (
			video_cards_r600? (
				${LLVM_DEPSTR_AMDGPU}
			)
			!video_cards_r600? (
				video_cards_radeonsi? (
					${LLVM_DEPSTR_AMDGPU}
				)
			)
			!video_cards_r600? (
				!video_cards_radeonsi? (
					video_cards_radeon? (
						${LLVM_DEPSTR_AMDGPU}
					)
				)
			)
			!video_cards_r600? (
				!video_cards_radeon? (
					!video_cards_radeonsi? (
						${LLVM_DEPSTR}
					)
				)
			)
		)
	)
"
unset {LLVM,CLANG}_DEPSTR{,_AMDGPU}

DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
	wayland? ( >=dev-libs/wayland-protocols-1.24 )
	X? (
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-base/xorg-proto
	)
"
BDEPEND="
	${PYTHON_DEPS}
	opencl? (
		>=sys-devel/gcc-4.6
	)
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	$(python_gen_any_dep ">=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]")
	wayland? ( dev-util/wayland-scanner )
"

S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR=${S}

QA_WX_LOAD="
x86? (
	usr/lib*/libglapi.so.0.0.0
	usr/lib*/libGLESv1_CM.so.1.1.0
	usr/lib*/libGLESv2.so.2.0.0
	usr/lib*/libGL.so.1.2.0
	usr/lib*/libOSMesa.so.8.0.0
	usr/lib/libGLX_mesa.so.0.0.0
)"

llvm_check_deps() {
	local flags=${MULTILIB_USEDEP}
	if use video_cards_r600 || use video_cards_radeon || use video_cards_radeonsi
	then
		flags+=",llvm_targets_AMDGPU(-)"
	fi

	if use opencl; then
		has_version "sys-devel/clang:${LLVM_SLOT}[${flags}]" || return 1
	fi
	has_version "sys-devel/llvm:${LLVM_SLOT}[${flags}]"
}

pkg_pretend() {
	if use vulkan; then
		if ! use video_cards_freedreno &&
		   ! use video_cards_intel &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_v3d; then
			ewarn "Ignoring USE=vulkan     since VIDEO_CARDS does not contain freedreno, intel, radeonsi, or v3d"
		fi
	fi

	if use opencl; then
		if ! use video_cards_r600 &&
		   ! use video_cards_radeonsi; then
			ewarn "Ignoring USE=opencl     since VIDEO_CARDS does not contain r600 or radeonsi"
		fi
	fi

	if use vaapi; then
		if ! use video_cards_r600 &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_nouveau; then
			ewarn "Ignoring USE=vaapi      since VIDEO_CARDS does not contain r600, radeonsi, or nouveau"
		fi
	fi

	if use vdpau; then
		if ! use video_cards_r300 &&
		   ! use video_cards_r600 &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_nouveau; then
			ewarn "Ignoring USE=vdpau      since VIDEO_CARDS does not contain r300, r600, radeonsi, or nouveau"
		fi
	fi

	if use xa; then
		if ! use video_cards_freedreno &&
		   ! use video_cards_nouveau &&
		   ! use video_cards_vmware; then
			ewarn "Ignoring USE=xa         since VIDEO_CARDS does not contain freedreno, nouveau, or vmware"
		fi
	fi

	if use xvmc; then
		if ! use video_cards_r600 &&
		   ! use video_cards_nouveau; then
			ewarn "Ignoring USE=xvmc       since VIDEO_CARDS does not contain r600 or nouveau"
		fi
	fi

	if ! use llvm; then
		use opencl     && ewarn "Ignoring USE=opencl     since USE does not contain llvm"
	fi

	if use osmesa && ! use llvm; then
		ewarn "OSMesa will be slow without enabling USE=llvm"
	fi
}

python_check_deps() {
	python_has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	if use video_cards_intel ||
	   use video_cards_radeonsi; then
		if kernel_is -ge 5 11 3; then
			CONFIG_CHECK="~KCMP"
		elif kernel_is -ge 5 11; then
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		elif kernel_is -ge 5 10 20; then
			CONFIG_CHECK="~KCMP"
		else
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		fi
		linux-info_pkg_setup
	fi

	if use llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

multilib_src_configure() {
	local emesonargs=()

	local platforms
	use X && platforms+="x11"
	use wayland && platforms+=",wayland"
	emesonargs+=(-Dplatforms=${platforms#,})

	if use video_cards_intel ||
	   use video_cards_r300 ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_nouveau ||
	   use video_cards_vmware; then
		emesonargs+=($(meson_use d3d9 gallium-nine))
	else
		emesonargs+=(-Dgallium-nine=false)
	fi

	if use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_nouveau; then
		emesonargs+=($(meson_feature vaapi gallium-va))
		use vaapi && emesonargs+=( -Dva-libs-path="${EPREFIX}"/usr/$(get_libdir)/va/drivers )
	else
		emesonargs+=(-Dgallium-va=disabled)
	fi

	if use video_cards_r300 ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_nouveau; then
		emesonargs+=($(meson_feature vdpau gallium-vdpau))
	else
		emesonargs+=(-Dgallium-vdpau=disabled)
	fi

	if use video_cards_freedreno ||
	   use video_cards_nouveau ||
	   use video_cards_vmware; then
		emesonargs+=($(meson_feature xa gallium-xa))
	else
		emesonargs+=(-Dgallium-xa=disabled)
	fi

	if use video_cards_r600 ||
	   use video_cards_nouveau; then
		emesonargs+=($(meson_feature xvmc gallium-xvmc))
	else
		emesonargs+=(-Dgallium-xvmc=disabled)
	fi

	if use video_cards_freedreno ||
	   use video_cards_lima ||
	   use video_cards_panfrost ||
	   use video_cards_v3d ||
	   use video_cards_vc4 ||
	   use video_cards_vivante; then
		gallium_enable -- kmsro
	fi

	gallium_enable -- swrast
	gallium_enable video_cards_freedreno freedreno
	gallium_enable video_cards_intel crocus i915 iris
	gallium_enable video_cards_lima lima
	gallium_enable video_cards_nouveau nouveau
	gallium_enable video_cards_panfrost panfrost
	gallium_enable video_cards_v3d v3d
	gallium_enable video_cards_vc4 vc4
	gallium_enable video_cards_virgl virgl
	gallium_enable video_cards_vivante etnaviv
	gallium_enable video_cards_vmware svga
	gallium_enable zink zink

	gallium_enable video_cards_r300 r300
	gallium_enable video_cards_r600 r600
	gallium_enable video_cards_radeonsi radeonsi
	if ! use video_cards_r300 && \
		! use video_cards_r600; then
		gallium_enable video_cards_radeon r300 r600
	fi

	# opencl stuff
	emesonargs+=(
		-Dgallium-opencl="$(usex opencl icd disabled)"
	)

	if use vulkan; then
		vulkan_enable video_cards_freedreno freedreno
		vulkan_enable video_cards_intel intel
		vulkan_enable video_cards_radeonsi amd
		vulkan_enable video_cards_v3d broadcom
	fi

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	local vulkan_layers
	use vulkan && vulkan_layers+="device-select"
	use vulkan-overlay && vulkan_layers+=",overlay"
	emesonargs+=(-Dvulkan-layers=${vulkan_layers#,})

	emesonargs+=(
		$(meson_use test build-tests)
		-Dglx=$(usex X dri disabled)
		-Dshared-glapi=enabled
		-Ddri3=enabled
		-Degl=enabled
		-Dgbm=enabled
		-Dglvnd=true
		$(meson_feature gles1)
		$(meson_feature gles2)
		$(meson_feature llvm)
		$(meson_feature lm-sensors lmsensors)
		$(meson_use osmesa)
		$(meson_use selinux)
		$(meson_feature unwind libunwind)
		$(meson_feature zstd)
		$(meson_use cpu_flags_x86_sse2 sse2)
		-Dvalgrind=$(usex valgrind auto disabled)
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure
}

multilib_src_test() {
	meson_src_test -t 100
}

# $1 - VIDEO_CARDS flag (check skipped for "--")
# other args - names of DRI drivers to enable
gallium_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		GALLIUM_DRIVERS+=("$@")
	fi
}

vulkan_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		VULKAN_DRIVERS+=("$@")
	fi
}
