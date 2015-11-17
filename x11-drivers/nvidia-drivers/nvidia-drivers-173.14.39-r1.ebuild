# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic linux-mod multilib nvidia-driver portability \
	unpacker user versionator

X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"
X86_FBSD_NV_PACKAGE="NVIDIA-FreeBSD-x86-${PV}"

DESCRIPTION="NVIDIA Accelerated Graphics Driver"
HOMEPAGE="http://www.nvidia.com/"
SRC_URI="x86? ( http://us.download.nvidia.com/XFree86/Linux-x86/${PV}/${X86_NV_PACKAGE}-pkg0.run )
	 amd64? ( http://us.download.nvidia.com/XFree86/Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}-pkg2.run )
	 x86-fbsd? ( http://us.download.nvidia.com/freebsd/${PV}/${X86_FBSD_NV_PACKAGE}.tar.gz )"

LICENSE="GPL-2 NVIDIA-r1"
SLOT="0/173"
KEYWORDS="-* amd64 x86 ~x86-fbsd"
IUSE="acpi multilib kernel_linux tools"
RESTRICT="bindist mirror strip"
EMULTILIB_PKG="true"

COMMON="
	>=app-eselect/eselect-opengl-1.0.9
	kernel_linux? ( >=sys-libs/glibc-2.6.1 )
"
DEPEND="
	${COMMON}
	kernel_linux? ( virtual/linux-sources )
"
RDEPEND="
	${COMMON}
	<x11-base/xorg-server-1.15.99:=
	acpi? ( sys-power/acpid )
	multilib? (
		>=x11-libs/libX11-1.6.2[abi_x86_32]
		>=x11-libs/libXext-1.3.2[abi_x86_32]
	)
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/pango[X]
	)
"

QA_TEXTRELS_x86="usr/lib/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib/xorg/modules/drivers/nvidia_drv.so
	usr/lib/libcuda.so.${PV}
	usr/lib/libnvidia-cfg.so.${PV}
	usr/lib/libvdpau_nvidia.so.${PV}
	usr/lib/libXvMCNVIDIA.so.${PV}"

QA_TEXTRELS_x86_fbsd="boot/modules/nvidia.ko
	usr/lib/opengl/nvidia/lib/libGL.so.1
	usr/lib/opengl/nvidia/lib/libGLcore.so.1
	usr/lib/libnvidia-cfg.so.1
	usr/lib/opengl/nvidia/extensions/libglx.so.1
	usr/lib/xorg/modules/drivers/nvidia_drv.so"

QA_TEXTRELS_amd64="usr/lib32/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib32/libcuda.so.${PV}
	usr/lib32/libvdpau_nvidia.so.${PV}"

QA_EXECSTACK_x86="usr/lib/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib/xorg/modules/drivers/nvidia_drv.so
	usr/lib/libXvMCNVIDIA.a:NVXVMC.o"

QA_EXECSTACK_amd64="usr/lib32/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib64/libnvcompiler.so.${PV}
	usr/lib64/libXvMCNVIDIA.so.${PV}
	usr/lib64/libXvMCNVIDIA.a:NVXVMC.o
	usr/lib64/libnvidia-cfg.so.${PV}
	usr/lib64/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib64/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib64/xorg/modules/drivers/nvidia_drv.so
	opt/bin/nvidia-settings
	opt/bin/nvidia-smi
	opt/bin/nvidia-xconfig"

QA_WX_LOAD_x86="usr/lib/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib/libXvMCNVIDIA.a"

QA_WX_LOAD_amd64="usr/lib32/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib64/opengl/nvidia/extensions/libglx.so.${PV}"

QA_SONAME_amd64="usr/lib64/libnvcompiler.so.${PV}"

QA_FLAGS_IGNORED_amd64="usr/lib32/libcuda.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib32/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib32/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib32/libvdpau_nvidia.so.${PV}
	usr/lib64/libXvMCNVIDIA.so.${PV}
	usr/lib64/libcuda.so.${PV}
	usr/lib64/libnvidia-cfg.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib64/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib64/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib64/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib64/xorg/modules/drivers/nvidia_drv.so
	usr/lib64/libvdpau_nvidia.so.${PV}
	opt/bin/nvidia-settings
	opt/bin/nvidia-smi
	opt/bin/nvidia-xconfig"

QA_FLAGS_IGNORED_x86="usr/lib/libcuda.so.${PV}
	usr/lib/libnvidia-cfg.so.${PV}
	usr/lib/opengl/nvidia/lib/libGLcore.so.${PV}
	usr/lib/opengl/nvidia/lib/libGL.so.${PV}
	usr/lib/opengl/nvidia/lib/libnvidia-tls.so.${PV}
	usr/lib/opengl/nvidia/extensions/libglx.so.${PV}
	usr/lib/xorg/modules/drivers/nvidia_drv.so
	usr/lib/libXvMCNVIDIA.so.${PV}
	usr/lib/libvdpau_nvidia.so.${PV}
	opt/bin/nvidia-settings
	opt/bin/nvidia-smi
	opt/bin/nvidia-xconfig"

S="${WORKDIR}/"

mtrr_check() {
	ebegin "Checking for MTRR support"
	linux_chkconfig_present MTRR
	eend $?

	if [[ $? -ne 0 ]] ; then
		eerror "Please enable MTRR support in your kernel config, found at:"
		eerror
		eerror "  Processor type and features"
		eerror "    [*] MTRR (Memory Type Range Register) support"
		eerror
		eerror "and recompile your kernel ..."
		die "MTRR support not detected!"
	fi
}

lockdep_check() {
	if linux_chkconfig_present LOCKDEP; then
		eerror "You've enabled LOCKDEP -- lock tracking -- in the kernel."
		eerror "Unfortunately, this option exports the symbol 'lockdep_init_map' as GPL-only"
		eerror "which will prevent ${P} from compiling."
		eerror "Please make sure the following options have been unset:"
		eerror "    Kernel hacking  --->"
		eerror "        [ ] Lock debugging: detect incorrect freeing of live locks"
		eerror "        [ ] Lock debugging: prove locking correctness"
		eerror "        [ ] Lock usage statistics"
		eerror "in 'menuconfig'"
		die "LOCKDEP enabled"
	fi
}

pkg_setup() {
	# try to turn off distcc and ccache for people that have a problem with it
	export DISTCC_DISABLE=1
	export CCACHE_DISABLE=1

	if use amd64 && has_multilib_profile && [ "${DEFAULT_ABI}" != "amd64" ]; then
		eerror "This ebuild doesn't currently support changing your default abi."
		die "Unexpected \${DEFAULT_ABI} = ${DEFAULT_ABI}"
	fi

	if use kernel_linux; then
		linux-mod_pkg_setup
		MODULE_NAMES="nvidia(video:${S}/usr/src/nv)"
		BUILD_PARAMS="IGNORE_CC_MISMATCH=yes V=1 SYSSRC=${KV_DIR} \
		SYSOUT=${KV_OUT_DIR} CC=$(tc-getBUILD_CC)"
		# linux-mod_src_compile calls set_arch_to_kernel, which
		# sets the ARCH to x86 but NVIDIA's wrapping Makefile
		# expects x86_64 or i386 and then converts it to x86
		# later on in the build process
		BUILD_FIXES="ARCH=$(uname -m | sed -e 's/i.86/i386/')"
		mtrr_check
		lockdep_check
	fi

	# On BSD userland it wants real make command
	use userland_BSD && MAKE="$(get_bmake)"

	export _POSIX2_VERSION="199209"

	if use kernel_linux && kernel_is ge 3 13 ; then
		ewarn "Gentoo supports kernels which are supported by NVIDIA"
		ewarn "which are limited to the following kernels:"
		ewarn "<sys-kernel/gentoo-sources-3.13"
		ewarn "<sys-kernel/vanilla-sources-3.13"
		ewarn ""
		ewarn "You are free to utilize epatch_user to provide whatever"
		ewarn "support you feel is appropriate, but will not receive"
		ewarn "support as a result of those changes."
		ewarn ""
		ewarn "Do not file a bug report about this."
	fi

	# Since Nvidia ships many different series of drivers, we need to give the user
	# some kind of guidance as to what version they should install. This tries
	# to point the user in the right direction but can't be perfect. check
	# nvidia-driver.eclass
	nvidia-driver-check-warning

	# set variables to where files are in the package structure
	if use kernel_FreeBSD; then
		use x86-fbsd && S="${WORKDIR}/${X86_FBSD_NV_PACKAGE}"
		NV_DOC="${S}/doc"
		NV_EXEC="${S}/obj"
		NV_LIB="${S}/obj"
		NV_SRC="${S}/src"
		NV_MAN="${S}/x11/man"
		NV_X11="${S}/obj"
		NV_X11_DRV="${NV_X11}"
		NV_X11_EXT="${NV_X11}"
		NV_SOVER=1
	elif use kernel_linux; then
		NV_DOC="${S}/usr/share/doc"
		NV_EXEC="${S}/usr/bin"
		NV_LIB="${S}/usr/lib"
		NV_SRC="${S}/usr/src/nv"
		NV_MAN="${S}/usr/share/man/man1"
		NV_X11="${S}/usr/X11R6/lib"
		NV_X11_DRV="${NV_X11}/modules/drivers"
		NV_X11_EXT="${NV_X11}/modules/extensions"
		NV_SOVER=${PV}
	else
		die "Could not determine proper NVIDIA package"
	fi
}

src_unpack() {
	if use kernel_linux && kernel_is lt 2 6 7; then
		echo
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
		ewarn "This is not officially supported for ${P}. It is likely you"
		ewarn "will not be able to compile or use the kernel module."
		ewarn "It is recommended that you upgrade your kernel to a version >= 2.6.7"
		echo
		ewarn "DO NOT file bug reports for kernel versions less than 2.6.7 as they will be ignored."
	fi

	if ! use x86-fbsd; then
		mkdir "${S}"
		cd "${S}"
		unpack_makeself
	else
		unpack ${A}
	fi
}

src_prepare() {
	# Please add a brief description for every added patch
	use x86-fbsd && cd doc

	# Use the correct defines to make gtkglext build work
	epatch "${FILESDIR}"/NVIDIA_glx-defines.patch
	# Use some more sensible gl headers and make way for new glext.h
	epatch "${FILESDIR}"/NVIDIA_glx-glheader.patch

	if use kernel_linux; then
		# Quiet down warnings the user does not need to see
		sed -i \
			-e 's:-Wpointer-arith::g' \
			-e 's:-Wsign-compare::g' \
			"${NV_SRC}"/Makefile.kbuild

		# If greater than 2.6.5 use M= instead of SUBDIR=
		convert_to_m "${NV_SRC}"/Makefile.kbuild
	fi

	epatch_user
}

src_compile() {
	# This is already the default on Linux, as there's no toplevel Makefile, but
	# on FreeBSD there's one and triggers the kernel module build, as we install
	# it by itself, pass this.

	cd "${NV_SRC}"
	if use x86-fbsd; then
		MAKE="$(get_bmake)" CFLAGS="-Wno-sign-compare" emake CC="$(tc-getCC)" \
			LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)"
	elif use kernel_linux; then
		linux-mod_src_compile
	fi
}

src_install() {
	if use kernel_linux; then
		linux-mod_src_install

		# Add the aliases
		# This file is tweaked with the appropriate video group in
		# pkg_preinst, see bug #491414
		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-169.07 nvidia.conf
	elif use kernel_FreeBSD; then
		insinto /boot/modules
		doins "${WORKDIR}/${NV_PACKAGE}/src/nvidia.kld"

		exeinto /boot/modules
		doexe "${WORKDIR}/${NV_PACKAGE}/src/nvidia.ko"
	fi

	# NVIDIA kernel <-> userspace driver config lib
	dolib.so ${NV_LIB}/libnvidia-cfg.so.${NV_SOVER} || \
		die "failed to install libnvidia-cfg"
	dosym libnvidia-cfg.so.${NV_SOVER} \
		/usr/$(get_libdir)/libnvidia-cfg.so.1 || \
		die "failed to create libnvidia-cfg.so.1 symlink"
	dosym libnvidia-cfg.so.1 \
		/usr/$(get_libdir)/libnvidia-cfg.so || \
		die "failed to create libnvidia-cfg.so symlink"

	# Xorg DDX driver
	insinto /usr/$(get_libdir)/xorg/modules/drivers
	doins ${NV_X11_DRV}/nvidia_drv.so

	# Xorg GLX driver
	insinto /usr/$(get_libdir)/opengl/nvidia/extensions
	doins ${NV_X11_EXT}/libglx.so.${NV_SOVER} || \
		die "failed to install libglx.so"
	dosym /usr/$(get_libdir)/opengl/nvidia/extensions/libglx.so.${NV_SOVER} \
		/usr/$(get_libdir)/opengl/nvidia/extensions/libglx.so || \
		die "failed to create libglx.so symlink"

	# XvMC driver
	dolib.a ${NV_X11}/libXvMCNVIDIA.a || \
		die "failed to install libXvMCNVIDIA.so"
	dolib.so ${NV_X11}/libXvMCNVIDIA.so.${NV_SOVER} || \
		die "failed to install libXvMCNVIDIA.so"
	dosym libXvMCNVIDIA.so.${NV_SOVER} \
		/usr/$(get_libdir)/libXvMCNVIDIA.so.1 || \
		die "failed to create libXvMCNVIDIA.so.1 symlink"
	dosym libXvMCNVIDIA.so.1 \
		/usr/$(get_libdir)/libXvMCNVIDIA.so || \
		die "failed to create libXvMCNVIDIA.so symlink"
	dosym libXvMCNVIDIA.so.${NV_SOVER} \
		/usr/$(get_libdir)/libXvMCNVIDIA_dynamic.so.1 || \
		die "failed to create libXvMCNVIDIA_dynamic.so.1 symlink"

	# CUDA headers (driver to come)
	if use kernel_linux && [[ -d ${S}/usr/include/cuda ]]; then
		dodir /usr/include/cuda
		insinto /usr/include/cuda
		doins usr/include/cuda/*.h
	fi

	# OpenCL headers (driver to come)
	if [[ -d ${S}/usr/include/CL ]]; then
		dodir /usr/include/CL
		insinto /usr/include/CL
		doins usr/include/CL/*.h
	fi

	# Documentation
	dodoc ${NV_DOC}/XF86Config.sample
	dohtml ${NV_DOC}/html/*
	if use x86-fbsd; then
		dodoc "${NV_DOC}/README"
		doman "${NV_MAN}/nvidia-xconfig.1"
		doman "${NV_MAN}/nvidia-settings.1"
	else
		# Docs
		newdoc "${NV_DOC}/README.txt" README
		dodoc "${NV_DOC}/NVIDIA_Changelog"
		doman "${NV_MAN}/nvidia-xconfig.1.gz"
		doman "${NV_MAN}/nvidia-settings.1.gz"
	fi

	# Helper Apps
	exeinto /opt/bin/
	doexe ${NV_EXEC}/nvidia-xconfig
	doexe ${NV_EXEC}/nvidia-bug-report.sh
	if use tools; then
		doexe usr/bin/nvidia-settings
	fi
	if use kernel_linux; then
		doexe ${NV_EXEC}/nvidia-smi
	fi

	# Desktop entry for nvidia-settings
	if use tools && use kernel_linux; then
		sed -e 's:__UTILS_PATH__:/opt/bin:' \
			-e 's:__PIXMAP_PATH__:/usr/share/pixmaps:' \
			-e '/^Categories/s|Application;||g' \
			-i "${S}"/usr/share/applications//nvidia-settings.desktop
		newmenu "${S}"/usr/share/applications/nvidia-settings.desktop \
			nvidia-settings-opt.desktop
	fi

	if has_multilib_profile ; then
		local OABI=${ABI}
		for ABI in $(get_install_abis) ; do
			src_install-libs
		done
		ABI=${OABI}
		unset OABI
	else
		src_install-libs
	fi

	is_final_abi || die "failed to iterate through all ABIs"

	readme.gentoo_create_doc
}

# Install nvidia library:
# the first parameter is the place where to install it
# the second parameter is the base name of the library
# the third parameter is the provided soversion
donvidia() {
	dodir $1
	exeinto $1

	libname=$(basename $2)

	doexe $2.$3
	dosym ${libname}.$3 $1/${libname}
	[[ $3 != "1" ]] && dosym ${libname}.$3 $1/${libname}.1
}

src_install-libs() {
	local inslibdir=$(get_libdir)
	local NV_ROOT="/usr/${inslibdir}/opengl/nvidia"
	local libdir= sover=

	if use kernel_linux; then
		if has_multilib_profile && [[ ${ABI} == "x86" ]] ; then
			libdir=usr/lib32
		else
			libdir=usr/lib
		fi
		sover=${PV}
	else
		libdir=obj
		# on FreeBSD it has just .1 suffix
		sover=1
	fi

	# The GLX libraries
	donvidia ${NV_ROOT}/lib ${libdir}/libGL.so ${sover}
	donvidia ${NV_ROOT}/lib ${libdir}/libGLcore.so ${sover}
	if use x86-fbsd; then
		donvidia ${NV_ROOT}/lib ${libdir}/libnvidia-tls.so ${sover}
	else
		donvidia ${NV_ROOT}/lib ${libdir}/tls/libnvidia-tls.so ${sover}
	fi

	#cuda
	if [[ -f ${libdir}/libcuda.so.${sover} ]]; then
		dolib.so ${libdir}/libcuda.so.${sover}
		[[ "${sover}" != "1" ]] && dosym libcuda.so.${sover} /usr/${inslibdir}/libcuda.so.1
		dosym libcuda.so.1 /usr/${inslibdir}/libcuda.so
	fi

	#vdpau
	if [[ -f ${libdir}/libvdpau_nvidia.so.${sover} ]]; then
		dolib.so ${libdir}/libvdpau_nvidia.so.${sover}
		dosym libvdpau_nvidia.so.${sover} /usr/${inslibdir}/libvdpau_nvidia.so
	fi

	# OpenCL
	# NOTE: This isn't currently available in the publicly released drivers.
	if [[ -f ${libdir}/libOpenCL.so.1.0.0 ]]; then

		dolib.so ${libdir}/libnvcompiler.so.${sover}
		[[ "${sover}" != "1" ]] && dosym libnvcompiler.so.${sover} /usr/${inslibdir}/libnvcompiler.so.1
		dosym libnvcompiler.so.1 /usr/${inslibdir}/libnvcompiler.so

		dolib.so ${libdir}/libOpenCL.so.1.0.0
		dosym libOpenCL.so.1.0.0 /usr/${inslibdir}/libOpenCL.so.1
		dosym libOpenCL.so.1 /usr/${inslibdir}/libOpenCL.so
	fi
}

pkg_preinst() {
	if use kernel_linux; then
		linux-mod_pkg_preinst

		local videogroup="$(egetent group video | cut -d ':' -f 3)"
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
	if [ -d "${ROOT}"/usr/lib/opengl/nvidia ] ; then
		rm -rf "${ROOT}"/usr/lib/opengl/nvidia/*
	fi
	# Make sure we nuke the old nvidia-glx's env.d file
	if [ -e "${ROOT}"/etc/env.d/09nvidia ] ; then
		rm -f "${ROOT}"/etc/env.d/09nvidia
	fi
}

pkg_postinst() {
	use kernel_linux && linux-mod_pkg_postinst

	# Switch to the nvidia implementation
	"${ROOT}"/usr/bin/eselect opengl set --use-old nvidia

	readme.gentoo_print_elog

	if ! use tools; then
		elog "USE=tools controls whether the nvidia-settings application"
		elog "is installed. If you would like to use it, enable that"
		elog "flag and re-emerge this ebuild. Optionally you can install"
		elog "media-video/nvidia-settings"
	fi
}

pkg_prerm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
}

pkg_postrm() {
	use kernel_linux && linux-mod_pkg_postrm
	"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
}
