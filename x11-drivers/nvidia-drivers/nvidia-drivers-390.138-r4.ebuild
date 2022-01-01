# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop flag-o-matic linux-info linux-mod multilib-minimal \
	nvidia-driver portability toolchain-funcs unpacker udev

AMD64_FBSD_NV_PACKAGE="NVIDIA-FreeBSD-x86_64-${PV}"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"
ARM_NV_PACKAGE="NVIDIA-Linux-armv7l-gnueabihf-${PV}"
X86_FBSD_NV_PACKAGE="NVIDIA-FreeBSD-x86-${PV}"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"

NV_URI="https://us.download.nvidia.com/XFree86/"
SRC_URI="
	amd64-fbsd? ( ${NV_URI}FreeBSD-x86_64/${PV}/${AMD64_FBSD_NV_PACKAGE}.tar.gz )
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}.run )
	arm? ( ${NV_URI}Linux-x86-ARM/${PV}/${ARM_NV_PACKAGE}.run )
	x86-fbsd? ( ${NV_URI}FreeBSD-x86/${PV}/${X86_FBSD_NV_PACKAGE}.tar.gz )
	x86? ( ${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run )
	tools? (
		https://download.nvidia.com/XFree86/nvidia-settings/nvidia-settings-${PV}.tar.bz2
	)
"

EMULTILIB_PKG="true"
KEYWORDS="-* amd64 x86"
LICENSE="GPL-2 NVIDIA-r2"
SLOT="0/${PV%%.*}"

IUSE="compat +driver gtk3 kernel_FreeBSD kernel_linux +kms +libglvnd multilib static-libs +tools uvm wayland +X"
REQUIRED_USE="
	tools? ( X )
	static-libs? ( tools )
"

COMMON="
	driver? ( kernel_linux? ( acct-group/video ) )
	kernel_linux? ( >=sys-libs/glibc-2.6.1 )
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		dev-libs/jansson
		gtk3? (
			x11-libs/gtk+:3
		)
		x11-libs/cairo
		x11-libs/gdk-pixbuf[X]
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXv
		x11-libs/libXxf86vm
		x11-libs/pango[X]
	)
	X? (
		!libglvnd? ( >=app-eselect/eselect-opengl-1.0.9 )
		libglvnd? (
			media-libs/libglvnd[${MULTILIB_USEDEP}]
			!app-eselect/eselect-opengl
		)
		app-misc/pax-utils
	)
"
DEPEND="
	${COMMON}
	kernel_linux? ( virtual/linux-sources )
	tools? ( sys-apps/dbus )
"
RDEPEND="
	${COMMON}
	tools? ( !media-video/nvidia-settings )
	uvm? ( >=virtual/opencl-3 )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
	X? (
		<x11-base/xorg-server-1.20.99:=
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libvdpau-1.0[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
QA_PREBUILT="opt/* usr/lib*"
S=${WORKDIR}/
NV_KV_MAX_PLUS="5.8"
CONFIG_CHECK="
	!DEBUG_MUTEXES
	~!I2C_NVIDIA_GPU
	~!LOCKDEP
	~DRM
	~DRM_KMS_HELPER
	~SYSVIPC
"

pkg_pretend() {
	use x86 && CONFIG_CHECK+=" ~HIGHMEM"
	nvidia-driver_check
}

pkg_setup() {
	use x86 && CONFIG_CHECK+=" ~HIGHMEM"
	nvidia-driver_check

	# try to turn off distcc and ccache for people that have a problem with it
	export DISTCC_DISABLE=1
	export CCACHE_DISABLE=1

	if use driver && use kernel_linux; then
		MODULE_NAMES="nvidia(video:${S}/kernel)"
		use uvm && MODULE_NAMES+=" nvidia-uvm(video:${S}/kernel)"
		use kms && MODULE_NAMES+=" nvidia-modeset(video:${S}/kernel) nvidia-drm(video:${S}/kernel)"

		# This needs to run after MODULE_NAMES (so that the eclass checks
		# whether the kernel supports loadable modules) but before BUILD_PARAMS
		# is set (so that KV_DIR is populated).
		linux-mod_pkg_setup

		BUILD_PARAMS="IGNORE_CC_MISMATCH=yes V=1 SYSSRC=${KV_DIR} \
		SYSOUT=${KV_OUT_DIR} CC=$(tc-getBUILD_CC) NV_VERBOSE=1"

		# linux-mod_src_compile calls set_arch_to_kernel, which
		# sets the ARCH to x86 but NVIDIA's wrapping Makefile
		# expects x86_64 or i386 and then converts it to x86
		# later on in the build process
		BUILD_FIXES="ARCH=$(uname -m | sed -e 's/i.86/i386/')"

		if kernel_is lt 2 6 9; then
			eerror "You must build this against 2.6.9 or higher kernels."
		fi
	fi

	# set variables to where files are in the package structure
	if use kernel_FreeBSD; then
		use x86-fbsd   && S="${WORKDIR}/${X86_FBSD_NV_PACKAGE}"
		use amd64-fbsd && S="${WORKDIR}/${AMD64_FBSD_NV_PACKAGE}"
		NV_DOC="${S}/doc"
		NV_OBJ="${S}/obj"
		NV_SRC="${S}/src"
		NV_MAN="${S}/x11/man"
		NV_X11="${S}/obj"
		NV_SOVER=1
	elif use kernel_linux; then
		NV_DOC="${S}"
		NV_OBJ="${S}"
		NV_SRC="${S}/kernel"
		NV_MAN="${S}"
		NV_X11="${S}"
		NV_SOVER=${PV}
	else
		die "Could not determine proper NVIDIA package"
	fi
}

src_prepare() {
	local man_file
	for man_file in "${NV_MAN}"/*1.gz; do
		gunzip $man_file || die
	done

	if use tools; then
		cp "${FILESDIR}"/nvidia-settings-fno-common.patch "${WORKDIR}" || die
		cp "${FILESDIR}"/nvidia-settings-linker.patch "${WORKDIR}" || die
		sed -i \
			-e "s:@PV@:${PV}:g" \
			"${WORKDIR}"/nvidia-settings-fno-common.patch \
			"${WORKDIR}"/nvidia-settings-linker.patch \
			|| die
		eapply "${WORKDIR}"/nvidia-settings-fno-common.patch
		eapply "${WORKDIR}"/nvidia-settings-linker.patch
	fi

	default

	if ! [ -f nvidia_icd.json ]; then
		cp nvidia_icd.json.template nvidia_icd.json || die
		sed -i -e 's:__NV_VK_ICD__:libGLX_nvidia.so.0:g' nvidia_icd.json || die
	fi

	sed "s:%LIBDIR%:$(get_libdir):g" "${FILESDIR}/nvidia-390.conf" \
		> "${T}/nvidia-390.conf" || die
}

src_compile() {
	# This is already the default on Linux, as there's no toplevel Makefile, but
	# on FreeBSD there's one and triggers the kernel module build, as we install
	# it by itself, pass this.

	cd "${NV_SRC}"
	if use kernel_FreeBSD; then
		MAKE="$(get_bmake)" CFLAGS="-Wno-sign-compare" emake CC="$(tc-getCC)" \
			LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)" || die
	elif use driver && use kernel_linux; then
		BUILD_TARGETS=module linux-mod_src_compile \
			KERNELRELEASE="${KV_FULL}" \
			src="${KERNEL_DIR}"
	fi

	if use tools; then
		emake -C "${S}"/nvidia-settings-${PV}/src \
			AR="$(tc-getAR)" \
			CC="$(tc-getCC)" \
			DO_STRIP= \
			LD="$(tc-getCC)" \
			LIBDIR="$(get_libdir)" \
			NVLD="$(tc-getLD)" \
			NV_VERBOSE=1 \
			RANLIB="$(tc-getRANLIB)" \
			build-xnvctrl

		emake -C "${S}"/nvidia-settings-${PV}/src \
			CC="$(tc-getCC)" \
			OBJCOPY="$(tc-getOBJCOPY)" \
			DO_STRIP= \
			GTK3_AVAILABLE=$(usex gtk3 1 0) \
			LD="$(tc-getCC)" \
			LIBDIR="$(get_libdir)" \
			NVLD="$(tc-getLD)" \
			NVML_ENABLED=0 \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1
	fi
}

# Install nvidia library:
# the first parameter is the library to install
# the second parameter is the provided soversion
# the third parameter is the target directory if it is not /usr/lib
donvidia() {
	# Full path to library
	nv_LIB="${1}"

	# SOVER to use
	nv_SOVER="$(scanelf -qF'%S#F' ${nv_LIB})"

	# Where to install
	nv_DEST="${2}"

	# Get just the library name
	nv_LIBNAME=$(basename "${nv_LIB}")

	if [[ "${nv_DEST}" ]]; then
		exeinto ${nv_DEST}
		action="doexe"
	else
		nv_DEST="/usr/$(get_libdir)"
		action="dolib.so"
	fi

	# Install the library
	${action} ${nv_LIB} || die "failed to install ${nv_LIBNAME}"

	# If the library has a SONAME and SONAME does not match the library name,
	# then we need to create a symlink
	if [[ ${nv_SOVER} ]] && ! [[ "${nv_SOVER}" = "${nv_LIBNAME}" ]]; then
		dosym ${nv_LIBNAME} ${nv_DEST}/${nv_SOVER}
	fi

	dosym ${nv_LIBNAME} ${nv_DEST}/${nv_LIBNAME/.so*/.so}
}

src_install() {
	if use driver && use kernel_linux; then
		linux-mod_src_install

		# Add the aliases
		# This file is tweaked with the appropriate video group in
		# pkg_preinst, see bug #491414
		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-169.07 nvidia.conf
		if use uvm; then
			doins "${FILESDIR}"/nvidia-rmmod.conf
			udev_newrules "${FILESDIR}"/nvidia-uvm.udev-rule 99-nvidia-uvm.rules
		else
			sed -e 's|nvidia-uvm ||g' "${FILESDIR}"/nvidia-rmmod.conf \
				> "${T}"/nvidia-rmmod.conf || die
			doins "${T}"/nvidia-rmmod.conf
		fi

		# Ensures that our device nodes are created when not using X
		exeinto "$(get_udevdir)"
		newexe "${FILESDIR}"/nvidia-udev.sh-r1 nvidia-udev.sh
		udev_newrules "${FILESDIR}"/nvidia.udev-rule 99-nvidia.rules
	elif use kernel_FreeBSD; then
		if use x86-fbsd; then
			insinto /boot/modules
			doins "${S}/src/nvidia.kld"
		fi

		exeinto /boot/modules
		doexe "${S}/src/nvidia.ko"
	fi

	# NVIDIA kernel <-> userspace driver config lib
	donvidia ${NV_OBJ}/libnvidia-cfg.so.${NV_SOVER}

	# NVIDIA framebuffer capture library
	donvidia ${NV_OBJ}/libnvidia-fbc.so.${NV_SOVER}

	# NVIDIA video encode/decode <-> CUDA
	if use kernel_linux; then
		donvidia ${NV_OBJ}/libnvcuvid.so.${NV_SOVER}
		donvidia ${NV_OBJ}/libnvidia-encode.so.${NV_SOVER}
	fi

	if use X; then
		# Xorg DDX driver
		insinto /usr/$(get_libdir)/xorg/modules/drivers
		doins ${NV_X11}/nvidia_drv.so

		# Xorg GLX driver
		if use libglvnd; then
			local extensions_dir="/usr/$(get_libdir)/extensions/nvidia"
		else
			local extensions_dir="/usr/$(get_libdir)/opengl/nvidia/extensions/"
		fi
		donvidia ${NV_X11}/libglx.so.${NV_SOVER} \
			"${extensions_dir}"

		# Xorg nvidia.conf
		if has_version '>=x11-base/xorg-server-1.16'; then
			insinto /usr/share/X11/xorg.conf.d
			newins {,50-}nvidia-drm-outputclass.conf
		fi

		insinto /usr/share/glvnd/egl_vendor.d
		doins ${NV_X11}/10_nvidia.json
	fi

	if use wayland; then
		insinto /usr/share/egl/egl_external_platform.d
		doins ${NV_X11}/10_nvidia_wayland.json
	fi

	# OpenCL ICD for NVIDIA
	if use kernel_linux; then
		insinto /etc/OpenCL/vendors
		doins ${NV_OBJ}/nvidia.icd
	fi

	# Helper Apps
	exeinto /opt/bin/

	if use X; then
		doexe ${NV_OBJ}/nvidia-xconfig

		insinto /etc/vulkan/icd.d
		doins nvidia_icd.json

		insinto /etc/X11/xorg.conf.d
		doins ${T}/nvidia-390.conf
	fi

	if use kernel_linux; then
		doexe ${NV_OBJ}/nvidia-cuda-mps-control
		doexe ${NV_OBJ}/nvidia-cuda-mps-server
		doexe ${NV_OBJ}/nvidia-debugdump
		doexe ${NV_OBJ}/nvidia-persistenced
		doexe ${NV_OBJ}/nvidia-smi

		# install nvidia-modprobe setuid and symlink in /usr/bin (bug #505092)
		doexe ${NV_OBJ}/nvidia-modprobe
		fowners root:video /opt/bin/nvidia-modprobe
		fperms 4710 /opt/bin/nvidia-modprobe
		dosym /{opt,usr}/bin/nvidia-modprobe

		doman nvidia-cuda-mps-control.1
		doman nvidia-modprobe.1
		doman nvidia-persistenced.1
		newinitd "${FILESDIR}/nvidia-smi.init" nvidia-smi
		newconfd "${FILESDIR}/nvidia-persistenced.conf" nvidia-persistenced
		newinitd "${FILESDIR}/nvidia-persistenced.init" nvidia-persistenced
	fi

	if use tools; then
		emake -C "${S}"/nvidia-settings-${PV}/src/ \
			DESTDIR="${D}" \
			GTK3_AVAILABLE=$(usex gtk3 1 0) \
			LIBDIR="${D}/usr/$(get_libdir)" \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1 \
			PREFIX=/usr \
			DO_STRIP= \
			install

		if use static-libs; then
			dolib.a "${S}"/nvidia-settings-${PV}/src/libXNVCtrl/libXNVCtrl.a

			insinto /usr/include/NVCtrl
			doins "${S}"/nvidia-settings-${PV}/src/libXNVCtrl/*.h
		fi

		insinto /usr/share/nvidia/
		doins nvidia-application-profiles-${PV}-key-documentation

		insinto /etc/nvidia
		newins \
			nvidia-application-profiles-${PV}-rc nvidia-application-profiles-rc

		# There is no icon in the FreeBSD tarball.
		use kernel_FreeBSD || \
			doicon ${NV_OBJ}/nvidia-settings.png

		domenu "${FILESDIR}"/nvidia-settings.desktop

		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/95-nvidia-settings-r1 95-nvidia-settings
	fi

	dobin ${NV_OBJ}/nvidia-bug-report.sh

	if has_multilib_profile && use multilib; then
		local OABI=${ABI}
		for ABI in $(multilib_get_enabled_abis); do
			src_install-libs
		done
		ABI=${OABI}
		unset OABI
	else
		src_install-libs
	fi

	is_final_abi || die "failed to iterate through all ABIs"

	# Documentation
	if use kernel_FreeBSD; then
		dodoc "${NV_DOC}/README"
		use X && doman "${NV_MAN}"/nvidia-xconfig.1
		use tools && doman "${NV_MAN}"/nvidia-settings.1
	else
		# Docs
		newdoc "${NV_DOC}/README.txt" README
		dodoc "${NV_DOC}/NVIDIA_Changelog"
		doman "${NV_MAN}"/nvidia-smi.1
		use X && doman "${NV_MAN}"/nvidia-xconfig.1
		use tools && doman "${NV_MAN}"/nvidia-settings.1
		doman "${NV_MAN}"/nvidia-cuda-mps-control.1
	fi

	readme.gentoo_create_doc

	docinto html
	dodoc -r ${NV_DOC}/html/*
}

src_install-libs() {
	local inslibdir=$(get_libdir)
	if use libglvnd; then
		local GL_ROOT="/usr/$(get_libdir)"
	else
		local GL_ROOT="/usr/$(get_libdir)/opengl/nvidia/lib"
	fi
	local CL_ROOT="/usr/$(get_libdir)/OpenCL/vendors/nvidia"
	local nv_libdir="${NV_OBJ}"

	if use kernel_linux && has_multilib_profile && [[ ${ABI} == "x86" ]]; then
		nv_libdir="${NV_OBJ}"/32
	fi

	if use X; then
		NV_GLX_LIBRARIES=(
			"libEGL_nvidia.so.${NV_SOVER} ${GL_ROOT}"
			"libGLESv1_CM_nvidia.so.${NV_SOVER} ${GL_ROOT}"
			"libGLESv2_nvidia.so.${NV_SOVER} ${GL_ROOT}"
			"libGLX_nvidia.so.${NV_SOVER} ${GL_ROOT}"
			"libOpenCL.so.1.0.0 ${CL_ROOT}"
			"libcuda.so.${NV_SOVER}"
			"libnvcuvid.so.${NV_SOVER}"
			"libnvidia-compiler.so.${NV_SOVER}"
			"libnvidia-eglcore.so.${NV_SOVER}"
			"libnvidia-encode.so.${NV_SOVER}"
			"libnvidia-fatbinaryloader.so.${NV_SOVER}"
			"libnvidia-fbc.so.${NV_SOVER}"
			"libnvidia-glcore.so.${NV_SOVER}"
			"libnvidia-glsi.so.${NV_SOVER}"
			"libnvidia-ifr.so.${NV_SOVER}"
			"libnvidia-opencl.so.${NV_SOVER}"
			"libnvidia-ptxjitcompiler.so.${NV_SOVER}"
			"libvdpau_nvidia.so.${NV_SOVER}"
		)
		if ! use libglvnd; then
			NV_GLX_LIBRARIES+=(
				"libEGL.so.$(usex compat ${NV_SOVER} 1.1.0) ${GL_ROOT}"
				"libGL.so.$(usex compat ${NV_SOVER} 1.7.0) ${GL_ROOT}"
				"libGLESv1_CM.so.1.2.0 ${GL_ROOT}"
				"libGLESv2.so.2.1.0 ${GL_ROOT}"
				"libGLX.so.0 ${GL_ROOT}"
				"libGLdispatch.so.0 ${GL_ROOT}"
				"libOpenGL.so.0 ${GL_ROOT}"
			)
		fi

		if use wayland && [[ ${ABI} == "amd64" ]];
		then
			NV_GLX_LIBRARIES+=(
				"libnvidia-egl-wayland.so.1.0.2"
			)
		fi

		if use kernel_linux && [[ ${ABI} == "amd64" ]];
		then
			NV_GLX_LIBRARIES+=(
				"libnvidia-wfb.so.${NV_SOVER}"
			)
		fi

		if use kernel_FreeBSD; then
			NV_GLX_LIBRARIES+=(
				"libnvidia-tls.so.${NV_SOVER}"
			)
		fi

		if use kernel_linux; then
			NV_GLX_LIBRARIES+=(
				"libnvidia-ml.so.${NV_SOVER}"
				"tls/libnvidia-tls.so.${NV_SOVER}"
			)
		fi

		for NV_LIB in "${NV_GLX_LIBRARIES[@]}"; do
			donvidia "${nv_libdir}"/${NV_LIB}
		done
	fi
}

pkg_preinst() {
	if use driver && use kernel_linux; then
		linux-mod_pkg_preinst

		local videogroup="$(getent group video | cut -d ':' -f 3)"
		if [ -z "${videogroup}" ]; then
			eerror "Failed to determine the video group gid"
			die "Failed to determine the video group gid"
		else
			sed -i \
				-e "s:PACKAGE:${PF}:g" \
				-e "s:VIDEOGID:${videogroup}:" \
				"${D}"/etc/modprobe.d/nvidia.conf || die
		fi
	fi

	# Clean the dynamic libGL stuff's home to ensure
	# we dont have stale libs floating around
	if [ -d "${ROOT}"/usr/lib/opengl/nvidia ]; then
		rm -rf "${ROOT}"/usr/lib/opengl/nvidia/*
	fi
	# Make sure we nuke the old nvidia-glx's env.d file
	if [ -e "${ROOT}"/etc/env.d/09nvidia ]; then
		rm -f "${ROOT}"/etc/env.d/09nvidia
	fi
}

pkg_postinst() {
	use driver && use kernel_linux && linux-mod_pkg_postinst

	# Switch to the nvidia implementation
	if ! use libglvnd; then
		use X && "${ROOT}"/usr/bin/eselect opengl set --use-old nvidia
	fi

	readme.gentoo_print_elog

	if ! use X; then
		elog "You have elected to not install the X.org driver. Along with"
		elog "this the OpenGL libraries and VDPAU libraries were not"
		elog "installed. Additionally, once the driver is loaded your card"
		elog "and fan will run at max speed which may not be desirable."
		elog "Use the 'nvidia-smi' init script to have your card and fan"
		elog "speed scale appropriately."
		elog
	fi
	if ! use tools; then
		elog "USE=tools controls whether the nvidia-settings application"
		elog "is installed. If you would like to use it, enable that"
		elog "flag and re-emerge this ebuild. Optionally you can install"
		elog "media-video/nvidia-settings"
		elog
	fi
}

pkg_prerm() {
	if ! use libglvnd; then
		use X && "${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
	fi
}

pkg_postrm() {
	use driver && use kernel_linux && linux-mod_pkg_postrm
	if ! use libglvnd; then
		use X && "${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
	fi
}
