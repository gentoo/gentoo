# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..20} )
LLVM_OPTIONAL=1
CARGO_OPTIONAL=1
PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic llvm-r1 meson-multilib python-any-r1 linux-info rust-toolchain

MY_P="${P/_/-}"

CRATES="
	syn@2.0.68
	proc-macro2@1.0.86
	quote@1.0.33
	unicode-ident@1.0.12
	paste@1.0.14
"

RUST_MIN_VER="1.78.0"
RUST_MULTILIB=1
RUST_OPTIONAL=1

inherit cargo

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	SRC_URI="
		https://archive.mesa3d.org/${MY_P}.tar.xz
	"
	KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

# This should be {CARGO_CRATE_URIS//.crate/.tar.gz} to correspond to the wrap files,
# but there are "stale" distfiles on the mirrors with the wrong names.
# export MESON_PACKAGE_CACHE_DIR="${DISTDIR}"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR=${S}

LICENSE="MIT SGI-B-2.0"
SLOT="0"

RADEON_CARDS="r300 r600 radeon radeonsi"
VIDEO_CARDS="${RADEON_CARDS}
	asahi d3d12 freedreno intel lavapipe lima nouveau nvk panfrost v3d vc4 virgl
	vivante vmware zink"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	cpu_flags_x86_sse2 d3d9 debug +llvm
	lm-sensors opencl +opengl +proprietary-codecs
	test unwind vaapi valgrind vdpau vulkan
	wayland +X xa +zstd"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	d3d9? (
		|| (
			video_cards_freedreno
			video_cards_intel
			video_cards_nouveau
			video_cards_panfrost
			video_cards_r300
			video_cards_r600
			video_cards_radeonsi
			video_cards_vmware
			video_cards_zink
		)
	)
	llvm? ( ${LLVM_REQUIRED_USE} )
	video_cards_lavapipe? ( llvm vulkan )
	video_cards_radeon? ( x86? ( llvm ) amd64? ( llvm ) )
	video_cards_r300?   ( x86? ( llvm ) amd64? ( llvm ) )
	video_cards_zink? ( vulkan opengl )
	video_cards_nvk? ( vulkan video_cards_nouveau )
	vdpau? ( X )
	xa? ( X )
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.121"
RDEPEND="
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-util/spirv-tools-1.3.231.0[${MULTILIB_USEDEP}]
	>=media-libs/libglvnd-1.3.2[X?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.9[${MULTILIB_USEDEP}]
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	llvm? (
		$(llvm_gen_dep "
			llvm-core/llvm:\${LLVM_SLOT}[llvm_targets_AMDGPU(+),${MULTILIB_USEDEP}]
			opencl? (
				dev-util/spirv-llvm-translator:\${LLVM_SLOT}
				llvm-core/clang:\${LLVM_SLOT}[llvm_targets_AMDGPU(+),${MULTILIB_USEDEP}]
				=llvm-core/libclc-\${LLVM_SLOT}*[spirv(-)]
			)
		")
		video_cards_r600? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		video_cards_radeon? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
	)
	lm-sensors? ( sys-apps/lm-sensors:=[${MULTILIB_USEDEP}] )
	opencl? (
		>=virtual/opencl-3
		llvm-core/libclc[spirv(-)]
		virtual/libelf:0=
	)
	vaapi? (
		>=media-libs/libva-1.7.3:=[${MULTILIB_USEDEP}]
	)
	vdpau? ( >=x11-libs/libvdpau-1.5:=[${MULTILIB_USEDEP}] )
	video_cards_radeonsi? ( virtual/libelf:0=[${MULTILIB_USEDEP}] )
	video_cards_zink? ( media-libs/vulkan-loader:=[${MULTILIB_USEDEP}] )
	vulkan? ( virtual/libudev:= )
	wayland? ( >=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}] )
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_intel?,video_cards_nouveau?,video_cards_vc4?,video_cards_vivante?,video_cards_vmware?,${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxshmfence-1.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.17:=[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-keysyms[${MULTILIB_USEDEP}]
	)
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

DEPEND="${RDEPEND}
	video_cards_d3d12? ( >=dev-util/directx-headers-1.614.1[${MULTILIB_USEDEP}] )
	valgrind? ( dev-debug/valgrind )
	wayland? ( >=dev-libs/wayland-protocols-1.41 )
	X? (
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-base/xorg-proto
	)
"

CLC_DEPSTRING="
	~dev-util/mesa_clc-${PV}[video_cards_asahi?,video_cards_panfrost?]
	llvm-core/libclc[spirv(-)]
"
BDEPEND="
	${PYTHON_DEPS}
	opencl? (
		>=dev-util/bindgen-0.71.0
		${RUST_DEPEND}
	)
	>=dev-build/meson-1.7.0
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	$(python_gen_any_dep "
		>=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]
		dev-python/packaging[\${PYTHON_USEDEP}]
		dev-python/pyyaml[\${PYTHON_USEDEP}]
	")
	video_cards_asahi? ( ${CLC_DEPSTRING} )
	video_cards_intel? ( ${CLC_DEPSTRING} )
	video_cards_panfrost? ( ${CLC_DEPSTRING} )
	vulkan? (
		dev-util/glslang
		video_cards_nvk? (
			>=dev-util/bindgen-0.71.0
			>=dev-util/cbindgen-0.26.0
			${RUST_DEPEND}
			${CLC_DEPSTRING}
		)
	)
	wayland? ( dev-util/wayland-scanner )
"

QA_WX_LOAD="
x86? (
	usr/lib/libgallium-*.so
	usr/lib/libGLX_mesa.so.0.0.0
)"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${MY_P}.tar.xz
	fi

	# We need this because we cannot tell meson to use DISTDIR yet
	pushd "${DISTDIR}" >/dev/null || die
	mkdir -p "${S}"/subprojects/packagecache || die
	local i
	for i in *.crate; do
		ln -s "${PWD}/${i}" "${S}/subprojects/packagecache/${i/.crate/}.tar.gz" || die
	done
	popd >/dev/null || die
}

pkg_pretend() {
	if use vulkan; then
		if ! use video_cards_asahi &&
		   ! use video_cards_d3d12 &&
		   ! use video_cards_freedreno &&
		   ! use video_cards_intel &&
		   ! use video_cards_lavapipe &&
		   ! use video_cards_nouveau &&
		   ! use video_cards_nvk &&
		   ! use video_cards_panfrost &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_v3d &&
		   ! use video_cards_virgl; then
			ewarn "Ignoring USE=vulkan     since VIDEO_CARDS does not contain asahi, d3d12, freedreno, intel, lavapipe, nouveau, nvk, panfrost, radeonsi, v3d, or virgl"
		fi
	fi

	# VA
	if use vaapi; then
		if ! use video_cards_d3d12 &&
		   ! use video_cards_nouveau &&
		   ! use video_cards_r600 &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_virgl; then
			ewarn "Ignoring USE=vaapi      since VIDEO_CARDS does not contain d3d12, nouveau, r600, radeonsi, or virgl"
		fi
	fi

	if use vdpau; then
		if ! use video_cards_d3d12 &&
		   ! use video_cards_nouveau &&
		   ! use video_cards_r600 &&
		   ! use video_cards_radeonsi &&
		   ! use video_cards_virgl; then
			ewarn "Ignoring USE=vdpau      since VIDEO_CARDS does not contain d3d12, nouveau, r600, radeonsi, or virgl"
		fi
	fi

	if use xa; then
		if ! use video_cards_freedreno &&
		   ! use video_cards_intel &&
		   ! use video_cards_nouveau &&
		   ! use video_cards_vmware; then
			ewarn "Ignoring USE=xa         since VIDEO_CARDS does not contain freedreno, intel, nouveau, or vmware"
		fi
	fi

	if ! use llvm; then
		use opencl     && ewarn "Ignoring USE=opencl     since USE does not contain llvm"
	fi
}

python_check_deps() {
	python_has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/packaging[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" || return 1
}

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version llvm-core/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and llvm-core/llvm"
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

	use llvm && llvm-r1_pkg_setup
	python-any-r1_pkg_setup

	if use opencl || (use vulkan && use video_cards_nvk); then
		rust_pkg_setup
	fi
}

src_prepare() {
	default
	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," \
		bin/symbols-check.py || die # bug #830728
}

multilib_src_configure() {
	local emesonargs=()

	# bug #932591 and https://gitlab.freedesktop.org/mesa/mesa/-/issues/11140
	filter-lto

	local platforms
	use X && platforms+="x11"
	use wayland && platforms+=",wayland"
	emesonargs+=(-Dplatforms=${platforms#,})

	if use video_cards_freedreno ||
	   use video_cards_intel || # crocus i915 iris
	   use video_cards_nouveau ||
	   use video_cards_panfrost ||
	   use video_cards_r300 ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_vmware || # svga
	   use video_cards_zink; then
		emesonargs+=($(meson_use d3d9 gallium-nine))
	else
		emesonargs+=(-Dgallium-nine=false)
	fi

	if use video_cards_d3d12 ||
	   use video_cards_nouveau ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_virgl; then
		emesonargs+=($(meson_feature vaapi gallium-va))
		use vaapi && emesonargs+=( -Dva-libs-path="${EPREFIX}"/usr/$(get_libdir)/va/drivers )
	else
		emesonargs+=(-Dgallium-va=disabled)
	fi

	if use video_cards_d3d12; then
		emesonargs+=($(meson_feature vaapi gallium-d3d12-video))
	fi

	if use video_cards_d3d12 ||
	   use video_cards_nouveau ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_virgl; then
		emesonargs+=($(meson_feature vdpau gallium-vdpau))
	else
		emesonargs+=(-Dgallium-vdpau=disabled)
	fi

	if use video_cards_freedreno ||
	   use video_cards_intel ||
	   use video_cards_nouveau ||
	   use video_cards_vmware; then
		emesonargs+=($(meson_feature xa gallium-xa))
	else
		emesonargs+=(-Dgallium-xa=disabled)
	fi

	gallium_enable !llvm softpipe
	gallium_enable llvm llvmpipe
	gallium_enable video_cards_asahi asahi
	gallium_enable video_cards_d3d12 d3d12
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
	gallium_enable video_cards_zink zink

	gallium_enable video_cards_r300 r300
	gallium_enable video_cards_r600 r600
	gallium_enable video_cards_radeonsi radeonsi
	if ! use video_cards_r300 &&
	   ! use video_cards_r600; then
		gallium_enable video_cards_radeon r300 r600
	fi

	if use llvm && use opencl; then
		PKG_CONFIG_PATH="$(get_llvm_prefix)/$(get_libdir)/pkgconfig"
		# See https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/docs/rusticl.rst
		emesonargs+=(
			$(meson_native_true gallium-rusticl)
			-Drust_std=2021
		)
	fi

	if use vulkan; then
		vulkan_enable video_cards_asahi asahi
		vulkan_enable video_cards_d3d12 microsoft-experimental
		vulkan_enable video_cards_freedreno freedreno
		vulkan_enable video_cards_intel intel intel_hasvk
		vulkan_enable video_cards_lavapipe swrast
		vulkan_enable video_cards_panfrost panfrost
		vulkan_enable video_cards_radeonsi amd
		vulkan_enable video_cards_v3d broadcom
		vulkan_enable video_cards_vc4 broadcom
		vulkan_enable video_cards_virgl virtio
		if use video_cards_nvk; then
			vulkan_enable video_cards_nvk nouveau
			if ! multilib_is_native_abi; then
				echo -e "[binaries]\nrust = ['rustc', '--target=$(rust_abi $CBUILD)']" > "${T}/rust_fix.ini"
				emesonargs+=(
					--native-file "${T}"/rust_fix.ini
				)
			fi
		fi

		emesonargs+=(-Dvulkan-layers=device-select,overlay)
	fi

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	if use opengl && use X; then
		emesonargs+=(-Dglx=dri)
	else
		emesonargs+=(-Dglx=disabled)
	fi

	if [[ "${ABI}" == amd64 ]]; then
		emesonargs+=($(meson_feature video_cards_intel intel-rt))
	fi

	if use video_cards_asahi ||
	   use video_cards_intel ||
	   use video_cards_nvk ||
	   use video_cards_panfrost; then
	   emesonargs+=(-Dmesa-clc=system)
	fi

	if use video_cards_asahi ||
	   use video_cards_panfrost; then
	    emesonargs+=(-Dprecomp-compiler=system)
	fi

	use debug && EMESON_BUILDTYPE=debug

	emesonargs+=(
		$(meson_use test build-tests)
		-Dlegacy-x11=dri2
		-Dexpat=enabled
		$(meson_use opengl)
		$(meson_feature opengl gbm)
		$(meson_feature opengl gles1)
		$(meson_feature opengl gles2)
		$(meson_feature opengl glvnd)
		$(meson_feature opengl egl)
		$(meson_feature llvm)
		$(meson_feature lm-sensors lmsensors)
		$(meson_feature unwind libunwind)
		$(meson_feature zstd)
		$(meson_use cpu_flags_x86_sse2 sse2)
		-Dvalgrind=$(usex valgrind auto disabled)
		-Dvideo-codecs=$(usex proprietary-codecs "all" "all_free")
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure

	if ! multilib_is_native_abi && use video_cards_nvk; then
		sed -i -E '{N; s/(rule rust_COMPILER_FOR_BUILD\n command = rustc) --target=[a-zA-Z0-9=:-]+ (.*) -C link-arg=-m[[:digit:]]+/\1 \2/g}' build.ninja || die
	fi
}

multilib_src_compile() {
	if [[ ${ABI} == x86 ]]; then
		# Bug 939803
		BINDGEN_EXTRA_CLANG_ARGS="-m32" meson_src_compile
	else
		meson_src_compile
	fi
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
