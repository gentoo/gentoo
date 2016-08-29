# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime flag-o-matic java-pkg-opt-2 linux-info multilib pax-utils python-single-r1 toolchain-funcs udev

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=VirtualBox-${MY_PV}
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~polynomial-c/${PN}/patchsets/${PN}-5.0.16-patches-01.tar.xz"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Family of powerful x86 virtualization products for enterprise and home use"
HOMEPAGE="http://www.virtualbox.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa doc headless java libressl lvm pam pulseaudio +opengl python +qt4 +sdk +udev vboxwebsrv vnc"

RDEPEND="!app-emulation/virtualbox-bin
	~app-emulation/virtualbox-modules-${PV}
	dev-libs/libIDL
	>=dev-libs/libxslt-1.1.19
	net-misc/curl
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/libvpx:0=
	sys-libs/zlib
	!headless? (
		media-libs/libsdl:0[X,video]
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXt
		opengl? ( virtual/opengl media-libs/freeglut )
		qt4? (
			dev-qt/qtgui:4
			dev-qt/qtcore:4
			opengl? ( dev-qt/qtopengl:4 )
			x11-libs/libXinerama
		)
	)
	java? ( >=virtual/jre-1.6:= )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	lvm? ( sys-fs/lvm2 )
	udev? ( >=virtual/udev-171 )
	vnc? ( >=net-libs/libvncserver-0.9.9 )"
DEPEND="${RDEPEND}
	>=dev-util/kbuild-0.1.9998_pre20131130
	>=dev-lang/yasm-0.6.2
	sys-devel/bin86
	sys-libs/libcap
	sys-power/iasl
	virtual/pkgconfig
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	doc? (
		dev-texlive/texlive-basic
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-fontsextra
	)
	!headless? ( x11-libs/libXinerama )
	java? ( >=virtual/jre-1.6:= )
	pam? ( sys-libs/pam )
	pulseaudio? ( media-sound/pulseaudio )
	vboxwebsrv? ( net-libs/gsoap[-gnutls(-)] )
	${PYTHON_DEPS}"

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

REQUIRED_USE="
	java? ( sdk )
	python? ( sdk )
	vboxwebsrv? ( java )
	${PYTHON_REQUIRED_USE}
"

pkg_setup() {
	if ! use headless && ! use qt4 ; then
		einfo "No USE=\"qt4\" selected, this build will not include"
		einfo "any Qt frontend."
	elif use headless && use qt4 ; then
		einfo "You selected USE=\"headless qt4\", defaulting to"
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
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup

	tc-ld-disable-gold #bug 488176
	tc-export CC CXX LD AR RANLIB
	export HOST_CC="$(tc-getBUILD_CC)"
}

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -r kBuild/bin tools || die

	# Remove pointless GCC version limitations in check_gcc()
	sed -e "/\s*-o\s*\\\(\s*\$cc_maj\s*-eq\s*[5-9]\s*-a\s*\$cc_min\s*-gt\s*[0-5]\s*\\\)\s*\\\/d" \
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

	if ! gcc-specs-pie ; then
		rm "${WORKDIR}/patches/050_${PN}-5.0.2-nopie.patch" || die
	fi

	eapply "${WORKDIR}/patches"

	eapply_user
}

src_configure() {
	local myconf
	use alsa       || myconf+=( --disable-alsa )
	use doc        || myconf+=( --disable-docs )
	use java       || myconf+=( --disable-java )
	use lvm        || myconf+=( --disable-devmapper )
	use opengl     || myconf+=( --disable-opengl )
	use pulseaudio || myconf+=( --disable-pulse )
	use python     || myconf+=( --disable-python )
	use vboxwebsrv && myconf+=( --enable-webservice )
	use vnc        && myconf+=( --enable-vnc )
	if ! use headless ; then
		use qt4 || myconf+=( --disable-qt4 )
	else
		myconf+=( --build-headless --disable-opengl )
	fi
	if use amd64 && ! has_multilib_profile ; then
		myconf+=( --disable-vmmraw )
	fi
	# not an autoconf script
	./configure \
		--with-gcc="$(tc-getCC)" \
		--with-g++="$(tc-getCXX)" \
		--disable-dbus \
		--disable-kmods \
		${myconf[@]} \
		|| die "configure failed"
}

src_compile() {
	source ./env.sh || die

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	# and strip all flags
	# strip-flags

	MAKEJOBS=$(echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+')
	MAKELOAD=$(echo ${MAKEOPTS} | egrep -o '(\-l|\-\-load-average)(=?|[[:space:]]*)[[:digit:]]+') #'
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
	cd "${S}"/out/linux.${ARCH}/release/bin || die

	local vbox_inst_path="/usr/$(get_libdir)/${PN}" each fwfile

	vbox_inst() {
		local binary="${1}"
		local perms="${2:-0750}"
		local path="${3:-${vbox_inst_path}}"

		[[ -n "${binary}" ]] || die "vbox_inst: No binray given!"
		[[ ${perms} =~ ^[[:digit:]]+{4}$ ]] || die "vbox_inst: perms must consist of four digits."

		insinto ${path}
		doins ${binary}
		fowners root:vboxusers ${path}/${binary}
		fperms ${perms} ${path}/${binary}
	}

	# Create configuration files
	insinto /etc/vbox
	newins "${FILESDIR}/${PN}-4-config" vbox.cfg

	# Set the right libdir
	sed -i \
		-e "s@MY_LIBDIR@$(get_libdir)@" \
		"${D}"/etc/vbox/vbox.cfg || die "vbox.cfg sed failed"

	# Install the wrapper script
	exeinto ${vbox_inst_path}
	newexe "${FILESDIR}/${PN}-ose-5-wrapper" "VBox"
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
	for each in VBox{ExtPackHelperApp,Manage,SVC,Tunctl,XPCOMIPCD} *so *r0 ${rcfiles} ; do
		vbox_inst ${each}
	done

	# These binaries need to be suid root in any case.
	for each in VBox{Headless,Net{AdpCtl,DHCP,NAT}} ; do
		vbox_inst ${each} 4750
	done

	# Install EFI Firmware files (bug #320757)
	pushd "${S}"/src/VBox/Devices/EFI/FirmwareBin &>/dev/null || die
	for fwfile in VBoxEFI{32,64}.fd ; do
		vbox_inst ${fwfile} 0644
	done
	popd &>/dev/null || die

	# VBoxSVC and VBoxManage need to be pax-marked (bug #403453)
	# VBoxXPCOMIPCD (bug #524202)
	for each in VBox{Headless,Manage,SVC,XPCOMIPCD} ; do
		pax-mark -m "${D}"${vbox_inst_path}/${each}
	done

	# Symlink binaries to the shipped wrapper
	for each in vbox{headless,manage} VBox{Headless,Manage,VRDP} ; do
		dosym ${vbox_inst_path}/VBox /usr/bin/${each}
	done
	dosym ${vbox_inst_path}/VBoxTunctl /usr/bin/VBoxTunctl

	# VRDPAuth only works with this (bug #351949)
	dosym VBoxAuth.so ${vbox_inst_path}/VRDPAuth.so

	# set an env-variable for 3rd party tools
	echo -n "VBOX_APP_HOME=${vbox_inst_path}" > "${T}/90virtualbox"
	doenvd "${T}/90virtualbox"

	if ! use headless ; then
		vbox_inst VBoxSDL 4750
		pax-mark -m "${D}"${vbox_inst_path}/VBoxSDL

		for each in vboxsdl VBoxSDL ; do
			dosym ${vbox_inst_path}/VBox /usr/bin/${each}
		done

		if use opengl && use qt4 ; then
			vbox_inst VBoxTestOGL
			pax-mark -m "${D}"${vbox_inst_path}/VBoxTestOGL
		fi

		if use qt4 ; then
			vbox_inst VirtualBox 4750
			pax-mark -m "${D}"${vbox_inst_path}/VirtualBox

			for each in virtualbox VirtualBox ; do
				dosym ${vbox_inst_path}/VBox /usr/bin/${each}
			done

			insinto /usr/share/${PN}
			doins -r nls

			newmenu "${FILESDIR}"/${PN}-ose.desktop-2 ${PN}.desktop
		fi

		pushd "${S}"/src/VBox/Artwork/OSE &>/dev/null || die
		for size in 16 32 48 64 128 ; do
			newicon -s ${size} ${PN}-${size}px.png ${PN}.png
		done
		newicon ${PN}-48px.png ${PN}.png
		doicon -s scalable ${PN}.svg
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
			java-pkg_regjar "${D}${vbox_inst_path}/sdk/bindings/xpcom/java/vboxjxpcom.jar"
			java-pkg_regso "${D}${vbox_inst_path}/libvboxjxpcom.so"
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
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	if use udev ; then
		udevadm control --reload-rules \
			&& udevadm trigger --subsystem-match=usb
	fi

	if ! use headless && use qt4 ; then
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
	elog "IMPORTANT!"
	elog "If you upgrade from app-emulation/virtualbox-ose make sure to run"
	elog "\"env-update\" as root and logout and relogin as the user you wish"
	elog "to run ${PN} as."
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
	elif [ -e "${ROOT}/etc/udev/rules.d/10-virtualbox.rules" ] ; then
		elog ""
		elog "Please remove \"${ROOT}/etc/udev/rules.d/10-virtualbox.rules\""
		elog "or else USB in ${PN} won't work."
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
