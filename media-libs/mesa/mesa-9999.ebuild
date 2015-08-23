# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

PYTHON_COMPAT=( python2_7 )

inherit autotools multilib-minimal python-any-r1 pax-utils ${GIT_ECLASS}

OPENGL_DIR="xorg-x11"

MY_P="${P/_/-}"
FOLDER="${PV/_rc*/}"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

if [[ $PV == 9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/${FOLDER}/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
RESTRICT="!bindist? ( bindist )"

INTEL_CARDS="i915 i965 ilo intel"
RADEON_CARDS="r100 r200 r300 r600 radeon radeonsi"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} freedreno nouveau vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	bindist +classic d3d9 debug +dri3 +egl +gallium +gbm gles1 gles2 +llvm
	+nptl opencl osmesa pax_kernel openmax pic selinux +udev vaapi vdpau
	wayland xvmc xa kernel_FreeBSD"

REQUIRED_USE="
	d3d9?   ( dri3 gallium )
	llvm?   ( gallium )
	opencl? ( gallium llvm )
	openmax? ( gallium )
	gles1?  ( egl )
	gles2?  ( egl )
	vaapi? ( gallium )
	vdpau? ( gallium )
	wayland? ( egl gbm )
	xa?  ( gallium )
	video_cards_freedreno?  ( gallium )
	video_cards_intel?  ( classic )
	video_cards_i915?   ( || ( classic gallium ) )
	video_cards_i965?   ( classic )
	video_cards_ilo?    ( gallium )
	video_cards_nouveau? ( || ( classic gallium ) )
	video_cards_radeon? ( || ( classic gallium ) )
	video_cards_r100?   ( classic )
	video_cards_r200?   ( classic )
	video_cards_r300?   ( gallium llvm )
	video_cards_r600?   ( gallium )
	video_cards_radeonsi?   ( gallium llvm )
	video_cards_vmware? ( gallium )
	${PYTHON_REQUIRED_USE}
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.64"
# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	!<x11-base/xorg-server-1.7
	!<=x11-proto/xf86driproto-2.0.3
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )
	classic? ( app-eselect/eselect-mesa )
	gallium? ( app-eselect/eselect-mesa )
	>=app-eselect/eselect-opengl-1.3.0
	udev? ( kernel_linux? ( >=virtual/libudev-215:=[${MULTILIB_USEDEP}] ) )
	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	gbm? ( >=virtual/libudev-215:=[${MULTILIB_USEDEP}] )
	dri3? ( >=virtual/libudev-215:=[${MULTILIB_USEDEP}] )
	>=x11-libs/libX11-1.6.2:=[${MULTILIB_USEDEP}]
	>=x11-libs/libxshmfence-1.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.4-r1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXxf86vm-1.1.3:=[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.9.3:=[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	llvm? (
		video_cards_radeonsi? ( || (
			>=dev-libs/elfutils-0.155-r1:=[${MULTILIB_USEDEP}]
			>=dev-libs/libelf-0.8.13-r2:=[${MULTILIB_USEDEP}]
			) )
		!video_cards_r600? (
			video_cards_radeon? ( || (
				>=dev-libs/elfutils-0.155-r1:=[${MULTILIB_USEDEP}]
				>=dev-libs/libelf-0.8.13-r2:=[${MULTILIB_USEDEP}]
				) )
		)
		>=sys-devel/llvm-3.4.2:=[${MULTILIB_USEDEP}]
	)
	opencl? (
				app-eselect/eselect-opencl
				dev-libs/libclc
				|| (
					>=dev-libs/elfutils-0.155-r1:=[${MULTILIB_USEDEP}]
					>=dev-libs/libelf-0.8.13-r2:=[${MULTILIB_USEDEP}]
				)
			)
	openmax? ( >=media-libs/libomxil-bellagio-0.9.3:=[${MULTILIB_USEDEP}] )
	vaapi? ( >=x11-libs/libva-0.35.0:=[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libvdpau-0.7:=[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.2.0:=[${MULTILIB_USEDEP}] )
	xvmc? ( >=x11-libs/libXvMC-1.0.8:=[${MULTILIB_USEDEP}] )
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_nouveau?,video_cards_vmware?,${MULTILIB_USEDEP}]
"
for card in ${INTEL_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	"
done

for card in ${RADEON_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done

DEPEND="${RDEPEND}
	llvm? (
		video_cards_radeonsi? ( sys-devel/llvm[video_cards_radeon] )
	)
	opencl? (
				>=sys-devel/llvm-3.4.2:=[${MULTILIB_USEDEP}]
				>=sys-devel/clang-3.4.2:=[${MULTILIB_USEDEP}]
				>=sys-devel/gcc-4.6
	)
	sys-devel/gettext
	virtual/pkgconfig
	>=x11-proto/dri2proto-2.8-r1:=[${MULTILIB_USEDEP}]
	dri3? (
		>=x11-proto/dri3proto-1.0:=[${MULTILIB_USEDEP}]
		>=x11-proto/presentproto-1.0:=[${MULTILIB_USEDEP}]
	)
	>=x11-proto/glproto-1.4.17-r1:=[${MULTILIB_USEDEP}]
	>=x11-proto/xextproto-7.2.1-r1:=[${MULTILIB_USEDEP}]
	>=x11-proto/xf86driproto-2.1.1-r1:=[${MULTILIB_USEDEP}]
	>=x11-proto/xf86vidmodeproto-2.3.1-r1:=[${MULTILIB_USEDEP}]
"
[[ ${PV} == "9999" ]] && DEPEND+="
	sys-devel/bison
	sys-devel/flex
	${PYTHON_DEPS}
	$(python_gen_any_dep ">=dev-python/mako-0.7.3[\${PYTHON_USEDEP}]")
"

S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR=${S}

# It is slow without texrels, if someone wants slow
# mesa without texrels +pic use is worth the shot
QA_EXECSTACK="usr/lib*/libGL.so*"
QA_WX_LOAD="usr/lib*/libGL.so*"

pkg_setup() {
	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	python-any-r1_pkg_setup
}

src_prepare() {
	# fix for hardened pax_kernel, bug 240956
	[[ ${PV} != 9999* ]] && epatch "${FILESDIR}"/glx_ro_text_segm.patch

	eautoreconf
}

multilib_src_configure() {
	local myconf

	if use classic; then
		# Configurable DRI drivers
		driver_enable swrast

		# Intel code
		driver_enable video_cards_i915 i915
		driver_enable video_cards_i965 i965
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			driver_enable video_cards_intel i915 i965
		fi

		# Nouveau code
		driver_enable video_cards_nouveau nouveau

		# ATI code
		driver_enable video_cards_r100 radeon
		driver_enable video_cards_r200 r200
		if ! use video_cards_r100 && \
				! use video_cards_r200; then
			driver_enable video_cards_radeon radeon r200
		fi
	fi

	if use egl; then
		myconf+="--with-egl-platforms=x11$(use wayland && echo ",wayland")$(use gbm && echo ",drm") "
	fi

	if use gallium; then
		myconf+="
			$(use_enable d3d9 nine)
			$(use_enable llvm gallium-llvm)
			$(use_enable openmax omx)
			$(use_enable vaapi va)
			$(use_enable vdpau)
			$(use_enable xa)
			$(use_enable xvmc)
		"
		gallium_enable swrast
		gallium_enable video_cards_vmware svga
		gallium_enable video_cards_nouveau nouveau
		gallium_enable video_cards_i915 i915
		gallium_enable video_cards_ilo ilo
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
			myconf+="
				$(use_enable opencl)
				--with-clang-libdir="${EPREFIX}/usr/lib"
				"
		fi
	fi

	# x86 hardened pax_kernel needs glx-rts, bug 240956
	if use pax_kernel; then
		myconf+="
			$(use_enable x86 glx-rts)
		"
	fi

	# on abi_x86_32 hardened we need to have asm disable
	if [[ ${ABI} == x86* ]] && use pic; then
		myconf+=" --disable-asm"
	fi

	# build fails with BSD indent, bug #428112
	use userland_GNU || export INDENT=cat

	ECONF_SOURCE="${S}" \
	econf \
		--enable-dri \
		--enable-glx \
		--enable-shared-glapi \
		--disable-shader-cache \
		$(use_enable !bindist texture-float) \
		$(use_enable d3d9 nine) \
		$(use_enable debug) \
		$(use_enable dri3) \
		$(use_enable egl) \
		$(use_enable gbm) \
		$(use_enable gles1) \
		$(use_enable gles2) \
		$(use_enable nptl glx-tls) \
		$(use_enable osmesa) \
		$(use_enable !udev sysfs) \
		--enable-llvm-shared-libs \
		--with-dri-drivers=${DRI_DRIVERS} \
		--with-gallium-drivers=${GALLIUM_DRIVERS} \
		PYTHON2="${PYTHON}" \
		${myconf}
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if use classic || use gallium; then
			ebegin "Moving DRI/Gallium drivers for dynamic switching"
			local gallium_drivers=( i915_dri.so i965_dri.so r300_dri.so r600_dri.so swrast_dri.so )
			keepdir /usr/$(get_libdir)/dri
			dodir /usr/$(get_libdir)/mesa
			for x in ${gallium_drivers[@]}; do
				if [ -f "$(get_libdir)/gallium/${x}" ]; then
					mv -f "${ED}/usr/$(get_libdir)/dri/${x}" "${ED}/usr/$(get_libdir)/dri/${x/_dri.so/g_dri.so}" \
						|| die "Failed to move ${x}"
				fi
			done
			if use classic; then
				emake -C "${BUILD_DIR}/src/mesa/drivers/dri" DESTDIR="${D}" install
			fi
			for x in "${ED}"/usr/$(get_libdir)/dri/*.so; do
				if [ -f ${x} -o -L ${x} ]; then
					mv -f "${x}" "${x/dri/mesa}" \
						|| die "Failed to move ${x}"
				fi
			done
			pushd "${ED}"/usr/$(get_libdir)/dri || die "pushd failed"
			ln -s ../mesa/*.so . || die "Creating symlink failed"
			# remove symlinks to drivers known to eselect
			for x in ${gallium_drivers[@]}; do
				if [ -f ${x} -o -L ${x} ]; then
					rm "${x}" || die "Failed to remove ${x}"
				fi
			done
			popd
		eend $?
	fi
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
	prune_libtool_files --all
	einstalldocs

	if use !bindist; then
		dodoc docs/patents.txt
	fi

	# Install config file for eselect mesa
	insinto /usr/share/mesa
	newins "${FILESDIR}/eselect-mesa.conf.9.2" eselect-mesa.conf
}

multilib_src_test() {
	if use llvm; then
		local llvm_tests='lp_test_arit lp_test_arit lp_test_blend lp_test_blend lp_test_conv lp_test_conv lp_test_format lp_test_format lp_test_printf lp_test_printf'
		pushd src/gallium/drivers/llvmpipe >/dev/null || die
		emake ${llvm_tests}
		pax-mark m ${llvm_tests}
		popd >/dev/null || die
	fi
	emake check
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}

	# Select classic/gallium drivers
	if use classic || use gallium; then
		eselect mesa set --auto
	fi

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

	# warn about patent encumbered texture-float
	if use !bindist; then
		elog "USE=\"bindist\" was not set. Potentially patent encumbered code was"
		elog "enabled. Please see patents.txt for an explanation."
	fi

	if ! has_version media-libs/libtxc_dxtn; then
		elog "Note that in order to have full S3TC support, it is necessary to install"
		elog "media-libs/libtxc_dxtn as well. This may be necessary to get nice"
		elog "textures in some apps, and some others even require this to run."
	fi
}

pkg_prerm() {
	if use openmax; then
		rm "${EPREFIX}"/usr/share/mesa/xdg/.omxregister
	fi
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
# TODO: avoid code duplication for a more elegant implementation
driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			DRI_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					DRI_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

gallium_enable() {
	case $# in
		# for enabling unconditionally
		1)
			GALLIUM_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					GALLIUM_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}
