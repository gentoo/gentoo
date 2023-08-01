# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE=+modules
inherit desktop flag-o-matic linux-mod-r1 multilib readme.gentoo-r1
inherit systemd toolchain-funcs unpacker user-info

MODULES_KERNEL_MAX=6.1
NV_URI="https://download.nvidia.com/XFree86/"

DESCRIPTION="NVIDIA Accelerated Graphics Driver"
HOMEPAGE="https://www.nvidia.com/download/index.aspx"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )
	x86? ( ${NV_URI}Linux-x86/${PV}/NVIDIA-Linux-x86-${PV}.run )
	$(printf "${NV_URI}%s/%s-${PV}.tar.bz2 " \
		nvidia-{installer,modprobe,persistenced,settings,xconfig}{,})"
# nvidia-installer is unused but here for GPL-2's "distribute sources"
S="${WORKDIR}"

LICENSE="NVIDIA-r2 BSD BSD-2 GPL-2 MIT"
SLOT="0/${PV%%.*}"
KEYWORDS="-* amd64 x86"
IUSE="+X abi_x86_32 abi_x86_64 persistenced +static-libs +tools"

COMMON_DEPEND="
	acct-group/video
	sys-libs/glibc
	persistenced? (
		acct-user/nvpd
		net-libs/libtirpc:=
	)
	tools? (
		>=app-accessibility/at-spi2-core-2.46:2
		dev-libs/glib:2
		dev-libs/jansson:=
		media-libs/harfbuzz:=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/pango
	)"
RDEPEND="
	${COMMON_DEPEND}
	X? (
		media-libs/libglvnd[X,abi_x86_32(-)?]
		x11-libs/libX11[abi_x86_32(-)?]
		x11-libs/libXext[abi_x86_32(-)?]
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
	sys-devel/m4
	virtual/pkgconfig"

QA_PREBUILT="opt/bin/* usr/lib*"

PATCHES=(
	# note: no plans to add patches for newer kernels here, when the last
	# working 6.1.x LTS is EOL then 390 will simply be removed from the tree
	"${FILESDIR}"/nvidia-modprobe-390.141-uvm-perms.patch
	"${FILESDIR}"/nvidia-settings-390.141-fno-common.patch
	"${FILESDIR}"/nvidia-settings-390.144-desktop.patch
	"${FILESDIR}"/nvidia-settings-390.144-no-gtk2.patch
	"${FILESDIR}"/nvidia-settings-390.144-raw-ldflags.patch
)

pkg_setup() {
	use modules && [[ ${MERGE_TYPE} != binary ]] || return

	local CONFIG_CHECK="
		PROC_FS
		~DRM_KMS_HELPER
		~SYSVIPC
		~!AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
		~!LOCKDEP
		~!X86_KERNEL_IBT
		!DEBUG_MUTEXES"
	local ERROR_DRM_KMS_HELPER="CONFIG_DRM_KMS_HELPER: is not set but needed for Xorg auto-detection
	of drivers (no custom config), and optional nvidia-drm.modeset=1.
	With 390.xx drivers, also used by a GLX workaround needed for OpenGL.
	Cannot be directly selected in the kernel's menuconfig, and may need
	selection of a DRM device even if unused, e.g. CONFIG_DRM_AMDGPU=m or
	DRM_I915=y, DRM_NOUVEAU=m also acceptable if a module and not built-in."
	local ERROR_X86_KERNEL_IBT="CONFIG_X86_KERNEL_IBT: is set, be warned the modules may not load.
	If run into problems, either unset or try to pass ibt=off to the kernel."

	kernel_is -ge 5 8 && CONFIG_CHECK+=" X86_PAT" #817764

	linux-mod-r1_pkg_setup
}

src_prepare() {
	# make patches usable across versions
	rm nvidia-modprobe && mv nvidia-modprobe{-${PV},} || die
	rm nvidia-persistenced && mv nvidia-persistenced{-${PV},} || die
	rm nvidia-settings && mv nvidia-settings{-${PV},} || die
	rm nvidia-xconfig && mv nvidia-xconfig{-${PV},} || die

	eapply "${FILESDIR}"/nvidia-drivers-390.154-clang15$(usev {,-}x86).patch

	default

	# prevent detection of incomplete kernel DRM support (bug #603818)
	sed 's/defined(CONFIG_DRM/defined(CONFIG_DRM_KMS_HELPER/g' \
		-i kernel/conftest.sh || die

	sed 's/__USER__/nvpd/' \
		nvidia-persistenced/init/systemd/nvidia-persistenced.service.template \
		> "${T}"/nvidia-persistenced.service || die

	# use alternative vulkan icd option if USE=-X (bug #909181)
	sed "s/__NV_VK_ICD__/lib$(usex X GLX EGL)_nvidia.so.0/" \
		nvidia_icd.json.template > nvidia_icd.json || die

	# 390 has legacy glx needing a modified .conf (bug #713546)
	# directory is not quite right, but kept for any existing custom xorg.conf
	sed "s|@LIBDIR@|${EPREFIX}/usr/$(get_libdir)|" \
		"${FILESDIR}"/nvidia-drm-outputclass-390.conf > nvidia-drm-outputclass.conf || die
}

src_compile() {
	tc-export AR CC CXX LD OBJCOPY OBJDUMP
	local -x RAW_LDFLAGS="$(get_abi_LDFLAGS) $(raw-ldflags)" # raw-ldflags.patch

	NV_ARGS=(
		PREFIX="${EPREFIX}"/usr
		HOST_CC="$(tc-getBUILD_CC)"
		HOST_LD="$(tc-getBUILD_LD)"
		NV_USE_BUNDLED_LIBJANSSON=0
		NV_VERBOSE=1 DO_STRIP= MANPAGE_GZIP= OUTPUTDIR=out
	)

	local modlist=( nvidia{,-drm,-modeset}=video:kernel )
	use x86 || modlist+=( nvidia-uvm=video:kernel )
	local modargs=(
		IGNORE_CC_MISMATCH=yes NV_VERBOSE=1
		SYSOUT="${KV_OUT_DIR}" SYSSRC="${KV_DIR}"
	)

	linux-mod-r1_src_compile

	if use persistenced; then
		# 390.xx persistenced does not auto-detect libtirpc
		LIBS=$($(tc-getPKG_CONFIG) --libs libtirpc || die) \
			common_cflags=$($(tc-getPKG_CONFIG) --cflags libtirpc || die) \
			emake "${NV_ARGS[@]}" -C nvidia-persistenced
	fi

	emake "${NV_ARGS[@]}" -C nvidia-modprobe
	use X && emake "${NV_ARGS[@]}" -C nvidia-xconfig

	if use tools; then
		# cflags: avoid noisy logs, only use here and set first to let override
		CFLAGS="-Wno-deprecated-declarations ${CFLAGS}" \
			emake "${NV_ARGS[@]}" -C nvidia-settings
	elif use static-libs; then
		emake "${NV_ARGS[@]}" -C nvidia-settings/src build-xnvctrl
	fi
}

src_install() {
	local libdir=$(get_libdir) libdir32=$(ABI=x86 get_libdir)

	NV_ARGS+=( DESTDIR="${D}" LIBDIR="${ED}"/usr/${libdir} )

	local -A paths=(
		[APPLICATION_PROFILE]=/usr/share/nvidia
		[CUDA_ICD]=/etc/OpenCL/vendors
		[EGL_EXTERNAL_PLATFORM_JSON]=/usr/share/egl/egl_external_platform.d
		[GLVND_EGL_ICD_JSON]=/usr/share/glvnd/egl_vendor.d
		[VULKAN_ICD_JSON]=/usr/share/vulkan/icd.d
		[XORG_OUTPUTCLASS_CONFIG]=/usr/share/X11/xorg.conf.d

		[GLX_MODULE_SHARED_LIB]=/usr/${libdir}/xorg/modules/extensions
		[GLX_MODULE_SYMLINK]=/usr/${libdir}/extensions/nvidia
		[XMODULE_SHARED_LIB]=/usr/${libdir}/xorg/modules
		[XMODULE_SYMLINK]=/usr/${libdir}/xorg/modules
	)

	local skip_files=(
		$(usev !X "libGLX_nvidia libglx libnvidia-ifr")
		libGLX_indirect # non-glvnd unused fallback
		libnvidia-gtk nvidia-{settings,xconfig} # built from source
		libnvidia-egl-wayland 10_nvidia_wayland # gui-libs/egl-wayland
	)
	local skip_modules=(
		$(usev !X "nvfbc vdpau xdriver")
		installer nvpd # handled separately / built from source
	)
	local skip_types=(
		GLVND_LIB GLVND_SYMLINK EGL_CLIENT.\* GLX_CLIENT.\* # media-libs/libglvnd
		OPENCL_WRAPPER.\* # virtual/opencl
		DOCUMENTATION DOT_DESKTOP # handled separately
		XMODULE_NEWSYM # use xorg's libwfb.so, nvidia also keeps it if it exists
		.\*_SRC DKMS_CONF LIBGL_LA OPENGL_HEADER # unused
	)

	local DOCS=(
		README.txt NVIDIA_Changelog
		nvidia-settings/doc/{FRAMELOCK,NV-CONTROL-API}.txt
	)
	local HTML_DOCS=( html/. )
	einstalldocs

	local DISABLE_AUTOFORMATTING=yes
	local DOC_CONTENTS="\
Trusted users should be in the 'video' group to use NVIDIA devices.
You can add yourself by using: gpasswd -a my-user video\
$(usev modules "

Like all out-of-tree kernel modules, it is necessary to rebuild
${PN} after upgrading or rebuilding the Linux kernel
by for example running \`emerge @module-rebuild\`. Alternatively,
if using a distribution kernel (sys-kernel/gentoo-kernel{,-bin}),
this can be automated by setting USE=dist-kernel globally.

Loaded kernel modules also must not mismatch with the installed
${PN} version (excluding -r revision), meaning should
ensure \`eselect kernel list\` points to the kernel that will be
booted before building and preferably reboot after upgrading
${PN} (the ebuild will emit a warning if mismatching).

See '${EPREFIX}/etc/modprobe.d/nvidia.conf' for modules options.")\
$(use amd64 && usev !abi_x86_32 "

Note that without USE=abi_x86_32 on ${PN}, 32bit applications
(typically using wine / steam) will not be able to use GPU acceleration.")\
$(usev X "

390.xx libglvnd support is partial and requires different Xorg modules
for working OpenGL/GLX. If using the default Xorg configuration these
should be used automatically, otherwise manually add the ModulePath
from: '${EPREFIX}/${paths[XORG_OUTPUTCLASS_CONFIG]#/}/nvidia-drm-outputclass.conf'")\
$(usev x86 "

Note that NVIDIA is no longer offering support for the unified memory
module (nvidia-uvm) on x86 (32bit), as such the module is missing.
This means OpenCL/CUDA (and related, like nvenc) cannot be used.
Other functions, like OpenGL, will continue to work.")

Support from NVIDIA for 390.xx will end in December 2022, how long
Gentoo will be able to reasonably support it beyond that is unknown.
If wish to continue using this hardware, should consider switching
to the Nouveau open source driver.
https://nvidia.custhelp.com/app/answers/detail/a_id/3142/

For additional information or for troubleshooting issues, please see
https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers and NVIDIA's own
documentation that is installed alongside this README."
	readme.gentoo_create_doc

	if use modules; then
		linux-mod-r1_src_install

		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-390.conf nvidia.conf
	fi

	emake "${NV_ARGS[@]}" -C nvidia-modprobe install
	fowners :video /usr/bin/nvidia-modprobe #505092
	fperms 4710 /usr/bin/nvidia-modprobe

	if use persistenced; then
		emake "${NV_ARGS[@]}" -C nvidia-persistenced install
		newconfd "${FILESDIR}"/nvidia-persistenced.confd nvidia-persistenced
		newinitd "${FILESDIR}"/nvidia-persistenced.initd nvidia-persistenced
		systemd_dounit "${T}"/nvidia-persistenced.service
	fi

	if use tools; then
		emake "${NV_ARGS[@]}" -C nvidia-settings install

		doicon nvidia-settings/doc/nvidia-settings.png
		domenu nvidia-settings/doc/nvidia-settings.desktop

		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/95-nvidia-settings-r1 95-nvidia-settings
	fi

	if use static-libs; then
		dolib.a nvidia-settings/src/libXNVCtrl/libXNVCtrl.a

		insinto /usr/include/NVCtrl
		doins nvidia-settings/src/libXNVCtrl/NVCtrl{Lib,}.h
	fi

	use X && emake "${NV_ARGS[@]}" -C nvidia-xconfig install

	# mimic nvidia-installer by reading .manifest to install files
	# 0:file 1:perms 2:type 3+:subtype/arguments -:module
	local m into
	while IFS=' ' read -ra m; do
		! [[ ${#m[@]} -ge 2 && ${m[-1]} =~ MODULE: ]] ||
			[[ " ${m[0]##*/}" =~ ^(\ ${skip_files[*]/%/.*|\\} )$ ]] ||
			[[ " ${m[2]}" =~ ^(\ ${skip_types[*]/%/|\\} )$ ]] ||
			has ${m[-1]#MODULE:} "${skip_modules[@]}" && continue

		case ${m[2]} in
			MANPAGE)
				gzip -dc ${m[0]} | newman - ${m[0]%.gz}; assert
				continue
			;;
			GLX_MODULE_SYMLINK|XMODULE_NEWSYM)
				# messy symlinks for non-glvnd xorg modules overrides put
				# in a different directory to avoid collisions (390-only)
				m[4]=../../xorg/modules/${m[3]#/}${m[4]}
				m[3]=/
			;;
			TLS_LIB) [[ ${m[4]} == CLASSIC ]] && continue;; # segfaults (bug #785289)
			VDPAU_SYMLINK) m[4]=vdpau/; m[5]=${m[5]#vdpau/};; # .so to vdpau/
			VULKAN_ICD_JSON) m[0]=${m[0]%.template};;
		esac

		if [[ -v 'paths[${m[2]}]' ]]; then
			into=${paths[${m[2]}]}
		elif [[ ${m[2]} == *_BINARY ]]; then
			into=/opt/bin
		elif [[ ${m[3]} == COMPAT32 ]]; then
			use abi_x86_32 || continue
			into=/usr/${libdir32}
		elif [[ ${m[2]} == *_@(LIB|SYMLINK) ]]; then
			into=/usr/${libdir}
		else
			die "No known installation path for ${m[0]}"
		fi
		[[ ${m[3]: -2} == ?/ ]] && into+=/${m[3]%/}
		[[ ${m[4]: -2} == ?/ ]] && into+=/${m[4]%/}

		if [[ ${m[2]} =~ _SYMLINK$|_NEWSYM$ ]]; then
			[[ ${m[4]: -1} == / ]] && m[4]=${m[5]}
			dosym ${m[4]} ${into}/${m[0]}
			continue
		fi

		printf -v m[1] %o $((m[1] | 0200)) # 444->644
		insopts -m${m[1]}
		insinto ${into}
		doins ${m[0]}
	done < .manifest || die
	insopts -m0644 # reset

	# MODULE:installer non-skipped extras
	dolib.so libnvidia-cfg.so.${PV}
	dosym libnvidia-cfg.so.${PV} /usr/${libdir}/libnvidia-cfg.so.1
	dosym libnvidia-cfg.so.${PV} /usr/${libdir}/libnvidia-cfg.so

	dobin nvidia-bug-report.sh

	# symlink non-versioned so nvidia-settings can use it even if misdetected
	dosym nvidia-application-profiles-${PV}-key-documentation \
		${paths[APPLICATION_PROFILE]}/nvidia-application-profiles-key-documentation

	# sandbox issues with /dev/nvidiactl are widespread and sometime
	# affect revdeps of packages built with USE=opencl/cuda making it
	# hard to manage in ebuilds (minimal set, ebuilds should handle
	# manually if need others or addwrite)
	insinto /etc/sandbox.d
	newins - 20nvidia <<<'SANDBOX_PREDICT="/dev/nvidiactl"'
}

pkg_preinst() {
	use modules || return

	# set video group id based on live system (bug #491414)
	local g=$(egetent group video | cut -d: -f3)
	[[ ${g} =~ ^[0-9]+$ ]] || die "Failed to determine video group id (got '${g}')"
	sed -i "s/@VIDEOGID@/${g}/" "${ED}"/etc/modprobe.d/nvidia.conf || die
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	readme.gentoo_print_elog

	if [[ -r /proc/driver/nvidia/version &&
		$(</proc/driver/nvidia/version) != *"  ${PV}  "* ]]; then
		ewarn "Currently loaded NVIDIA modules do not match the newly installed"
		ewarn "libraries and may prevent launching GPU-accelerated applications."
		if use modules; then
			ewarn "Easiest way to fix this is normally to reboot. If still run into issues"
			ewarn "(e.g. API mismatch messages in the \`dmesg\` output), please verify"
			ewarn "that the running kernel is ${KV_FULL} and that (if used) the"
			ewarn "initramfs does not include NVIDIA modules (or at least, not old ones)."
		fi
	fi

	ewarn
	ewarn "Be warned/reminded that the 390.xx branch reached end-of-life and"
	ewarn "NVIDIA is no longer fixing issues (including security). Free to keep"
	ewarn "using (for now) but it is recommended to either switch to nouveau or"
	ewarn "replace hardware. Will be kept in-tree while possible, but expect it"
	ewarn "to be removed likely in early 2027 or earlier if major issues arise."
}
