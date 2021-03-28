# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE="driver"
inherit desktop linux-info linux-mod multilib-build \
	optfeature systemd toolchain-funcs unpacker

NV_KERNEL_MAX="5.10"
NV_BIN_URI="https://download.nvidia.com/XFree86/Linux-"
NV_GIT_URI="https://github.com/NVIDIA/nvidia-"

DESCRIPTION="NVIDIA Accelerated Graphics Driver"
HOMEPAGE="https://www.nvidia.com/download/index.aspx"
SRC_URI="
	amd64? ( ${NV_BIN_URI}x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )
	x86? ( ${NV_BIN_URI}x86/${PV}/NVIDIA-Linux-x86-${PV}.run )
	${NV_GIT_URI}installer/archive/${PV}.tar.gz -> nvidia-installer-${PV}.tar.gz
	${NV_GIT_URI}modprobe/archive/${PV}.tar.gz -> nvidia-modprobe-${PV}.tar.gz
	${NV_GIT_URI}persistenced/archive/${PV}.tar.gz -> nvidia-persistenced-${PV}.tar.gz
	${NV_GIT_URI}settings/archive/${PV}.tar.gz -> nvidia-settings-${PV}.tar.gz
	${NV_GIT_URI}xconfig/archive/${PV}.tar.gz -> nvidia-xconfig-${PV}.tar.gz"
# nvidia-installer is unused but here for GPL-2's "distribute sources"
S="${WORKDIR}"

LICENSE="GPL-2 MIT NVIDIA-r2"
SLOT="0/${PV%%.*}"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+X +driver static-libs +tools"

COMMON_DEPEND="
	acct-group/video
	acct-user/nvpd
	net-libs/libtirpc
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		dev-libs/jansson
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/pango
	)"
RDEPEND="
	${COMMON_DEPEND}
	X? (
		media-libs/libglvnd[X,${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)"
DEPEND="
	${COMMON_DEPEND}
	static-libs? (
		x11-libs/libX11
		x11-libs/libXext
	)
	tools? (
		media-libs/libglvnd
		sys-apps/dbus
		x11-base/xorg-proto
		x11-libs/libXrandr
		x11-libs/libXv
		x11-libs/libvdpau
	)"
BDEPEND="
	app-misc/pax-utils
	virtual/pkgconfig"

QA_PREBUILT="opt/* usr/lib*"

PATCHES=(
	"${FILESDIR}"/nvidia-modprobe-390.141-uvm-perms.patch
	"${FILESDIR}"/nvidia-settings-390.141-fno-common.patch
)
DOCS=(
	README.txt NVIDIA_Changelog
	nvidia-settings/doc/{FRAMELOCK,NV-CONTROL-API}.txt
)
HTML_DOCS=( html/. )

pkg_setup() {
	use driver || return

	local CONFIG_CHECK="
		~DRM_KMS_HELPER
		~SYSVIPC
		~!AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
		~!LOCKDEP
		!DEBUG_MUTEXES"
	local ERROR_DRM_KMS_HELPER="CONFIG_DRM_KMS_HELPER: is not set but needed for Xorg auto-detection
	of drivers (no custom config), and optional nvidia-drm.modeset=1.
	Cannot be directly selected in the kernel's menuconfig, so enable
	options such as CONFIG_DRM_FBDEV_EMULATION instead.
	390.xx branch: also used by a GLX workaround needed for OpenGL."

	BUILD_PARAMS='NV_VERBOSE=1 IGNORE_CC_MISMATCH=yes SYSSRC="${KV_DIR}" SYSOUT="${KV_OUT_DIR}"'
	use x86 && BUILD_PARAMS+=' ARCH=i386' # needed for recognition
	BUILD_TARGETS="modules" # defaults' clean sometimes deletes modules
	MODULE_NAMES="
		nvidia(video:kernel)
		nvidia-drm(video:kernel)
		nvidia-modeset(video:kernel)"
	use amd64 && MODULE_NAMES+=" nvidia-uvm(video:kernel)" # no x86 support

	linux-mod_pkg_setup

	if [[ ${MERGE_TYPE} != binary ]] && kernel_is -gt ${NV_KERNEL_MAX/./ }; then
		ewarn "Kernel ${KV_MAJOR}.${KV_MINOR} is either known to break this version of nvidia-drivers"
		ewarn "or was not tested with it. It is recommended to use one of:"
		ewarn "  <=sys-kernel/gentoo-kernel-${NV_KERNEL_MAX}"
		ewarn "  <=sys-kernel/gentoo-sources-${NV_KERNEL_MAX}"
		ewarn "You are free to try or use /etc/portage/patches, but support will"
		ewarn "not be given and issues wait until NVIDIA releases a fixed version."
		ewarn
		ewarn "Do _not_ file a bug report if run into issues."
		ewarn
	fi
}

src_prepare() {
	# make user patches usable across versions
	rm nvidia-modprobe && mv nvidia-modprobe{-${PV},} || die
	rm nvidia-persistenced && mv nvidia-persistenced{-${PV},} || die
	rm nvidia-settings && mv nvidia-settings{-${PV},} || die
	rm nvidia-xconfig && mv nvidia-xconfig{-${PV},} || die

	default

	# prevent detection of incomplete kernel DRM support (bug #603818)
	sed 's/defined(CONFIG_DRM)/defined(CONFIG_DRM_KMS_HELPER)/' \
		-i kernel/conftest.sh || die

	sed -e '/Exec=\|Icon=/s/_.*/nvidia-settings/' \
		-e '/Categories=/s/_.*/System;Settings;/' \
		-i nvidia-settings/doc/nvidia-settings.desktop || die

	# remove gtk2 support (bug #592730)
	sed '/^GTK2LIB = /d;/INSTALL.*GTK2LIB/,+1d' \
		-i nvidia-settings/src/Makefile || die

	sed 's/__USER__/nvpd/' \
		nvidia-persistenced/init/systemd/nvidia-persistenced.service.template \
		> nvidia-persistenced.service || die

	sed 's/__NV_VK_ICD__/libGLX_nvidia.so.0/' \
		nvidia_icd.json.template > nvidia_icd.json || die

	sed "s/%LIBDIR%/$(get_libdir)/g" "${FILESDIR}/nvidia-390.conf" \
		> nvidia-drm-outputclass.conf || die

	gzip -d nvidia-{cuda-mps-control,smi}.1.gz || die
}

src_compile() {
	nvidia-drivers_make() {
		emake -C nvidia-${1} ${2} \
			PREFIX="${EPREFIX}/usr" \
			HOST_CC="$(tc-getBUILD_CC)" \
			HOST_LD="$(tc-getBUILD_LD)" \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1 DO_STRIP= OUTPUTDIR=out
	}

	tc-export AR CC LD OBJCOPY

	# may no longer be relevant but kept as a safety
	export DISTCC_DISABLE=1 CCACHE_DISABLE=1

	use driver && linux-mod_src_compile

	# 390.xx persistenced doesn't auto-detect libtirpc
	LIBS=$($(tc-getPKG_CONFIG) --libs libtirpc) \
		common_cflags=$($(tc-getPKG_CONFIG) --cflags libtirpc) \
		nvidia-drivers_make persistenced

	nvidia-drivers_make modprobe
	use X && nvidia-drivers_make xconfig

	if use tools; then
		nvidia-drivers_make settings
	elif use static-libs; then
		nvidia-drivers_make settings/src build-xnvctrl
	fi
}

src_install() {
	nvidia-drivers_make_install() {
		emake -C nvidia-${1} install \
			DESTDIR="${D}" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${ED}/usr/$(get_libdir)" \
			NV_USE_BUNDLED_LIBJANSSON=0 \
			NV_VERBOSE=1 DO_STRIP= MANPAGE_GZIP= OUTPUTDIR=out
	}

	nvidia-drivers_libs_install() {
		local libs=(
			EGL_nvidia
			GLESv1_CM_nvidia
			GLESv2_nvidia
			cuda
			nvcuvid
			nvidia-compiler
			nvidia-eglcore
			nvidia-encode
			nvidia-fatbinaryloader
			nvidia-glcore
			nvidia-glsi
			nvidia-ml
			nvidia-opencl
			nvidia-ptxjitcompiler
			nvidia-tls
		)

		if use X; then
			libs+=(
				GLX_nvidia
				nvidia-fbc
				nvidia-ifr
				vdpau_nvidia
			)
		fi

		local libdir=.
		if [[ -d 32 && ${ABI} == x86 ]]; then
			libdir+=/32
		else
			libs+=(
				nvidia-cfg
				nvidia-wfb
			)
		fi

		local lib soname
		for lib in "${libs[@]}"; do
			lib=lib${lib}.so.${PV}

			# auto-detect soname and create appropriate symlinks
			soname=$(scanelf -qF'%S#F' ${lib}) || die "Scanning ${lib} failed"
			if [[ ${soname} && ${soname} != ${lib} ]]; then
				ln -s ${lib} ${libdir}/${soname} || die
			fi
			ln -s ${lib} ${libdir}/${lib%.so*}.so || die

			dolib.so ${libdir}/${lib%.so*}*
		done
	}

	if use driver; then
		linux-mod_src_install

		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-169.07 nvidia.conf
		doins "${FILESDIR}"/nvidia-blacklist-nouveau.conf
		doins "${FILESDIR}"/nvidia-rmmod.conf
	fi

	if use X; then
		exeinto /usr/$(get_libdir)/xorg/modules/drivers
		doexe nvidia_drv.so

		# 390 has legacy glx needing a modified .conf (bug #713546)
		exeinto /usr/$(get_libdir)/extensions/nvidia
		newexe libglx.so{.${PV},}
		insinto /usr/share/X11/xorg.conf.d
		newins {,50-}nvidia-drm-outputclass.conf

		# vulkan icd uses libGLX_nvidia.so and so requires X
		insinto /usr/share/vulkan/icd.d
		doins nvidia_icd.json
	fi

	insinto /usr/share/glvnd/egl_vendor.d
	doins 10_nvidia.json

	insinto /etc/OpenCL/vendors
	doins nvidia.icd

	insinto /etc/nvidia
	newins nvidia-application-profiles{-${PV},}-rc

	# install built helpers
	nvidia-drivers_make_install modprobe
	# allow video group to load mods and create devs (bug #505092)
	fowners root:video /usr/bin/nvidia-modprobe
	fperms 4710 /usr/bin/nvidia-modprobe

	nvidia-drivers_make_install persistenced
	newconfd "${FILESDIR}/nvidia-persistenced.confd" nvidia-persistenced
	newinitd "${FILESDIR}/nvidia-persistenced.initd" nvidia-persistenced
	systemd_dounit nvidia-persistenced.service

	use X && nvidia-drivers_make_install xconfig

	if use tools; then
		nvidia-drivers_make_install settings
		doicon nvidia-settings/doc/nvidia-settings.png
		domenu nvidia-settings/doc/nvidia-settings.desktop

		insinto /usr/share/nvidia
		newins nvidia-application-profiles{-${PV},}-key-documentation

		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/95-nvidia-settings-r1 95-nvidia-settings
	fi

	if use static-libs; then
		dolib.a nvidia-settings/src/libXNVCtrl/libXNVCtrl.a

		insinto /usr/include/NVCtrl
		doins nvidia-settings/src/libXNVCtrl/NVCtrl{Lib,}.h
	fi

	# install prebuilt-only helpers
	exeinto /opt/bin

	doexe nvidia-cuda-mps-control
	doman nvidia-cuda-mps-control.1
	doexe nvidia-cuda-mps-server

	doexe nvidia-debugdump
	dobin nvidia-bug-report.sh

	doexe nvidia-smi
	doman nvidia-smi.1

	# install prebuilt-only libraries
	mv tls/libnvidia-tls.so.${PV} . || die # alt tls lib needed by libglx.so
	multilib_foreach_abi nvidia-drivers_libs_install

	einstalldocs
}

pkg_preinst() {
	use driver || return
	linux-mod_pkg_preinst

	# set video group id based on live system (bug #491414)
	local g=$(getent group video | cut -d: -f3)
	[[ ${g} ]] || die "Failed to determine video group id"
	sed "s/PACKAGE/${PF}/;s/VIDEOGID/${g}/" \
		-i "${ED}"/etc/modprobe.d/nvidia.conf || die
}

pkg_postinst() {
	use driver && linux-mod_pkg_postinst

	optfeature "wayland EGLStream with nvidia-drm.modeset=1" gui-libs/egl-wayland

	if [[ -r /proc/driver/nvidia/version &&
		$(grep -o '  [0-9.]*  ' /proc/driver/nvidia/version) != "  ${PV}  " ]]; then
		ewarn "Currently loaded NVIDIA modules do not match the newly installed"
		ewarn "libraries and will lead to GPU-using application issues."
		use driver && ewarn "The easiest way to fix this is to reboot."
	fi

	if ! [[ ${REPLACING_VERSIONS} && $(getent group video | cut -d: -f4) ]]; then
		elog "***** WARNING *****"
		elog "Users should be in the 'video' group to use NVIDIA devices."
		elog "You can add yourself by using: gpasswd -a myuser video"
	fi

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		if use x86; then
			elog "Note that NVIDIA is no longer offering support for the unified memory"
			elog "module (nvidia-uvm) on x86 (32bit), as such the module was not built."
			elog "This means OpenCL/CUDA (and related, like nvenc) cannot be used."
			elog "Other functions, like OpenGL, will continue to work."
			elog
		fi
		elog "For general information with using NVIDIA on Gentoo, please see:"
		elog "https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers"
	fi
}
