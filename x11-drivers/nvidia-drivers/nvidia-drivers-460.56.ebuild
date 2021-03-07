# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic linux-info linux-mod multilib-minimal \
	nvidia-driver systemd toolchain-funcs unpacker udev

AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"
ARM64_NV_PACKAGE="NVIDIA-Linux-aarch64-${PV}"

NV_URI="https://us.download.nvidia.com/XFree86/"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}.run )
	tools? (
		https://download.nvidia.com/XFree86/nvidia-settings/nvidia-settings-${PV}.tar.bz2
	)"

EMULTILIB_PKG="true"

LICENSE="GPL-2 NVIDIA-r2"
SLOT="0/${PV%%.*}"
# TODO: for arm64, keyword virtual/opencl on arm64
KEYWORDS="-* ~amd64"
IUSE="compat +driver +kms multilib static-libs +tools uvm wayland +X"
REQUIRED_USE="
	tools? ( X )
	static-libs? ( tools )"

COMMON="
	driver? ( acct-group/video )
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		dev-libs/jansson
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXv
		x11-libs/libXxf86vm
		x11-libs/pango[X]
	)
	X? (
		app-misc/pax-utils
		media-libs/libglvnd[X,${MULTILIB_USEDEP}]
		>=x11-libs/libvdpau-1.0[${MULTILIB_USEDEP}]
	)"
DEPEND="
	${COMMON}
	virtual/linux-sources
	tools? ( sys-apps/dbus )"
RDEPEND="
	${COMMON}
	net-libs/libtirpc
	uvm? ( >=virtual/opencl-3 )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
	X? (
		<x11-base/xorg-server-1.20.99:=
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)"

QA_PREBUILT="opt/* usr/lib*"
S="${WORKDIR}"
NV_KV_MAX_PLUS="5.12"
CONFIG_CHECK="
	!DEBUG_MUTEXES
	~!I2C_NVIDIA_GPU
	~!LOCKDEP
	~DRM
	~DRM_KMS_HELPER
	~SYSVIPC"

PATCHES=( "${FILESDIR}"/${PN}-440.26-locale.patch )

pkg_pretend() {
	nvidia-driver_check
}

pkg_setup() {
	nvidia-driver_check

	# try to turn off distcc and ccache for people that have a problem with it
	export DISTCC_DISABLE=1
	export CCACHE_DISABLE=1

	if use driver; then
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
	fi
}

src_prepare() {
	gunzip *1.gz || die

	if use tools; then
		cp "${FILESDIR}"/nvidia-settings-linker.patch "${WORKDIR}" || die
		sed -i \
			-e "s:@PV@:${PV}:g" \
			"${WORKDIR}"/nvidia-settings-linker.patch \
			|| die
		eapply "${WORKDIR}"/nvidia-settings-linker.patch

		# remove GTK2 support entirely (#592730)
		sed -i \
			-e '/^GTK2LIB = /d;/INSTALL.*GTK2LIB/,+1d' \
			nvidia-settings-${PV}/src/Makefile || die
	fi

	default

	if ! [[ -f nvidia_icd.json ]]; then
		cp nvidia_icd.json.template nvidia_icd.json || die
		sed -i -e 's:__NV_VK_ICD__:libGLX_nvidia.so.0:g' nvidia_icd.json || die
	fi
}

src_configure() {
	tc-export AR CC LD OBJCOPY
	default
}

src_compile() {
	pushd kernel >/dev/null || die
	if use driver; then
		BUILD_TARGETS=module linux-mod_src_compile \
			KERNELRELEASE="${KV_FULL}" \
			src="${KERNEL_DIR}"
	fi
	popd >/dev/null || die

	if use tools; then
		emake -C nvidia-settings-${PV}/src/libXNVCtrl \
			DO_STRIP= \
			LIBDIR="$(get_libdir)" \
			NVLD="$(tc-getLD)" \
			NV_VERBOSE=1 \
			OUTPUTDIR=. \
			RANLIB="$(tc-getRANLIB)"

		emake -C nvidia-settings-${PV}/src \
			DO_STRIP= \
			GTK3_AVAILABLE=1 \
			LIBDIR="$(get_libdir)" \
			NVLD="$(tc-getLD)" \
			NVML_ENABLED=0 \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1 \
			OUTPUTDIR=.
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

	if [[ -n ${nv_DEST} ]]; then
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
	if [[ -n ${nv_SOVER} && ${nv_SOVER} != ${nv_LIBNAME} ]]; then
		dosym ${nv_LIBNAME} ${nv_DEST}/${nv_SOVER}
	fi

	dosym ${nv_LIBNAME} ${nv_DEST}/${nv_LIBNAME/.so*/.so}
}

src_install() {
	if use driver; then
		linux-mod_src_install

		# Add the aliases
		# This file is tweaked with the appropriate video group in
		# pkg_preinst, see bug #491414
		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-460.conf nvidia.conf

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
	fi

	# NVIDIA kernel <-> userspace driver config lib
	donvidia libnvidia-cfg.so.${PV}

	# NVIDIA framebuffer capture library
	donvidia libnvidia-fbc.so.${PV}

	# NVIDIA video encode/decode <-> CUDA
	donvidia libnvcuvid.so.${PV}
	donvidia libnvidia-encode.so.${PV}

	if use X; then
		# Xorg DDX driver
		exeinto /usr/$(get_libdir)/xorg/modules/drivers
		doexe nvidia_drv.so

		# Xorg GLX driver
		donvidia libglxserver_nvidia.so.${PV} \
			/usr/$(get_libdir)/xorg/modules/extensions

		# Xorg nvidia.conf
		insinto /usr/share/X11/xorg.conf.d
		newins {,50-}nvidia-drm-outputclass.conf

		insinto /usr/share/glvnd/egl_vendor.d
		doins 10_nvidia.json
	fi

	if use wayland; then
		insinto /usr/share/egl/egl_external_platform.d
		doins 10_nvidia_wayland.json
	fi

	insinto /etc/vulkan/icd.d
	doins nvidia_icd.json

	insinto /etc/vulkan/implicit_layer.d
	doins nvidia_layers.json

	# OpenCL ICD for NVIDIA
	insinto /etc/OpenCL/vendors
	doins nvidia.icd

	# Helper Apps
	exeinto /opt/bin/

	use X && doexe nvidia-xconfig

	doexe nvidia-cuda-mps-control
	doexe nvidia-cuda-mps-server
	doexe nvidia-debugdump
	doexe nvidia-persistenced
	doexe nvidia-smi

	# install nvidia-modprobe setuid and symlink in /usr/bin (bug #505092)
	doexe nvidia-modprobe
	fowners root:video /opt/bin/nvidia-modprobe
	fperms 4710 /opt/bin/nvidia-modprobe
	dosym ../../opt/bin/nvidia-modprobe /usr/bin/nvidia-modprobe

	doman nvidia-cuda-mps-control.1
	doman nvidia-modprobe.1
	doman nvidia-persistenced.1
	newinitd "${FILESDIR}/nvidia-smi.init" nvidia-smi
	newconfd "${FILESDIR}/nvidia-persistenced.conf" nvidia-persistenced
	newinitd "${FILESDIR}/nvidia-persistenced.init" nvidia-persistenced

	if use tools; then
		emake -C nvidia-settings-${PV}/src/ \
			DESTDIR="${ED}" \
			DO_STRIP= \
			GTK3_AVAILABLE=1 \
			LIBDIR="${ED}/usr/$(get_libdir)" \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1 \
			OUTPUTDIR=. \
			PREFIX=/usr \
			install

		if use static-libs; then
			dolib.a nvidia-settings-${PV}/src/libXNVCtrl/libXNVCtrl.a

			insinto /usr/include/NVCtrl
			doins nvidia-settings-${PV}/src/libXNVCtrl/*.h
		fi

		insinto /usr/share/nvidia/
		doins nvidia-application-profiles-${PV}-key-documentation

		insinto /etc/nvidia
		newins \
			nvidia-application-profiles-${PV}-rc nvidia-application-profiles-rc

		doicon nvidia-settings.png
		domenu "${FILESDIR}"/nvidia-settings.desktop

		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/95-nvidia-settings-r1 95-nvidia-settings
	fi

	dobin nvidia-bug-report.sh

	systemd_dounit *.service
	dobin nvidia-sleep.sh
	exeinto /lib/systemd/system-sleep
	doexe nvidia

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
	newdoc README.txt README
	dodoc NVIDIA_Changelog
	doman nvidia-smi.1
	use X && doman nvidia-xconfig.1
	use tools && doman nvidia-settings.1
	doman nvidia-cuda-mps-control.1

	readme.gentoo_create_doc

	dodoc -r supported-gpus

	docinto html
	dodoc -r html/.
}

src_install-libs() {
	local inslibdir=$(get_libdir)
	local GL_ROOT="/usr/$(get_libdir)"
	local CL_ROOT="/usr/$(get_libdir)/OpenCL/vendors/nvidia"
	local nv_libdir="${S}"

	if has_multilib_profile && [[ ${ABI} == "x86" ]]; then
		nv_libdir="${S}"/32
	fi

	if use X; then
		NV_GLX_LIBRARIES=(
			"libEGL_nvidia.so.${PV} ${GL_ROOT}"
			"libGLESv1_CM_nvidia.so.${PV} ${GL_ROOT}"
			"libGLESv2_nvidia.so.${PV} ${GL_ROOT}"
			"libGLX_nvidia.so.${PV} ${GL_ROOT}"
			"libOpenCL.so.1.0.0 ${CL_ROOT}"
			"libcuda.so.${PV}"
			"libnvcuvid.so.${PV}"
			"libnvidia-compiler.so.${PV}"
			"libnvidia-eglcore.so.${PV}"
			"libnvidia-encode.so.${PV}"
			"libnvidia-fbc.so.${PV}"
			"libnvidia-glcore.so.${PV}"
			"libnvidia-glsi.so.${PV}"
			"libnvidia-glvkspirv.so.${PV}"
			"libnvidia-ifr.so.${PV}"
			"libnvidia-opencl.so.${PV}"
			"libnvidia-ptxjitcompiler.so.${PV}"
			"libvdpau_nvidia.so.${PV}"
		)

		if use wayland && [[ ${ABI} == "amd64" ]]; then
			NV_GLX_LIBRARIES+=(
				"libnvidia-egl-wayland.so.1.1.5"
			)
		fi

		NV_GLX_LIBRARIES+=(
			"libnvidia-ml.so.${PV}"
			"libnvidia-tls.so.${PV}"
		)

		if [[ ${ABI} == "amd64" ]]; then
			NV_GLX_LIBRARIES+=(
				"libnvidia-cbl.so.${PV}"
				"libnvidia-ngx.so.${PV}"
				"libnvidia-rtcore.so.${PV}"
				"libnvoptix.so.${PV}"
			)
		fi

		local nv_lib
		for nv_lib in "${NV_GLX_LIBRARIES[@]}"; do
			donvidia "${nv_libdir}"/${nv_lib}
		done
	fi
}

pkg_preinst() {
	if use driver; then
		linux-mod_pkg_preinst

		local videogroup="$(getent group video | cut -d ':' -f 3)"
		if [[ -z ${videogroup} ]]; then
			eerror "Failed to determine the video group gid"
			die "Failed to determine the video group gid"
		else
			sed -i \
				-e "s:PACKAGE:${PF}:g" \
				-e "s:VIDEOGID:${videogroup}:" \
				"${ED}"/etc/modprobe.d/nvidia.conf || die
		fi
	fi

	# Clean the dynamic libGL stuff's home to ensure
	# we dont have stale libs floating around
	rm -rf "${EROOT}"/usr/lib/opengl/nvidia/* || die
	# Make sure we nuke the old nvidia-glx's env.d file
	rm -f "${EROOT}"/etc/env.d/09nvidia || die
}

pkg_postinst() {
	use driver && linux-mod_pkg_postinst

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

	elog "To enable nvidia sleep services under systemd, run these commands:"
	elog "	systemctl enable nvidia-suspend.service"
	elog "	systemctl enable nvidia-hibernate.service"
	elog "	systemctl enable nvidia-resume.service"
	elog "Set the NVreg_TemporaryFilePath kernel module parameter to a"
	elog "suitable path in case the default of /tmp does not work for you"
	elog "For more information see:"
	elog "${EROOT}/usr/share/doc/${PF}/html/powermanagement.html"
}

pkg_postrm() {
	use driver && linux-mod_pkg_postrm
}
