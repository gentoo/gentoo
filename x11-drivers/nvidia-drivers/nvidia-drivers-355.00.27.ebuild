# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic linux-info linux-mod multilib nvidia-driver \
	portability toolchain-funcs unpacker user udev

NV_URI="http://us.download.nvidia.com/XFree86/"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"

DESCRIPTION="NVIDIA Accelerated Graphics Driver"
HOMEPAGE="http://www.nvidia.com/ http://www.nvidia.com/Download/Find.aspx"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}.run )
	x86? ( ${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run )
"

LICENSE="GPL-2 NVIDIA-r2"
SLOT="0/${PV%.*}"
KEYWORDS="-* ~amd64 ~x86 ~amd64-fbsd ~x86-fbsd"
RESTRICT="bindist fetch mirror"
EMULTILIB_PKG="true"

IUSE="acpi multilib kernel_FreeBSD kernel_linux pax_kernel +tools gtk2 gtk3 +X uvm"
REQUIRED_USE="
	tools? ( X || ( gtk2 gtk3 ) )
"

COMMON="
	app-eselect/eselect-opencl
	gtk3? ( x11-libs/cairo )
	kernel_linux? ( >=sys-libs/glibc-2.6.1 )
	X? (
		>=app-eselect/eselect-opengl-1.0.9
	)
"
DEPEND="
	${COMMON}
	app-arch/xz-utils
	kernel_linux? ( virtual/linux-sources )
"
RDEPEND="
	${COMMON}
	acpi? ( sys-power/acpid )
	tools? (
		dev-libs/atk
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		gtk2? ( >=x11-libs/gtk+-2.4:2 )
		gtk3? ( x11-libs/gtk+:3 )
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/pango[X]
	)
	X? (
		<x11-base/xorg-server-1.18.99:=
		>=x11-libs/libvdpau-1.0
		multilib? (
			>=x11-libs/libX11-1.6.2[abi_x86_32]
			>=x11-libs/libXext-1.3.2[abi_x86_32]
		)
	)
"

QA_PREBUILT="opt/* usr/lib*"

S=${WORKDIR}/

pkg_nofetch() {
	einfo "Download from https://developer.nvidia.com/vulkan-driver :"
	if use x86; then
		echo "https://developer.nvidia.com/linux32bit -> NVIDIA-Linux-x86-355.00.27.run"
	elif use amd64; then
		echo "https://developer.nvidia.com/linux64bit -> NVIDIA-Linux-x86_64-355.00.27.run"
	fi
}

pkg_pretend() {
	if use amd64 && has_multilib_profile && \
		[ "${DEFAULT_ABI}" != "amd64" ]; then
		eerror "This ebuild doesn't currently support changing your default ABI"
		die "Unexpected \${DEFAULT_ABI} = ${DEFAULT_ABI}"
	fi

	if use kernel_linux && kernel_is ge 4 3; then
		ewarn "Gentoo supports kernels which are supported by NVIDIA"
		ewarn "which are limited to the following kernels:"
		ewarn "<sys-kernel/gentoo-sources-4.3"
		ewarn "<sys-kernel/vanilla-sources-4.3"
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

	# Kernel features/options to check for
	CONFIG_CHECK="~ZONE_DMA ~MTRR ~SYSVIPC ~!LOCKDEP"
	use x86 && CONFIG_CHECK+=" ~HIGHMEM"

	# Now do the above checks
	use kernel_linux && check_extra_config
}

pkg_setup() {
	# try to turn off distcc and ccache for people that have a problem with it
	export DISTCC_DISABLE=1
	export CCACHE_DISABLE=1

	if use kernel_linux; then
		MODULE_NAMES="nvidia(video:${S}/kernel)"
		use uvm && MODULE_NAMES+=" nvidia-uvm(video:${S}/kernel)"

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
	# Please add a brief description for every added patch

	if use kernel_linux; then
		if kernel_is lt 2 6 9; then
			eerror "You must build this against 2.6.9 or higher kernels."
		fi

		# If greater than 2.6.5 use M= instead of SUBDIR=
#		convert_to_m "${NV_SRC}"/Makefile.kbuild
	fi

	if use pax_kernel; then
		ewarn "Using PAX patches is not supported. You will be asked to"
		ewarn "use a standard kernel should you have issues. Should you"
		ewarn "need support with these patches, contact the PaX team."
		epatch "${FILESDIR}"/${PN}-355.06-pax.patch
	fi

	# Allow user patches so they can support RC kernels and whatever else
	epatch_user
}

src_compile() {
	# This is already the default on Linux, as there's no toplevel Makefile, but
	# on FreeBSD there's one and triggers the kernel module build, as we install
	# it by itself, pass this.

	cd "${NV_SRC}"
	if use kernel_FreeBSD; then
		MAKE="$(get_bmake)" CFLAGS="-Wno-sign-compare" emake CC="$(tc-getCC)" \
			LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)" || die
	elif use kernel_linux; then
		MAKEOPTS=-j1
		linux-mod_src_compile
	fi
}

# Install nvidia library:
# the first parameter is the library to install
# the second parameter is the provided soversion
# the third parameter is the target directory if it is not /usr/lib
donvidia() {
	# Full path to library minus SOVER
	MY_LIB="$1"

	# SOVER to use
	MY_SOVER="$2"

	# Where to install
	MY_DEST="$3"

	if [[ -z "${MY_DEST}" ]]; then
		MY_DEST="/usr/$(get_libdir)"
		action="dolib.so"
	else
		exeinto ${MY_DEST}
		action="doexe"
	fi

	# Get just the library name
	libname=$(basename $1)

	# Install the library with the correct SOVER
	${action} ${MY_LIB}.${MY_SOVER} || \
		die "failed to install ${libname}"

	# If SOVER wasn't 1, then we need to create a .1 symlink
	if [[ "${MY_SOVER}" != "1" ]]; then
		dosym ${libname}.${MY_SOVER} \
			${MY_DEST}/${libname}.1 || \
			die "failed to create ${libname} symlink"
	fi

	# Always create the symlink from the raw lib to the .1
	dosym ${libname}.1 \
		${MY_DEST}/${libname} || \
		die "failed to create ${libname} symlink"
}

src_install() {
	if use kernel_linux; then
		linux-mod_src_install

		# Add the aliases
		# This file is tweaked with the appropriate video group in
		# pkg_preinst, see bug #491414
		insinto /etc/modprobe.d
		newins "${FILESDIR}"/nvidia-169.07 nvidia.conf
		use uvm && doins "${FILESDIR}"/nvidia-uvm.conf

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
	donvidia ${NV_OBJ}/libnvidia-cfg.so ${NV_SOVER}

	# NVIDIA framebuffer capture library
	donvidia ${NV_OBJ}/libnvidia-fbc.so ${NV_SOVER}

	# NVIDIA video encode/decode <-> CUDA
	if use kernel_linux; then
		donvidia ${NV_OBJ}/libnvcuvid.so ${NV_SOVER}
		donvidia ${NV_OBJ}/libnvidia-encode.so ${NV_SOVER}
	fi

	if use X; then
		# Xorg DDX driver
		insinto /usr/$(get_libdir)/xorg/modules/drivers
		doins ${NV_X11}/nvidia_drv.so

		# Xorg GLX driver
		donvidia ${NV_X11}/libglx.so ${NV_SOVER} \
			/usr/$(get_libdir)/opengl/nvidia/extensions

		# Xorg nvidia.conf
		if has_version '>=x11-base/xorg-server-1.16'; then
			insinto /usr/share/X11/xorg.conf.d
			newins {,50-}nvidia-drm-outputclass.conf
		fi
	fi

	# OpenCL ICD for NVIDIA
	if use kernel_linux; then
		insinto /etc/OpenCL/vendors
		doins ${NV_OBJ}/nvidia.icd
	fi

	# Documentation
	dohtml ${NV_DOC}/html/*
	if use kernel_FreeBSD; then
		dodoc "${NV_DOC}/README"
		use X && doman "${NV_MAN}/nvidia-xconfig.1"
		use tools && doman "${NV_MAN}/nvidia-settings.1"
	else
		# Docs
		newdoc "${NV_DOC}/README.txt" README
		dodoc "${NV_DOC}/NVIDIA_Changelog"
		doman "${NV_MAN}/nvidia-smi.1.gz"
		use X && doman "${NV_MAN}/nvidia-xconfig.1.gz"
		use tools && doman "${NV_MAN}/nvidia-settings.1.gz"
		doman "${NV_MAN}/nvidia-cuda-mps-control.1.gz"
	fi

	# Helper Apps
	exeinto /opt/bin/

	if use X; then
		doexe ${NV_OBJ}/nvidia-xconfig
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

		doman nvidia-cuda-mps-control.1.gz
		doman nvidia-modprobe.1.gz
		doman nvidia-persistenced.1.gz
		newinitd "${FILESDIR}/nvidia-smi.init" nvidia-smi
		newconfd "${FILESDIR}/nvidia-persistenced.conf" nvidia-persistenced
		newinitd "${FILESDIR}/nvidia-persistenced.init" nvidia-persistenced
	fi

	if use tools; then
		doexe ${NV_OBJ}/nvidia-settings
		use gtk2 && donvidia libnvidia-gtk2.so ${PV}
		use gtk3 && donvidia libnvidia-gtk3.so ${PV}
		insinto /usr/share/nvidia/
		doins nvidia-application-profiles-${PV}-key-documentation
		insinto /etc/nvidia
		newins nvidia-application-profiles-${PV}-rc nvidia-application-profiles-rc
	fi

	dobin ${NV_OBJ}/nvidia-bug-report.sh

	# Desktop entries for nvidia-settings
	if use tools; then
		# There is no icon in the FreeBSD tarball.
		use kernel_FreeBSD || newicon ${NV_OBJ}/nvidia-settings.png ${PN}-settings.png
		domenu "${FILESDIR}"/${PN}-settings.desktop
		exeinto /etc/X11/xinit/xinitrc.d
		doexe "${FILESDIR}"/95-nvidia-settings
	fi

	#doenvd "${FILESDIR}"/50nvidia-prelink-blacklist

	if has_multilib_profile && use multilib; then
		local OABI=${ABI}
		for ABI in $(get_install_abis); do
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

src_install-libs() {
	local inslibdir=$(get_libdir)
	local GL_ROOT="/usr/$(get_libdir)/opengl/nvidia/lib"
	local CL_ROOT="/usr/$(get_libdir)/OpenCL/vendors/nvidia"
	local libdir=${NV_OBJ}

	if use kernel_linux && has_multilib_profile && [[ ${ABI} == "x86" ]]; then
		libdir=${NV_OBJ}/32
	fi

	if use X; then
		NV_GLX_LIBRARIES=(
			"libEGL.so 1 ${GL_ROOT}"
			"libEGL_nvidia.so 0 ${GL_ROOT}"
			"libGL.so ${NV_SOVER} ${GL_ROOT}"
			"libGLESv1_CM.so ${NV_SOVER} ${GL_ROOT}"
			"libGLdispatch.so 0 ${GL_ROOT}"
			"libOpenCL.so 1.0.0 ${CL_ROOT}"
			"libOpenGL.so 0 ${GL_ROOT}"
			"libcuda.so ${NV_SOVER}"
			"libnvcuvid.so ${NV_SOVER}"
			"libnvidia-compiler.so ${NV_SOVER}"
			"libnvidia-eglcore.so ${NV_SOVER}"
			"libnvidia-encode.so ${NV_SOVER}"
			"libnvidia-fbc.so ${NV_SOVER}"
			"libnvidia-glcore.so ${NV_SOVER}"
			"libnvidia-glsi.so ${NV_SOVER}"
			"libnvidia-ifr.so ${NV_SOVER}"
			"libnvidia-opencl.so ${NV_SOVER}"
			"libvdpau.so ${NV_SOVER} ${GL_ROOT}"
			"libvdpau_nvidia.so ${NV_SOVER}"
			"libvdpau_trace.so ${NV_SOVER} ${GL_ROOT}"
		)
		if use kernel_linux && has_multilib_profile && [[ ${ABI} == "amd64" ]];
		then
			NV_GLX_LIBRARIES+=( "libnvidia-wfb.so ${NV_SOVER}" )
		fi

		if use kernel_FreeBSD; then
			NV_GLX_LIBRARIES+=( "libnvidia-tls.so ${NV_SOVER}" )
		fi

		if use kernel_linux; then
			NV_GLX_LIBRARIES+=(
				"libnvidia-ml.so ${NV_SOVER}"
				"tls/libnvidia-tls.so ${NV_SOVER}"
			)
		fi

		for NV_LIB in "${NV_GLX_LIBRARIES[@]}"; do
			donvidia ${libdir}/${NV_LIB}
		done

		# GLES v2 library is special
		insinto ${GL_ROOT}
		doexe ${libdir}/libGLESv2.so.${PV}
		dosym libGLESv2.so.${PV} ${GL_ROOT}/libGLESv2.so.2
		dosym libGLESv2.so.2 ${GL_ROOT}/libGLESv2.so
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
	if [ -d "${ROOT}"/usr/lib/opengl/nvidia ]; then
		rm -rf "${ROOT}"/usr/lib/opengl/nvidia/*
	fi
	# Make sure we nuke the old nvidia-glx's env.d file
	if [ -e "${ROOT}"/etc/env.d/09nvidia ]; then
		rm -f "${ROOT}"/etc/env.d/09nvidia
	fi
}

pkg_postinst() {
	use kernel_linux && linux-mod_pkg_postinst

	# Switch to the nvidia implementation
	use X && "${ROOT}"/usr/bin/eselect opengl set --use-old nvidia
	"${ROOT}"/usr/bin/eselect opencl set --use-old nvidia

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
	use X && "${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
}

pkg_postrm() {
	use kernel_linux && linux-mod_pkg_postrm
	use X && "${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
}
