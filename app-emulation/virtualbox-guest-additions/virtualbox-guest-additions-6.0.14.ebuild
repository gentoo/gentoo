# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod systemd user toolchain-funcs

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P="VirtualBox-${MY_PV}"
DESCRIPTION="VirtualBox kernel modules and user-space tools for Gentoo guests"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~polynomial-c/virtualbox/patchsets/virtualbox-6.0.0_beta2-patches-01.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="
	X? ( x11-apps/xrandr
		x11-apps/xrefresh
		x11-libs/libXmu
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM
		x11-libs/libICE )
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
	>=dev-util/kbuild-0.1.9998.3127
	>=dev-lang/yasm-0.6.2
	sys-devel/bin86
	sys-libs/pam
	sys-power/iasl
	x11-base/xorg-proto
"
PDEPEND="
	X? ( x11-drivers/xf86-video-vboxvideo )
"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"

S="${WORKDIR}/${MY_P}"
VBOX_MOD_SRC_DIR="${S}/out/linux.${ARCH}/release/bin/additions/src"

pkg_setup() {
	export DISTCC_DISABLE=1 #674256
	MODULE_NAMES="vboxguest(misc:${VBOX_MOD_SRC_DIR}/vboxguest:${VBOX_MOD_SRC_DIR}/vboxguest)
		vboxsf(misc:${VBOX_MOD_SRC_DIR}/vboxsf:${VBOX_MOD_SRC_DIR}/vboxsf)"
	use X && MODULE_NAMES+=" vboxvideo(misc:${VBOX_MOD_SRC_DIR}/vboxvideo::${VBOX_MOD_SRC_DIR}/vboxvideo)"

	linux-mod_pkg_setup
	BUILD_PARAMS="KERN_DIR=/lib/modules/${KV_FULL}/build KERNOUT=${KV_OUT_DIR}"
}

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -r kBuild/bin tools || die

	# Provide kernel sources
	pushd src/VBox/Additions &>/dev/null || die
	ebegin "Extracting guest kernel module sources"
	kmk GuestDrivers-src vboxguest-src vboxsf-src vboxvideo-src &>/dev/null || die
	eend
	popd &>/dev/null || die

	# PaX fixes (see bug #298988)
	pushd "${VBOX_MOD_SRC_DIR}" &>/dev/null || die
	eapply "${FILESDIR}"/vboxguest-6.0.6-log-use-c99.patch
	popd &>/dev/null || die

	# Disable things unused or splitted into separate ebuilds
	cp "${FILESDIR}/${PN}-5-localconfig" LocalConfig.kmk || die
	use X || echo "VBOX_WITH_X11_ADDITIONS :=" >> LocalConfig.kmk

	# Remove pointless GCC version check
	sed -e '/^check_gcc$/d' -i configure || die

	rm "${WORKDIR}/patches/010_virtualbox-5.2.12-qt511.patch" || die
	eapply "${WORKDIR}/patches"

	eapply_user
}

src_configure() {
	# build the user-space tools, warnings are harmless
	local cmd=(
		./configure
		--nofatal
		--disable-xpcom
		--disable-sdl-ttf
		--disable-pulse
		--disable-alsa
		--with-gcc="$(tc-getCC)"
		--with-g++="$(tc-getCXX)"
		--target-arch=${ARCH}
		--with-linux="${KV_OUT_DIR}"
		--build-headless
	)
	echo "${cmd[@]}"
	"${cmd[@]}" || die "configure failed"
	source ./env.sh
	export VBOX_GCC_OPT="${CFLAGS} ${CPPFLAGS}"
}

src_compile() {
	MAKE="kmk" \
	emake TOOL_YASM_AS=yasm \
	VBOX_ONLY_ADDITIONS=1 \
	KBUILD_VERBOSE=2

	# Now creating the kernel modules. We must do this _after_
	# we compiled the user-space tools as we need two of the
	# automatically generated header files. (>=3.2.0)
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	cd "${S}"/out/linux.${ARCH}/release/bin/additions || die

	insinto /sbin
	newins mount.vboxsf mount.vboxsf
	fperms 4755 /sbin/mount.vboxsf

	newinitd "${FILESDIR}"/${PN}-8.initd ${PN}

	insinto /usr/sbin/
	newins VBoxService vboxguest-service
	fperms 0755 /usr/sbin/vboxguest-service

	insinto /usr/bin
	doins VBoxControl
	fperms 0755 /usr/bin/VBoxControl

	# VBoxClient user service and xrandr wrapper
	if use X ; then
		doins VBoxClient
		fperms 0755 /usr/bin/VBoxClient

		pushd "${S}"/src/VBox/Additions/x11/Installer &>/dev/null \
			|| die
		newins 98vboxadd-xclient VBoxClient-all
		fperms 0755 /usr/bin/VBoxClient-all
		popd &>/dev/null || die
	fi

	# udev rule for vboxdrv
	local udev_rules_dir="/lib/udev/rules.d"
	dodir ${udev_rules_dir}
	echo 'KERNEL=="vboxguest", OWNER="vboxguest", GROUP="vboxguest", MODE="0660"' \
		>> "${ED}/${udev_rules_dir}/60-virtualbox-guest-additions.rules" \
		|| die
	echo 'KERNEL=="vboxuser", OWNER="vboxguest", GROUP="vboxguest", MODE="0660"' \
		>> "${ED}/${udev_rules_dir}/60-virtualbox-guest-additions.rules" \
		|| die

	# VBoxClient autostart file
	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/vboxclient.desktop

	# sample xorg.conf
	dodoc "${FILESDIR}"/xorg.conf.vbox
	docompress -x "${ED}"/usr/share/doc/${PF}/xorg.conf.vbox

	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_preinst() {
	enewgroup vboxguest
	enewuser vboxguest -1 /bin/sh /dev/null vboxguest
	# automount Error: VBoxServiceAutoMountWorker: Group "vboxsf" does not exist
	enewgroup vboxsf
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if ! use X ; then
		elog "use flag X is off, enable it to install the"
		elog "X Window System video driver."
	fi
	elog ""
	elog "Please add users to the \"vboxguest\" group so they can"
	elog "benefit from seamless mode, auto-resize and clipboard."
	elog ""
	elog "The vboxsf group has been added to make automount services work."
	elog "These services are part of the shared folders support."
	elog ""
	elog "Please add:"
	elog "/etc/init.d/${PN}"
	elog "to the default runlevel in order to start"
	elog "needed services."
	elog "To use the VirtualBox X driver, use the following"
	elog "file as your /etc/X11/xorg.conf:"
	elog "    /usr/share/doc/${PF}/xorg.conf.vbox"
	elog ""
	elog "Also make sure you use the Mesa library for OpenGL:"
	elog "    eselect opengl set xorg-x11"
	elog ""
	elog "An autostart .desktop file has been installed to start"
	elog "VBoxClient in desktop sessions."
	elog ""
	elog "You can mount shared folders with:"
	elog "    mount -t vboxsf <shared_folder_name> <mount_point>"
	elog ""
	elog "Warning:"
	elog "this ebuild is only needed if you are running gentoo"
	elog "inside a VirtualBox Virtual Machine, you don't need"
	elog "it to run VirtualBox itself."
	elog ""
}
