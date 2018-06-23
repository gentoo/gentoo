# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit llvm meson multilib-minimal pax-utils python-any-r1

OPENGL_DIR="xorg-x11"

MY_P="${P/_/-}"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	EXPERIMENTAL="true"
	inherit git-r3
else
	SRC_URI="https://mesa.freedesktop.org/archive/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
RESTRICT="
	!test? ( test )
"

RADEON_CARDS="r100 r200 r300 r600 radeon radeonsi"
VIDEO_CARDS="${RADEON_CARDS} freedreno i915 i965 imx intel nouveau vc4 virgl vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	+classic d3d9 debug +dri3 +egl +gallium +gbm gles1 gles2 +llvm lm_sensors
	opencl osmesa openmax pax_kernel pic selinux test unwind vaapi valgrind
	vdpau vulkan wayland xa xvmc"

REQUIRED_USE="
	d3d9?   ( dri3 gallium )
	llvm?   ( gallium )
	opencl? ( gallium llvm || ( video_cards_r600 video_cards_radeonsi ) )
	openmax? ( gallium )
	gles1?  ( egl )
	gles2?  ( egl )
	vaapi? ( gallium )
	vdpau? ( gallium )
	vulkan? ( || ( video_cards_i965 video_cards_radeonsi )
			  video_cards_radeonsi? ( llvm ) )
	wayland? ( egl gbm )
	xa?  ( gallium
		   || ( video_cards_freedreno video_cards_i915
				video_cards_nouveau video_cards_vmware ) )
	video_cards_freedreno?  ( gallium )
	video_cards_intel?  ( classic )
	video_cards_i915?   ( || ( classic gallium ) )
	video_cards_i965?   ( classic )
	video_cards_imx?    ( gallium video_cards_vivante )
	video_cards_nouveau? ( || ( classic gallium ) )
	video_cards_radeon? ( || ( classic gallium )
						  gallium? ( x86? ( llvm ) amd64? ( llvm ) ) )
	video_cards_r100?   ( classic )
	video_cards_r200?   ( classic )
	video_cards_r300?   ( gallium x86? ( llvm ) amd64? ( llvm ) )
	video_cards_r600?   ( gallium )
	video_cards_radeonsi?   ( gallium llvm )
	video_cards_vc4? ( gallium )
	video_cards_virgl? ( gallium )
	video_cards_vivante? ( gallium gbm )
	video_cards_vmware? ( gallium )
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.91"
RDEPEND="
	!app-eselect/eselect-mesa
	>=app-eselect/eselect-opengl-1.3.0
	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2:=[${MULTILIB_USEDEP}]
	>=x11-libs/libxshmfence-1.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.4-r1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXxf86vm-1.1.3:=[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.13:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
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
		lm_sensors? ( sys-apps/lm_sensors:=[${MULTILIB_USEDEP}] )
		opencl? (
					app-eselect/eselect-opencl
					dev-libs/libclc
					virtual/libelf:0=[${MULTILIB_USEDEP}]
				)
		openmax? (
			>=media-libs/libomxil-bellagio-0.9.3:=[${MULTILIB_USEDEP}]
			x11-misc/xdg-utils
		)
		vaapi? (
			>=x11-libs/libva-1.7.3:=[${MULTILIB_USEDEP}]
			video_cards_nouveau? ( !<=x11-libs/libva-vdpau-driver-0.7.4-r3 )
		)
		vdpau? ( >=x11-libs/libvdpau-1.1:=[${MULTILIB_USEDEP}] )
		xvmc? ( >=x11-libs/libXvMC-1.0.8:=[${MULTILIB_USEDEP}] )
	)
	wayland? (
		>=dev-libs/wayland-1.15.0:=[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.8
	)
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_nouveau?,video_cards_vc4?,video_cards_vivante?,video_cards_vmware?,${MULTILIB_USEDEP}]

	video_cards_intel? (
		!video_cards_i965? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	)
	video_cards_i915? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
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
# 2. Update the := to specify *max* version, e.g. < 7.
# 3. Specify LLVM_MAX_SLOT, e.g. 6.
LLVM_DEPSTR="
	|| (
		sys-devel/llvm:7[${MULTILIB_USEDEP}]
		sys-devel/llvm:6[${MULTILIB_USEDEP}]
		sys-devel/llvm:5[${MULTILIB_USEDEP}]
		sys-devel/llvm:4[${MULTILIB_USEDEP}]
		>=sys-devel/llvm-3.9.0:0[${MULTILIB_USEDEP}]
	)
	sys-devel/llvm:=[${MULTILIB_USEDEP}]
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
	${PYTHON_DEPS}
	opencl? (
		>=sys-devel/gcc-4.6
	)
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	valgrind? ( dev-util/valgrind )
	x11-base/xorg-proto
	$(python_gen_any_dep ">=dev-python/mako-0.7.3[\${PYTHON_USEDEP}]")
"

S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR=${S}

QA_WX_LOAD="
x86? (
	!pic? (
		usr/lib*/libglapi.so.0.0.0
		usr/lib*/libGLESv1_CM.so.1.0.0
		usr/lib*/libGLESv2.so.2.0.0
		usr/lib*/libGL.so.1.2.0
		usr/lib*/libOSMesa.so.8.0.0
	)
)"

llvm_check_deps() {
	local flags=${MULTILIB_USEDEP}
	if use video_cards_r600 || use video_cards_radeon || use video_cards_radeonsi
	then
		flags+=",llvm_targets_AMDGPU(-)"
	fi

	if use opencl; then
		has_version "sys-devel/clang[${flags}]" || return 1
	fi
	has_version "sys-devel/llvm[${flags}]"
}

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	if use llvm; then
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

	if use egl; then
		emesonargs+=( -Dplatforms=x11,surfaceless$(use wayland && echo ",wayland")$(use gbm && echo ",drm") )
	fi

	if use gallium; then
		emesonargs+=(
			$(meson_use d3d9 gallium-nine)
			$(meson_use llvm)
			-Dgallium-omx=$(usex openmax bellagio disabled)
			$(meson_use vaapi gallium-va)
			$(meson_use vdpau gallium-vdpau)
			$(meson_use xa gallium-xa)
			$(meson_use xvmc gallium-xvmc)
		)
		use vaapi && emesonargs+=( -Dva-libs-path=/usr/$(get_libdir)/va/drivers )

		gallium_enable video_cards_vc4 vc4
		gallium_enable video_cards_vivante etnaviv
		gallium_enable video_cards_vmware svga
		gallium_enable video_cards_nouveau nouveau
		gallium_enable video_cards_i915 i915
		gallium_enable video_cards_imx imx
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			gallium_enable video_cards_intel i915
		fi

		gallium_enable video_cards_r300 r300
		gallium_enable video_cards_r600 r600
		gallium_enable video_cards_radeonsi radeonsi
		if ! use video_cards_r300 && \
			! use video_cards_r600; then
			gallium_enable video_cards_radeon r300 r600
		fi

		gallium_enable video_cards_freedreno freedreno
		# opencl stuff
		if use opencl; then
			emesonargs+=(
				-Dgallium-opencl="$(usex opencl standalone disabled)"
			)
		fi

		gallium_enable video_cards_virgl virgl
	fi

	if use vulkan; then
		vulkan_enable video_cards_i965 intel
		vulkan_enable video_cards_radeonsi amd
	fi

	# x86 hardened pax_kernel needs glx-rts, bug 240956
	if [[ ${ABI} == x86 ]]; then
		emesonargs+=( $(meson_use pax_kernel glx-read-only-text) )
	fi

	# on abi_x86_32 hardened we need to have asm disable
	if [[ ${ABI} == x86* ]] && use pic; then
		emesonargs+=( -Dasm=false )
	fi

	if use gallium; then
		gallium_enable -- swrast
		emesonargs+=( -Dosmesa=$(usex osmesa gallium none) )
	else
		dri_driver_enable -- swrast
		emesonargs+=( -Dosmesa=$(usex osmesa classic none) )
	fi

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	emesonargs+=(
		$(meson_use test build-tests)
		-Dglx=dri
		-Dshared-glapi=true
		$(meson_use dri3)
		$(meson_use egl)
		$(meson_use gbm)
		$(meson_use gles1)
		$(meson_use gles2)
		$(meson_use selinux)
		$(meson_use unwind libunwind)
		$(meson_use lm_sensors lmsensors)
		-Dvalgrind=$(usex valgrind auto false)
		-Ddri-drivers=$(driver_list "${DRI_DRIVERS[*]}")
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		--buildtype $(usex debug debug plain)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	if use opencl; then
		ebegin "Moving Gallium/Clover OpenCL implementation for dynamic switching"
		local cl_dir="/usr/$(get_libdir)/OpenCL/vendors/mesa"
		dodir ${cl_dir}/{lib,include}
		if [ -f "${ED}/usr/$(get_libdir)/libOpenCL.so" ]; then
			mv -f "${ED}"/usr/$(get_libdir)/libOpenCL.so* \
			"${ED}"${cl_dir}
		fi
		if [ -f "${ED}/usr/include/CL/opencl.h" ]; then
			mv -f "${ED}"/usr/include/CL \
			"${ED}"${cl_dir}/include
		fi
		eend $?
	fi

	if use openmax; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share/mesa/xdg\"" > "${T}/99mesaxdgomx"
		doenvd "${T}"/99mesaxdgomx
		keepdir /usr/share/mesa/xdg
	fi
}

multilib_src_install_all() {
	einstalldocs
}

multilib_src_test() {
	meson_src_test
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}

	# Switch to mesa opencl
	if use opencl; then
		eselect opencl set --use-old ${PN}
	fi

	# run omxregister-bellagio to make the OpenMAX drivers known system-wide
	if use openmax; then
		ebegin "Registering OpenMAX drivers"
		BELLAGIO_SEARCH_PATH="${EPREFIX}/usr/$(get_libdir)/libomxil-bellagio0" \
			OMX_BELLAGIO_REGISTRY=${EPREFIX}/usr/share/mesa/xdg/.omxregister \
			omxregister-bellagio
		eend $?
	fi
}

pkg_prerm() {
	if use openmax; then
		rm "${EPREFIX}"/usr/share/mesa/xdg/.omxregister
	fi
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
