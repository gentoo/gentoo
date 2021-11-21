# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE="driver"
inherit desktop linux-mod multilib-build \
	readme.gentoo-r1 systemd toolchain-funcs unpacker

NV_KERNEL_MAX="5.15"
NV_URI="https://download.nvidia.com/XFree86/"

DESCRIPTION="NVIDIA Accelerated Graphics Driver"
HOMEPAGE="https://www.nvidia.com/download/index.aspx"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )
	arm64? ( ${NV_URI}Linux-aarch64/${PV}/NVIDIA-Linux-aarch64-${PV}.run )
	${NV_URI}nvidia-installer/nvidia-installer-${PV}.tar.bz2
	${NV_URI}nvidia-modprobe/nvidia-modprobe-${PV}.tar.bz2
	${NV_URI}nvidia-persistenced/nvidia-persistenced-${PV}.tar.bz2
	${NV_URI}nvidia-settings/nvidia-settings-${PV}.tar.bz2
	${NV_URI}nvidia-xconfig/nvidia-xconfig-${PV}.tar.bz2"
# nvidia-installer is unused but here for GPL-2's "distribute sources"
S="${WORKDIR}"

LICENSE="NVIDIA-r2 GPL-2 MIT ZLIB"
SLOT="0/${PV%%.*}"
KEYWORDS="-* amd64"
IUSE="+X +driver static-libs +tools wayland"

COMMON_DEPEND="
	acct-group/video
	acct-user/nvpd
	net-libs/libtirpc:=
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		dev-libs/jansson
		media-libs/harfbuzz:=
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
	)
	wayland? (
		>=gui-libs/egl-wayland-1.1.7-r1
		media-libs/libglvnd
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
	sys-devel/m4
	virtual/pkgconfig"

QA_PREBUILT="lib/firmware/* opt/bin/* usr/lib*"

PATCHES=(
	"${FILESDIR}"/nvidia-modprobe-390.141-uvm-perms.patch
)

pkg_setup() {
	use driver || return

	local CONFIG_CHECK="
		PROC_FS
		~DRM_KMS_HELPER
		~SYSVIPC
		~!DRM_SIMPLEDRM
		~!LOCKDEP
		~!SLUB_DEBUG_ON
		!DEBUG_MUTEXES"
	local ERROR_DRM_KMS_HELPER="CONFIG_DRM_KMS_HELPER: is not set but needed for Xorg auto-detection
	of drivers (no custom config), and for wayland / nvidia-drm.modeset=1.
	Cannot be directly selected in the kernel's menuconfig, and may need
	selection of a DRM device even if unused, e.g. CONFIG_DRM_AMDGPU=m or
	DRM_I915=y, DRM_NOUVEAU=m also acceptable if a module and not built-in.
	Note: DRM_SIMPLEDRM may cause issues and is better disabled for now."

	use amd64 && kernel_is -ge 5 8 && CONFIG_CHECK+=" X86_PAT" #817764

	MODULE_NAMES="
		nvidia(video:kernel)
		nvidia-drm(video:kernel)
		nvidia-modeset(video:kernel)
		nvidia-peermem(video:kernel)
		nvidia-uvm(video:kernel)"

	linux-mod_pkg_setup

	[[ ${MERGE_TYPE} == binary ]] && return

	BUILD_PARAMS='NV_VERBOSE=1 IGNORE_CC_MISMATCH=yes SYSSRC="${KV_DIR}" SYSOUT="${KV_OUT_DIR}"'
	BUILD_TARGETS="modules" # defaults' clean sometimes deletes modules

	if linux_chkconfig_present CC_IS_CLANG; then
		ewarn "Warning: building ${PN} with a clang-built kernel is experimental."

		BUILD_PARAMS+=' CC=${CHOST}-clang'
		if linux_chkconfig_present LD_IS_LLD; then
			BUILD_PARAMS+=' LD=ld.lld'
			if linux_chkconfig_present LTO_CLANG_THIN; then
				# kernel enables cache by default leading to sandbox violations
				BUILD_PARAMS+=' ldflags-y=--thinlto-cache-dir= LDFLAGS_MODULE=--thinlto-cache-dir='
			fi
		fi
	fi

	if kernel_is -gt ${NV_KERNEL_MAX/./ }; then
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
	sed 's/defined(CONFIG_DRM/defined(CONFIG_DRM_KMS_HELPER/g' \
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

	# enable nvidia-drm.modeset=1 by default with USE=wayland
	cp "${FILESDIR}"/nvidia-470.conf "${T}"/nvidia.conf || die
	use !wayland || sed -i '/^#.*modeset=1$/s/^#//' "${T}"/nvidia.conf || die

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

	nvidia-drivers_make modprobe
	nvidia-drivers_make persistenced
	use X && nvidia-drivers_make xconfig

	if use tools; then
		nvidia-drivers_make settings
	elif use static-libs; then
		nvidia-drivers_make settings/src out/libXNVCtrl.a
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
			nvidia-allocator
			nvidia-eglcore
			nvidia-encode
			nvidia-glcore
			nvidia-glsi
			nvidia-glvkspirv
			nvidia-ml
			nvidia-opencl
			nvidia-opticalflow
			nvidia-ptxjitcompiler
			nvidia-tls
			$(usex X "
				GLX_nvidia
				nvidia-fbc
				vdpau_nvidia
				$(usex amd64 nvidia-ifr '')
			" '')
			$(usex amd64 nvidia-compiler '')
		)

		local libdir=.
		if [[ ${ABI} == x86 ]]; then
			libdir+=/32
		else
			libs+=(
				libnvidia-nvvm.so.4.0.0
				nvidia-cbl
				nvidia-cfg
				nvidia-rtcore
				nvoptix
				$(usex amd64 nvidia-ngx '')
				$(usex wayland nvidia-vulkan-producer '')
			)
		fi

		local lib soname
		for lib in "${libs[@]}"; do
			[[ ${lib:0:3} != lib ]] && lib=lib${lib}.so.${PV}

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
		doins "${T}"/nvidia.conf

		insinto /lib/firmware/nvidia/${PV}
		use amd64 && doins firmware/gsp.bin

		# used for gpu verification with binpkgs (not kept)
		insinto /usr/share/nvidia
		doins supported-gpus/supported-gpus.json
	fi

	if use X; then
		exeinto /usr/$(get_libdir)/xorg/modules/drivers
		doexe nvidia_drv.so

		exeinto /usr/$(get_libdir)/xorg/modules/extensions
		newexe libglxserver_nvidia.so{.${PV},}

		insinto /usr/share/X11/xorg.conf.d
		newins {,50-}nvidia-drm-outputclass.conf

		# vulkan icd uses libGLX_nvidia.so and so requires X
		insinto /usr/share/vulkan/icd.d
		doins nvidia_icd.json
		insinto /usr/share/vulkan/implicit_layer.d
		doins nvidia_layers.json
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
	fowners :video /usr/bin/nvidia-modprobe
	fperms 4710 /usr/bin/nvidia-modprobe

	nvidia-drivers_make_install persistenced
	newconfd "${FILESDIR}"/nvidia-persistenced.confd nvidia-persistenced
	newinitd "${FILESDIR}"/nvidia-persistenced.initd nvidia-persistenced
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
		dolib.a nvidia-settings/src/out/libXNVCtrl.a

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
	multilib_foreach_abi nvidia-drivers_libs_install

	# install dlls for optional use with proton/wine
	insinto /usr/$(get_libdir)/nvidia/wine
	use amd64 && doins {_,}nvngx.dll

	# install systemd sleep services
	exeinto /lib/systemd/system-sleep
	doexe systemd/system-sleep/nvidia
	dobin systemd/nvidia-sleep.sh
	systemd_dounit systemd/system/nvidia-{hibernate,resume,suspend}.service

	# create README.gentoo
	local DISABLE_AUTOFORMATTING=yes
	local DOC_CONTENTS=\
"Trusted users should be in the 'video' group to use NVIDIA devices.
You can add yourself by using: gpasswd -a my-user video

See '${EPREFIX}/etc/modprobe.d/nvidia.conf' for modules options.

For general information on using nvidia-drivers, please see:
https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers"
	readme.gentoo_create_doc

	local DOCS=(
		README.txt NVIDIA_Changelog supported-gpus/supported-gpus.json
		nvidia-settings/doc/{FRAMELOCK,NV-CONTROL-API}.txt
	)
	local HTML_DOCS=( html/. )
	einstalldocs
}

pkg_preinst() {
	use driver || return
	linux-mod_pkg_preinst

	# set video group id based on live system (bug #491414)
	local g=$(getent group video | cut -d: -f3)
	[[ ${g} ]] || die "Failed to determine video group id"
	sed -i "s/@VIDEOGID@/${g}/" "${ED}"/etc/modprobe.d/nvidia.conf || die

	# try to find driver mismatches using temporary supported-gpus.json
	for g in $(grep -l 0x10de /sys/bus/pci/devices/*/vendor 2>/dev/null); do
		g=$(grep -io "\"devid\":\"$(<${g%vendor}device)\"[^}]*branch\":\"[0-9]*" \
			"${ED}"/usr/share/nvidia/supported-gpus.json 2>/dev/null)
		if [[ ${g} ]]; then
			g=$((${g##*\"}+1))
			if ver_test -ge ${g}; then
				NV_LEGACY_MASK=">=${CATEGORY}/${PN}-${g}"
				break
			fi
		fi
	done
	rm "${ED}"/usr/share/nvidia/supported-gpus.json || die

	has_version "x11-drivers/nvidia-drivers[wayland]" && NV_HAD_WAYLAND=1
}

pkg_postinst() {
	use driver && linux-mod_pkg_postinst

	readme.gentoo_print_elog

	if [[ -r /proc/driver/nvidia/version &&
		$(grep -o '  [0-9.]*  ' /proc/driver/nvidia/version) != "  ${PV}  " ]]; then
		ewarn "Currently loaded NVIDIA modules do not match the newly installed"
		ewarn "libraries and will lead to GPU-using application issues."
		use driver && ewarn "The easiest way to fix this is usually to reboot."
	fi

	if [[ $(</proc/cmdline) == *slub_debug=[!-]* ]]; then
		ewarn "Detected that the current kernel command line is using 'slub_debug=',"
		ewarn "this may lead to system instability/freezes with this version of"
		ewarn "${PN}. Bug: https://bugs.gentoo.org/796329"
	fi

	if [[ ${NV_LEGACY_MASK} ]]; then
		ewarn
		ewarn "***WARNING***"
		ewarn
		ewarn "You are installing a version of nvidia-drivers known not to work"
		ewarn "with a GPU of the current system. If unwanted, add the mask:"
		if [[ -d ${EROOT}/etc/portage/package.mask ]]; then
			ewarn "  echo '${NV_LEGACY_MASK}' > ${EROOT}/etc/portage/package.mask/${PN}"
		else
			ewarn "  echo '${NV_LEGACY_MASK}' >> ${EROOT}/etc/portage/package.mask"
		fi
		ewarn "...then downgrade to a legacy branch if possible. For details, see:"
		ewarn "https://www.nvidia.com/object/IO_32667.html"
	fi

	if use wayland && use driver && [[ ! ${NV_HAD_WAYLAND} ]]; then
		elog
		elog "With USE=wayland, this version of ${PN} sets nvidia-drm.modeset=1"
		elog "in '${EROOT}/etc/modprobe.d/nvidia.conf'. This feature is considered"
		elog "experimental but is required for EGLStream (used for wayland acceleration"
		elog "in compositors that support it)."
		elog
		elog "If you experience issues, please comment out the option from nvidia.conf."
		elog "Of note, may possibly cause issues with SLI and Reverse PRIME."
	fi

	# Try to show this message only to users that may really need it
	# given the workaround is discouraged and usage isn't widespread.
	if use X && [[ ${REPLACING_VERSIONS} ]] &&
		ver_test ${REPLACING_VERSIONS} -lt 460.73.01 &&
		grep -qr Coolbits "${EROOT}"/etc/X11/{xorg.conf,xorg.conf.d/*.conf} 2>/dev/null; then
		elog
		elog "Coolbits support with ${PN} has been restricted to require Xorg"
		elog "with root privilege by NVIDIA (being in video group is not sufficient)."
		elog "e.g. attempting to change fan speed with nvidia-settings would fail."
		elog
		elog "Depending on your display manager (e.g. sddm starts X as root, gdm doesn't)"
		elog "or if using startx, it may be necessary to emerge x11-base/xorg-server with"
		elog 'USE="suid -elogind -systemd" if wish to keep using this feature.'
		elog "Bug: https://bugs.gentoo.org/784248"
	fi
}
