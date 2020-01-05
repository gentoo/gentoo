# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
inherit desktop flag-o-matic java-pkg-opt-2 linux-info pax-utils python-single-r1 tmpfiles toolchain-funcs udev xdg

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=VirtualBox-${MY_PV}

DESCRIPTION="Family of powerful x86 virtualization products for enterprise and home use"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~polynomial-c/${PN}/patchsets/${PN}-6.0.0_beta2-patches-01.tar.xz"

LICENSE="GPL-2 dtrace? ( CDDL )"
SLOT="0"
[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug doc dtrace headless java libressl lvm +opus pam pax_kernel pulseaudio +opengl python +qt5 +sdk +udev vboxwebsrv vnc"

CDEPEND="
	${PYTHON_DEPS}
	!app-emulation/virtualbox-bin
	~app-emulation/virtualbox-modules-${PV}
	dev-libs/libIDL
	>=dev-libs/libxslt-1.1.19
	net-misc/curl
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/libvpx:0=
	sys-libs/zlib:=
	!headless? (
		media-libs/libsdl:0[X,video]
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXt
		opengl? ( virtual/opengl media-libs/freeglut )
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtprintsupport:5
			dev-qt/qtwidgets:5
			dev-qt/qtx11extras:5
			opengl? ( dev-qt/qtopengl:5 )
			x11-libs/libXinerama
		)
	)
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	lvm? ( sys-fs/lvm2 )
	opus? ( media-libs/opus )
	udev? ( >=virtual/udev-171 )
	vnc? ( >=net-libs/libvncserver-0.9.9 )
"
DEPEND="
	${CDEPEND}
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	!headless? ( x11-libs/libXinerama )
	pam? ( sys-libs/pam )
	pax_kernel? ( sys-apps/elfix )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? ( dev-qt/linguist-tools:5 )
	vboxwebsrv? ( net-libs/gsoap[-gnutls(-)] )
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/kbuild-0.1.9998.3127
	>=dev-lang/yasm-0.6.2
	sys-devel/bin86
	sys-libs/libcap
	sys-power/iasl
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-dtd:4.4
		dev-texlive/texlive-basic
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-fontsextra
	)
	java? ( >=virtual/jdk-1.6 )
"
RDEPEND="
	${CDEPEND}
	java? ( >=virtual/jre-1.6 )
"

QA_TEXTRELS_x86="usr/lib/virtualbox-ose/VBoxGuestPropSvc.so
	usr/lib/virtualbox/VBoxSDL.so
	usr/lib/virtualbox/VBoxSharedFolders.so
	usr/lib/virtualbox/VBoxDD2.so
	usr/lib/virtualbox/VBoxOGLrenderspu.so
	usr/lib/virtualbox/VBoxPython.so
	usr/lib/virtualbox/VBoxDD.so
	usr/lib/virtualbox/VBoxDDU.so
	usr/lib/virtualbox/VBoxREM64.so
	usr/lib/virtualbox/VBoxSharedClipboard.so
	usr/lib/virtualbox/VBoxHeadless.so
	usr/lib/virtualbox/VBoxRT.so
	usr/lib/virtualbox/VBoxREM.so
	usr/lib/virtualbox/VBoxSettings.so
	usr/lib/virtualbox/VBoxKeyboard.so
	usr/lib/virtualbox/VBoxSharedCrOpenGL.so
	usr/lib/virtualbox/VBoxVMM.so
	usr/lib/virtualbox/VirtualBox.so
	usr/lib/virtualbox/VBoxOGLhosterrorspu.so
	usr/lib/virtualbox/components/VBoxC.so
	usr/lib/virtualbox/components/VBoxSVCM.so
	usr/lib/virtualbox/components/VBoxDDU.so
	usr/lib/virtualbox/components/VBoxRT.so
	usr/lib/virtualbox/components/VBoxREM.so
	usr/lib/virtualbox/components/VBoxVMM.so
	usr/lib/virtualbox/VBoxREM32.so
	usr/lib/virtualbox/VBoxPython2_7.so
	usr/lib/virtualbox/VBoxXPCOMC.so
	usr/lib/virtualbox/VBoxOGLhostcrutil.so
	usr/lib/virtualbox/VBoxNetDHCP.so
	usr/lib/virtualbox/VBoxNetNAT.so"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	java? ( sdk )
	python? ( sdk )
	vboxwebsrv? ( java )
	${PYTHON_REQUIRED_USE}
"

pkg_pretend() {
	if ! use headless && ! use qt5 ; then
		einfo "No USE=\"qt5\" selected, this build will not include any Qt frontend."
	elif use headless && use qt5 ; then
		einfo "You selected USE=\"headless qt5\", defaulting to"
		einfo "USE=\"headless\", this build will not include any X11/Qt frontend."
	fi

	if ! use opengl ; then
		einfo "No USE=\"opengl\" selected, this build will lack"
		einfo "the OpenGL feature."
	fi
	if ! use python ; then
		einfo "You have disabled the \"python\" USE flag. This will only"
		einfo "disable the python bindings being installed."
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup

	tc-ld-disable-gold #bug 488176
	tc-export CC CXX LD AR RANLIB
	export HOST_CC="$(tc-getBUILD_CC)"
}

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -r kBuild/bin tools || die

	# Replace pointless GCC version check with something less stupid.
	# This is needed for the qt5 version check.
	sed -e 's@^check_gcc$@cc_maj="$(gcc -dumpversion | cut -d. -f1)" ; cc_min="$(gcc -dumpversion | cut -d. -f2)"@' \
		-i configure || die

	# Disable things unused or split into separate ebuilds
	sed -e "s@MY_LIBDIR@$(get_libdir)@" \
		"${FILESDIR}"/${PN}-5-localconfig > LocalConfig.kmk || die

	# Respect LDFLAGS
	sed -e "s@_LDFLAGS\.${ARCH}*.*=@& ${LDFLAGS}@g" \
		-i Config.kmk src/libs/xpcom18a4/Config.kmk || die

	# Do not use hard-coded ld (related to bug #488176)
	sed -e '/QUIET)ld /s@ld @$(LD) @' \
		-i src/VBox/Devices/PC/ipxe/Makefile.kmk || die

	# Use PAM only when pam USE flag is enbaled (bug #376531)
	if ! use pam ; then
		elog "Disabling PAM removes the possibility to use the VRDP features."
		sed -i 's@^.*VBOX_WITH_PAM@#VBOX_WITH_PAM@' Config.kmk || die
		sed -i 's@\(.*/auth/Makefile.kmk.*\)@#\1@' \
			src/VBox/HostServices/Makefile.kmk || die
	fi

	# add correct java path
	if use java ; then
		sed "s@/usr/lib/jvm/java-6-sun@$(java-config -O)@" \
			-i "${S}"/Config.kmk || die
		java-pkg-opt-2_src_prepare
	fi

	# Only add nopie patch when we're on hardened
	if gcc-specs-pie ; then
		eapply "${FILESDIR}/050_virtualbox-5.2.8-nopie.patch"
	fi

	# Only add paxmark patch when we're on pax_kernel
	if use pax_kernel ; then
		eapply "${FILESDIR}"/virtualbox-5.2.8-paxmark-bldprogs.patch
	fi

	rm "${WORKDIR}/patches/010_virtualbox-5.2.12-qt511.patch" || die
	eapply "${WORKDIR}/patches"

	eapply_user
}

doecho() {
	echo "$@"
	"$@" || die
}

src_configure() {
	local myconf=(
		--with-gcc="$(tc-getCC)"
		--with-g++="$(tc-getCXX)"
		--disable-dbus
		--disable-kmods
		$(usex alsa '' --disable-alsa)
		$(usex debug --build-debug '')
		$(usex doc '' --disable-docs)
		$(usex java '' --disable-java)
		$(usex lvm '' --disable-devmapper)
		$(usex opus '' --disable-libopus)
		$(usex pulseaudio '' --disable-pulse)
		$(usex python '' --disable-python)
		$(usex vboxwebsrv --enable-webservice '')
		$(usex vnc --enable-vnc '')
	)
	if ! use headless ; then
		myconf+=(
			$(usex opengl '' --disable-opengl)
			$(usex qt5 '' --disable-qt)
		)
	else
		myconf+=(
			--build-headless
			--disable-opengl
		)
	fi
	if use amd64 && ! has_multilib_profile ; then
		myconf+=( --disable-vmmraw )
	fi
	# not an autoconf script
	doecho ./configure ${myconf[@]}
}

src_compile() {
	source ./env.sh || die

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	MAKEJOBS=$(grep -Eo '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS}) #'
	MAKELOAD=$(grep -Eo '(\-l|\-\-load-average)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS}) #'
	MAKEOPTS="${MAKEJOBS} ${MAKELOAD}"
	MAKE="kmk" emake \
		VBOX_BUILD_PUBLISHER=_Gentoo \
		TOOL_GCC3_CC="$(tc-getCC)" TOOL_GCC3_CXX="$(tc-getCXX)" \
		TOOL_GCC3_AS="$(tc-getCC)" TOOL_GCC3_AR="$(tc-getAR)" \
		TOOL_GCC3_LD="$(tc-getCXX)" TOOL_GCC3_LD_SYSMOD="$(tc-getLD)" \
		TOOL_GCC3_CFLAGS="${CFLAGS}" TOOL_GCC3_CXXFLAGS="${CXXFLAGS}" \
		VBOX_GCC_OPT="${CXXFLAGS}" \
		TOOL_YASM_AS=yasm KBUILD_VERBOSE=2 \
		all
}

src_install() {
	cd "${S}"/out/linux.${ARCH}/$(usex debug debug release)/bin || die

	local vbox_inst_path="/usr/$(get_libdir)/${PN}" each size ico icofile

	vbox_inst() {
		local binary="${1}"
		local perms="${2:-0750}"
		local path="${3:-${vbox_inst_path}}"

		[[ -n "${binary}" ]] || die "vbox_inst: No binary given!"
		[[ ${perms} =~ ^[[:digit:]]+{4}$ ]] || die "vbox_inst: perms must consist of four digits."

		insinto ${path}
		doins ${binary}
		fowners root:vboxusers ${path}/${binary}
		fperms ${perms} ${path}/${binary}
	}

	# Create configuration files
	insinto /etc/vbox
	newins "${FILESDIR}/${PN}-4-config" vbox.cfg

	# Set the correct libdir
	sed \
		-e "s@MY_LIBDIR@$(get_libdir)@" \
		-i "${ED}"/etc/vbox/vbox.cfg || die "vbox.cfg sed failed"

	# Install the wrapper script
	exeinto ${vbox_inst_path}
	newexe "${FILESDIR}/${PN}-ose-6-wrapper" "VBox"
	fowners root:vboxusers ${vbox_inst_path}/VBox
	fperms 0750 ${vbox_inst_path}/VBox

	# Install binaries and libraries
	insinto ${vbox_inst_path}
	doins -r components

	# *.rc files for x86_64 are only available on multilib systems
	local rcfiles="*.rc"
	if use amd64 && ! has_multilib_profile ; then
		rcfiles=""
	fi
	for each in VBox{Autostart,BalloonCtrl,BugReport,CpuReport,ExtPackHelperApp,Manage,SVC,Tunctl,VMMPreload,XPCOMIPCD} *so *r0 ${rcfiles} iPxeBaseBin ; do
		vbox_inst ${each}
	done

	# These binaries need to be suid root.
	for each in VBox{Headless,Net{AdpCtl,DHCP,NAT}} ; do
		vbox_inst ${each} 4750
	done

	# Install EFI Firmware files (bug #320757)
	for each in VBoxEFI{32,64}.fd ; do
		vbox_inst ${each} 0644
	done

	# VBoxSVC and VBoxManage need to be pax-marked (bug #403453)
	# VBoxXPCOMIPCD (bug #524202)
	for each in VBox{Headless,Manage,SVC,XPCOMIPCD} ; do
		pax-mark -m "${ED}"${vbox_inst_path}/${each}
	done

	# Symlink binaries to the shipped wrapper
	for each in vbox{autostart,balloonctrl,bugreport,headless,manage} VBox{Autostart,BalloonCtrl,BugReport,Headless,Manage,VRDP} ; do
		dosym ${vbox_inst_path}/VBox /usr/bin/${each}
	done
	dosym ${vbox_inst_path}/VBoxTunctl /usr/bin/VBoxTunctl

	if use pam ; then
		# VRDPAuth only works with this (bug #351949)
		dosym VBoxAuth.so ${vbox_inst_path}/VRDPAuth.so
	fi

	# set an env-variable for 3rd party tools
	echo -n "VBOX_APP_HOME=${vbox_inst_path}" > "${T}/90virtualbox"
	doenvd "${T}/90virtualbox"

	if ! use headless ; then
		vbox_inst rdesktop-vrdp
		vbox_inst VBoxSDL 4750
		pax-mark -m "${ED}"${vbox_inst_path}/VBoxSDL

		for each in vboxsdl VBoxSDL ; do
			dosym ${vbox_inst_path}/VBox /usr/bin/${each}
		done

		if use qt5 ; then
			vbox_inst VirtualBox
			vbox_inst VirtualBoxVM 4750
			for each in VirtualBox{,VM} ; do
				pax-mark -m "${ED}"${vbox_inst_path}/${each}
			done

			if use opengl ; then
				vbox_inst VBoxTestOGL
				pax-mark -m "${ED}"${vbox_inst_path}/VBoxTestOGL
			fi

			for each in virtualbox{,vm} VirtualBox{,VM} ; do
				dosym ${vbox_inst_path}/VBox /usr/bin/${each}
			done

			insinto /usr/share/${PN}
			doins -r nls
			doins -r UnattendedTemplates

			domenu ${PN}.desktop
		fi

		pushd "${S}"/src/VBox/Artwork/OSE &>/dev/null || die
		for size in 16 32 48 64 128 ; do
			newicon -s ${size} ${PN}-${size}px.png ${PN}.png
		done
		newicon ${PN}-48px.png ${PN}.png
		doicon -s scalable ${PN}.svg
		popd &>/dev/null || die
		pushd "${S}"/src/VBox/Artwork/other &>/dev/null || die
		for size in 16 24 32 48 64 72 96 128 256 512 ; do
			for ico in hdd ova ovf vbox{,-extpack} vdi vdh vmdk ; do
				icofile="${PN}-${ico}-${size}px.png"
				if [[ -f "${icofile}" ]] ; then
					newicon -s ${size} ${icofile} ${PN}-${ico}.png
				fi
			done
		done
		popd &>/dev/null || die
	fi

	if use lvm ; then
		vbox_inst VBoxVolInfo 4750
		dosym ${vbox_inst_path}/VBoxVolInfo /usr/bin/VBoxVolInfo
	fi

	if use sdk ; then
		insinto ${vbox_inst_path}
		doins -r sdk

		if use java ; then
			java-pkg_regjar "${ED}/${vbox_inst_path}/sdk/bindings/xpcom/java/vboxjxpcom.jar"
			java-pkg_regso "${ED}/${vbox_inst_path}/libvboxjxpcom.so"
		fi
	fi

	if use udev ; then
		# New way of handling USB device nodes for VBox (bug #356215)
		local udevdir="$(get_udevdir)"
		insinto ${udevdir}
		doins VBoxCreateUSBNode.sh
		fowners root:vboxusers ${udevdir}/VBoxCreateUSBNode.sh
		fperms 0750 ${udevdir}/VBoxCreateUSBNode.sh
		insinto ${udevdir}/rules.d
		sed "s@%UDEVDIR%@${udevdir}@" "${FILESDIR}"/10-virtualbox.rules \
			> "${T}"/10-virtualbox.rules || die
		doins "${T}"/10-virtualbox.rules
	fi

	if use vboxwebsrv ; then
		vbox_inst vboxwebsrv
		dosym ${vbox_inst_path}/VBox /usr/bin/vboxwebsrv
		newinitd "${FILESDIR}"/vboxwebsrv-initd vboxwebsrv
		newconfd "${FILESDIR}"/vboxwebsrv-confd vboxwebsrv
	fi

	# Fix version string in extensions or else they don't get accepted
	# by the virtualbox host process (see bug #438930)
	find ExtensionPacks -type f -name "ExtPack.xml" -print0 \
		| xargs --no-run-if-empty --null sed -i '/Version/s@_Gentoo@@' \
		|| die

	local extensions_dir="${vbox_inst_path}/ExtensionPacks"

	if use vnc ; then
		insinto ${extensions_dir}
		doins -r ExtensionPacks/VNC
	fi

	if use dtrace ; then
		insinto ${extensions_dir}
		doins -r ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack
	fi

	if use doc ; then
		dodoc UserManual.pdf
	fi

	newtmpfiles "${FILESDIR}"/${PN}-vboxusb_tmpfilesd ${PN}-vboxusb.conf
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst

	if use udev ; then
		udevadm control --reload-rules \
			&& udevadm trigger --subsystem-match=usb
	fi

	tmpfiles_process /usr/lib/tmpfiles.d/virtualbox-vboxusb.conf

	if ! use headless && use qt5 ; then
		elog "To launch VirtualBox just type: \"virtualbox\"."
	fi
	elog "You must be in the vboxusers group to use VirtualBox."
	elog ""
	elog "The latest user manual is available for download at:"
	elog "http://download.virtualbox.org/virtualbox/${PV}/UserManual.pdf"
	elog ""
	elog "For advanced networking setups you should emerge:"
	elog "net-misc/bridge-utils and sys-apps/usermode-utilities"
	elog ""
	elog "Starting with version 4.0.0, ${PN} has USB-1 support."
	elog "For USB-2 support, PXE-boot ability and VRDP support please emerge"
	elog "  app-emulation/virtualbox-extpack-oracle"
	elog "package."
	elog "Starting with version 5.0.0, ${PN} no longer has the \"additions\" and"
	elog "the \"extension\" USE flag. For installation of the guest additions ISO"
	elog "image, please emerge"
	elog "  app-emulation/virtualbox-additions"
	elog "and for the USB2, USB3, VRDP and PXE boot ROM modules, please emerge"
	elog "  app-emulation/virtualbox-extpack-oracle"
	if ! use udev ; then
		elog ""
		elog "WARNING!"
		elog "Without USE=udev, USB devices will likely not work in ${PN}."
	elif [[ -e "${ROOT}/etc/udev/rules.d/10-virtualbox.rules" ]] ; then
		elog ""
		elog "Please remove \"${ROOT}/etc/udev/rules.d/10-virtualbox.rules\""
		elog "or else USB in ${PN} won't work."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
