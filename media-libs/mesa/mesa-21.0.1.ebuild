# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit llvm meson multilib-minimal python-any-r1 linux-info

OPENGL_DIR="xorg-x11"

MY_P="${P/_/-}"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	SRC_URI="https://archive.mesa3d.org/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
RESTRICT="
	!test? ( test )
"

RADEON_CARDS="r100 r200 r300 r600 radeon radeonsi"
VIDEO_CARDS="${RADEON_CARDS} freedreno i915 i965 intel iris lima nouveau panfrost v3d vc4 virgl vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	+classic d3d9 debug +dri3 +egl +gallium +gbm gles1 +gles2 +llvm
	lm-sensors opencl osmesa selinux test unwind vaapi valgrind vdpau vulkan
	vulkan-overlay wayland +X xa xvmc zink +zstd"

REQUIRED_USE="
	d3d9?   ( dri3 || ( video_cards_iris video_cards_r300 video_cards_r600 video_cards_radeonsi video_cards_nouveau video_cards_vmware ) )
	gles1?  ( egl )
	gles2?  ( egl )
	osmesa? ( gallium )
	vulkan? ( dri3
			  video_cards_radeonsi? ( llvm ) )
	vulkan-overlay? ( vulkan )
	wayland? ( egl gbm )
	video_cards_freedreno?  ( gallium )
	video_cards_intel?  ( classic )
	video_cards_i915?   ( || ( classic gallium ) )
	video_cards_i965?   ( classic )
	video_cards_iris?   ( gallium )
	video_cards_lima?   ( gallium )
	video_cards_nouveau? ( || ( classic gallium ) )
	video_cards_panfrost? ( gallium )
	video_cards_radeon? ( || ( classic gallium )
						  gallium? ( x86? ( llvm ) amd64? ( llvm ) ) )
	video_cards_r100?   ( classic )
	video_cards_r200?   ( classic )
	video_cards_r300?   ( gallium x86? ( llvm ) amd64? ( llvm ) )
	video_cards_r600?   ( gallium )
	video_cards_radeonsi?   ( gallium llvm )
	video_cards_v3d? ( gallium )
	video_cards_vc4? ( gallium )
	video_cards_virgl? ( gallium )
	video_cards_vivante? ( gallium gbm )
	video_cards_vmware? ( gallium )
	xa? ( X )
	xvmc? ( X )
	zink? ( gallium vulkan )
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.100"
RDEPEND="
	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=media-libs/libglvnd-1.3.2[X?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8[${MULTILIB_USEDEP}]
	gallium? (
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
	)
	selinux? ( sys-libs/libselinux[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.18.0:=[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.8
	)
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_nouveau?,video_cards_vc4?,video_cards_vivante?,video_cards_vmware?,${MULTILIB_USEDEP}]
	video_cards_intel? (
		!video_cards_i965? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	)
	video_cards_i915? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
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
LLVM_MAX_SLOT="11"
LLVM_DEPSTR="
	|| (
		sys-devel/llvm:11[${MULTILIB_USEDEP}]
		sys-devel/llvm:10[${MULTILIB_USEDEP}]
		sys-devel/llvm:9[${MULTILIB_USEDEP}]
	)
	<sys-devel/llvm-$((LLVM_MAX_SLOT + 1)):=[${MULTILIB_USEDEP}]
"
LLVM_DEPSTR_AMDGPU=${LLVM_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
CLANG_DEPSTR=${LLVM_DEPSTR//llvm/clang}
CLANG_DEPSTR_AMDGPU=${CLANG_DEPSTR//]/,llvm_targets_AMDGPU(-)]}
RDEPEND="${RDEPEND}
	gallium? (
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
	)
"
unset {LLVM,CLANG}_DEPSTR{,_AMDGPU}

DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
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
		if ! use video_cards_i965 &&
		   ! use video_cards_iris &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_v3d; then
			ewarn "Ignoring USE=vulkan     since VIDEO_CARDS does not contain i965, iris, radeonsi, or v3d"
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

	if ! use gallium; then
		use lm-sensors && ewarn "Ignoring USE=lm-sensors since USE does not contain gallium"
		use llvm       && ewarn "Ignoring USE=llvm       since USE does not contain gallium"
		use opencl     && ewarn "Ignoring USE=opencl     since USE does not contain gallium"
		use vaapi      && ewarn "Ignoring USE=vaapi      since USE does not contain gallium"
		use vdpau      && ewarn "Ignoring USE=vdpau      since USE does not contain gallium"
		use unwind     && ewarn "Ignoring USE=unwind     since USE does not contain gallium"
		use xa         && ewarn "Ignoring USE=xa         since USE does not contain gallium"
		use xvmc       && ewarn "Ignoring USE=xvmc       since USE does not contain gallium"
	fi

	if ! use llvm; then
		use opencl     && ewarn "Ignoring USE=opencl     since USE does not contain llvm"
	fi

	if use osmesa && ! use llvm; then
		ewarn "OSMesa will be slow without enabling USE=llvm"
	fi
}

python_check_deps() {
	has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	if use video_cards_i965 ||
	   use video_cards_iris ||
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

	if use gallium && use llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

multilib_src_configure() {
	local emesonargs=()

	if use classic; then
		# Intel code
		dri_driver_enable video_cards_i915 i915
		dri_driver_enable video_cards_i965 i965
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			dri_driver_enable video_cards_intel i915 i965
		fi

		# Nouveau code
		dri_driver_enable video_cards_nouveau nouveau

		# ATI code
		dri_driver_enable video_cards_r100 r100
		dri_driver_enable video_cards_r200 r200
		if ! use video_cards_r100 && \
			! use video_cards_r200; then
			dri_driver_enable video_cards_radeon r100 r200
		fi
	fi

	local platforms
	use X && platforms+="x11"
	use wayland && platforms+=",wayland"
	emesonargs+=(-Dplatforms=${platforms#,})

	if use X || use egl; then
		emesonargs+=(-Dglvnd=true)
	else
		emesonargs+=(-Dglvnd=false)
	fi

	if use gallium; then
		emesonargs+=(
			$(meson_feature llvm)
			$(meson_feature lm-sensors lmsensors)
			$(meson_feature unwind libunwind)
		)

		if use video_cards_iris ||
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
		gallium_enable video_cards_lima lima
		gallium_enable video_cards_panfrost panfrost
		gallium_enable video_cards_v3d v3d
		gallium_enable video_cards_vc4 vc4
		gallium_enable video_cards_vivante etnaviv
		gallium_enable video_cards_vmware svga
		gallium_enable video_cards_nouveau nouveau
		gallium_enable zink zink

		# Only one i915 driver (classic vs gallium). Default to classic.
		if ! use classic; then
			gallium_enable video_cards_i915 i915
			if ! use video_cards_i915 && \
				! use video_cards_i965; then
				gallium_enable video_cards_intel i915
			fi
		fi

		gallium_enable video_cards_iris iris

		gallium_enable video_cards_r300 r300
		gallium_enable video_cards_r600 r600
		gallium_enable video_cards_radeonsi radeonsi
		if ! use video_cards_r300 && \
			! use video_cards_r600; then
			gallium_enable video_cards_radeon r300 r600
		fi

		gallium_enable video_cards_freedreno freedreno
		gallium_enable video_cards_virgl virgl

		# opencl stuff
		emesonargs+=(
			-Dgallium-opencl="$(usex opencl icd disabled)"
		)
	fi

	if use vulkan; then
		vulkan_enable video_cards_i965 intel
		vulkan_enable video_cards_iris intel
		vulkan_enable video_cards_radeonsi amd
		vulkan_enable video_cards_v3d broadcom
	fi

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	emesonargs+=(
		$(meson_use test build-tests)
		-Dglx=$(usex X dri disabled)
		-Dshared-glapi=enabled
		$(meson_feature dri3)
		$(meson_feature egl)
		$(meson_feature gbm)
		$(meson_feature gles1)
		$(meson_feature gles2)
		$(meson_use osmesa)
		$(meson_use selinux)
		$(meson_feature zstd)
		-Dvalgrind=$(usex valgrind auto false)
		-Ddri-drivers=$(driver_list "${DRI_DRIVERS[*]}")
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		$(meson_use vulkan vulkan-device-select-layer)
		$(meson_use vulkan-overlay vulkan-overlay-layer)
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
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
	einstalldocs
}

multilib_src_test() {
	meson_src_test -t 100
}

# $1 - VIDEO_CARDS flag (check skipped for "--")
# other args - names of DRI drivers to enable
dri_driver_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		DRI_DRIVERS+=("$@")
	fi
}

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
