# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo readme.gentoo-r1 systemd toolchain-funcs udev

MY_PN="VirtualBox"
MY_PV=${PV^^}
MY_P=${MY_PN}-${MY_PV}
PATCHES_PV="7.1.16"

DESCRIPTION="VirtualBox kernel modules and user-space tools for Gentoo guests"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2
	https://gitweb.gentoo.org/proj/virtualbox-patches.git/snapshot/virtualbox-patches-${PATCHES_PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="GPL-3 LGPL-2.1+ MIT || ( GPL-3 CDDL )"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+dbus gui"

RDEPEND="
	acct-group/vboxguest
	acct-group/vboxsf
	acct-user/vboxguest
	sys-libs/pam
	virtual/zlib:=
	~app-emulation/virtualbox-guest-modules-${PV}
	dbus? ( sys-apps/dbus )
	gui? (
		x11-apps/xrandr
		x11-apps/xrefresh
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXt
	)
"
# some libs here are indirect dependencies, and also needed at compile time.
# keeping them in DEPEND to avoid warnings from qa-vdb.
DEPEND="
	${RDEPEND}
	gui? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-base/xorg-proto
	)
"
BDEPEND="
	>=dev-lang/yasm-0.6.2
	>=dev-build/kbuild-0.1.9998.3127
	sys-devel/bin86
	sys-power/iasl
"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1.6-disable-vboxvideo-module.patch
	"${FILESDIR}"/${PN}-7.1-arm64.patch
	"${WORKDIR}/virtualbox-patches-${PATCHES_PV}/patches"
)

DOCS=()	# Don't install the default README file during einstalldocs

DOC_CONTENTS="\n
Please add users to the \"vboxguest\" group so they can\n
benefit from seamless mode, auto-resize and clipboard.\n
\n
The vboxsf group has been added to make automount services work.\n
These services are part of the shared folders support.\n
\n
Please add:\n
	/etc/init.d/virtualbox-guest-additions\n
to the default runlevel in order to start\n
needed services.\n
\n
An autostart .desktop file has been installed to start\n
VBoxClient in desktop sessions.\n
\n
You can mount shared folders with:\n
	mount -t vboxsf <shared_folder_name> <mount_point>\n
\n
Warning:\n
	this ebuild is only needed if you are running gentoo\n
	inside a VirtualBox Virtual Machine, you don't need\n
	it to run VirtualBox itself.\n
\n"

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -r kBuild/bin tools || die

	# Disable things unused or splitted into separate ebuilds
	cp "${FILESDIR}/${PN}-5-localconfig" LocalConfig.kmk || die
	if use gui; then
		echo "VBOX_NO_LEGACY_XORG_X11 := 1" >> LocalConfig.kmk || die
	else
		echo "VBOX_WITH_X11_ADDITIONS :=" >> LocalConfig.kmk || die
	fi

	# Remove pointless GCC version check
	sed -e '/ check_gcc$/d' -i configure || die

	# Respect LDFLAGS (bug #759100)
	sed -i -e '/TEMPLATE_VBoxR3Exe_LDFLAGS.linux[    ]*=/ s/$/ $(CCLDFLAGS)/' Config.kmk || die

	eapply "${PATCHES[@]}"
	eapply_user
}

src_configure() {
	tc-export AR CC CXX LD RANLIB

	# Build the user-space tools, warnings are harmless
	local myconf=(
		--with-gcc="$(tc-getCC)"
		--with-g++="$(tc-getCXX)"

		--nofatal
		--disable-xpcom
		--disable-sdl-ttf
		--disable-pulse
		--disable-alsa
		$(usev !dbus --disable-dbus)
		--target-arch=${ARCH}
		--disable-kmods
		--build-headless
	)

	# bug #843437
	# Respect LDFLAGS (bug #759100)
	# Cannot use LDFLAGS here because they also get passed to $(LD)
	cat >> LocalConfig.kmk <<-EOF || die
		CFLAGS=${CFLAGS}
		CXXFLAGS=${CXXFLAGS}
		CCLDFLAGS=${LDFLAGS}
	EOF

	edo ./configure "${myconf[@]}"
}

src_compile() {
	source ./env.sh || die

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	MAKEJOBS=$(grep -Eo '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS})
	MAKELOAD=$(grep -Eo '(\-l|\-\-load-average)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS})
	MAKEOPTS="${MAKEJOBS} ${MAKELOAD}"

	local myemakeargs=(
		VBOX_BUILD_PUBLISHER=_Gentoo
		VBOX_ONLY_ADDITIONS=1

		KBUILD_VERBOSE=2

		AS="$(tc-getCC)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LD="$(tc-getCC)"

		TOOL_GCC3_CC="$(tc-getCC)"
		TOOL_GCC3_CXX="$(tc-getCXX)"
		TOOL_GCC3_LD="$(tc-getCC)"
		TOOL_GCC3_AS="$(tc-getCC)"
		TOOL_GCC3_AR="$(tc-getAR)"
		TOOL_GCC3_OBJCOPY="$(tc-getOBJCOPY)"
		#TOOL_GCC3_LD_SYSMOD="$(tc-getCC)"

		TOOL_GXX3_CC="$(tc-getCC)"
		TOOL_GXX3_CXX="$(tc-getCXX)"
		TOOL_GXX3_LD="$(tc-getCXX)"
		TOOL_GXX3_AS="$(tc-getCXX)"
		TOOL_GXX3_AR="$(tc-getAR)"
		TOOL_GXX3_OBJCOPY="$(tc-getOBJCOPY)"
		#TOOL_GXX3_LD_SYSMOD="$(tc-getCXX)"

		TOOL_GCC3_CFLAGS="${CFLAGS}"
		TOOL_GCC3_CXXFLAGS="${CXXFLAGS}"
		VBOX_GCC_OPT="${CXXFLAGS}"
		VBOX_NM="$(tc-getNM)"
		TOOL_YASM_AS=yasm
	)

	MAKE="kmk" emake "${myemakeargs[@]}"
}

src_install() {
	cd out/linux.${ARCH}/release/bin/additions || die

	insinto /sbin
	newins mount.vboxsf mount.vboxsf
	fperms 4755 /sbin/mount.vboxsf

	if use dbus; then
		newinitd "${FILESDIR}"/${PN}-8.initd-r1 ${PN}
	else
		newinitd <(sed 's/ dbus\>//' "${FILESDIR}"/${PN}-8.initd-r1) ${PN}
	fi

	insinto /usr/sbin/
	newins VBoxService vboxguest-service
	fperms 0755 /usr/sbin/vboxguest-service

	insinto /usr/bin
	doins VBoxControl
	fperms 0755 /usr/bin/VBoxControl

	# VBoxClient user service and xrandr wrapper
	if use gui ; then
		doins VBoxClient
		fperms 0755 /usr/bin/VBoxClient
		doins VBoxDRMClient
		fperms 4755 /usr/bin/VBoxDRMClient

		pushd "${S}"/src/VBox/Additions/x11/Installer &>/dev/null || die
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

	systemd_dounit "${FILESDIR}/${PN}.service"

	readme.gentoo_create_doc
}

pkg_postinst() {
	udev_reload

	if ! use gui ; then
		elog "The use flag \"gui\" is off, enable it to install the"
		elog "X Window System drivers and integration."
	fi

	readme.gentoo_print_elog
}

pkg_postrm() {
	udev_reload
}
