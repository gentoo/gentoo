# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/virtualbox/virtualbox-4.3.28.ebuild,v 1.3 2015/06/14 11:53:19 zlogene Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime flag-o-matic java-pkg-opt-2 linux-info multilib pax-utils python-single-r1 qt4-r2 toolchain-funcs udev

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=VirtualBox-${MY_PV}
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2
	http://dev.gentoo.org/~polynomial-c/${PN}/patchsets/${PN}-4.3.16-patches-01.tar.xz"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Family of powerful x86 virtualization products for enterprise as well as home use"
HOMEPAGE="http://www.virtualbox.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+additions alsa doc extensions headless java pam pulseaudio +opengl python +qt4 +sdk +udev vboxwebsrv vnc"

RDEPEND="!app-emulation/virtualbox-bin
	~app-emulation/virtualbox-modules-${PV}
	dev-libs/libIDL
	>=dev-libs/libxslt-1.1.19
	net-misc/curl
	dev-libs/openssl:0=
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/libvpx
	sys-libs/zlib
	!headless? (
		qt4? (
			dev-qt/qtgui:4
			dev-qt/qtcore:4
			opengl? ( dev-qt/qtopengl:4 )
			x11-libs/libXinerama
		)
		opengl? ( virtual/opengl media-libs/freeglut )
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXt
		media-libs/libsdl:0[X,video]
	)

	java? ( || ( virtual/jre:1.7 virtual/jre:1.6 ) )
	udev? ( >=virtual/udev-171 )
	vnc? ( >=net-libs/libvncserver-0.9.9 )"
DEPEND="${RDEPEND}
	>=dev-util/kbuild-0.1.9998_pre20131130
	>=dev-lang/yasm-0.6.2
	sys-devel/bin86
	sys-power/iasl
	pam? ( sys-libs/pam )
	sys-libs/libcap
	doc? (
		dev-texlive/texlive-basic
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-fontsextra
	)
	java? ( || ( virtual/jdk:1.7 virtual/jdk:1.6 ) )
	virtual/pkgconfig
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	!headless? ( x11-libs/libXinerama )
	pulseaudio? ( media-sound/pulseaudio )
	vboxwebsrv? ( net-libs/gsoap[-gnutls(-)] )
	${PYTHON_DEPS}"
PDEPEND="additions? ( ~app-emulation/virtualbox-additions-${PV} )
	extensions? ( =app-emulation/virtualbox-extpack-oracle-${PV}* )"

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
	usr/lib/virtualbox/VBoxPython2_4.so
	usr/lib/virtualbox/VBoxPython2_5.so
	usr/lib/virtualbox/VBoxPython2_6.so
	usr/lib/virtualbox/VBoxPython2_7.so
	usr/lib/virtualbox/VBoxXPCOMC.so
	usr/lib/virtualbox/VBoxOGLhostcrutil.so
	usr/lib/virtualbox/VBoxNetDHCP.so
	usr/lib/virtualbox/VBoxNetNAT.so"

REQUIRED_USE="
	java? ( sdk )
	python? (
		( sdk )
	)
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
}

src_prepare() {
	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -rf kBuild/bin tools

	# Disable things unused or split into separate ebuilds
	sed -e "s@MY_LIBDIR@$(get_libdir)@" \
		"${FILESDIR}"/${PN}-4-localconfig > LocalConfig.kmk || die

	# Respect LDFLAGS
	sed -e "s@_LDFLAGS\.${ARCH}*.*=@& ${LDFLAGS}@g" \
		-i Config.kmk src/libs/xpcom18a4/Config.kmk || die

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
		EPATCH_EXCLUDE="050_${PN}-4.3.14-nopie.patch"
	fi

	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/patches"

	epatch_user
}

src_configure() {
	local myconf
	use alsa       || myconf+=" --disable-alsa"
	use doc        || myconf+=" --disable-docs"
	use java       || myconf+=" --disable-java"
	use opengl     || myconf+=" --disable-opengl"
	use pulseaudio || myconf+=" --disable-pulse"
	use python     || myconf+=" --disable-python"
	use vboxwebsrv && myconf+=" --enable-webservice"
	use vnc        && myconf+=" --enable-vnc"
	if ! use headless ; then
		use qt4 || myconf+=" --disable-qt4"
	else
		myconf+=" --build-headless --disable-opengl"
	fi
	if use amd64 && ! has_multilib_profile ; then
		myconf+=" --disable-vmmraw"
	fi
	# not an autoconf script
	./configure \
		--with-gcc="$(tc-getCC)" \
		--with-g++="$(tc-getCXX)" \
		--disable-kmods \
		--disable-dbus \
		--disable-devmapper \
		${myconf} \
		|| die "configure failed"
}

src_compile() {
	source ./env.sh

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	# and strip all flags
	# strip-flags

	MAKEJOBS=$(echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+')
	MAKELOAD=$(echo ${MAKEOPTS} | egrep -o '(\-l|\-\-load-average)(=?|[[:space:]]*)[[:digit:]]+')
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

	# Create configuration files
	insinto /etc/vbox
	newins "${FILESDIR}/${PN}-4-config" vbox.cfg

	# Set the right libdir
	sed -i \
		-e "s@MY_LIBDIR@$(get_libdir)@" \
		"${D}"/etc/vbox/vbox.cfg || die "vbox.cfg sed failed"

	# Symlink binaries to the shipped wrapper
	exeinto /usr/$(get_libdir)/${PN}
	newexe "${FILESDIR}/${PN}-ose-3-wrapper" "VBox"
	fowners root:vboxusers /usr/$(get_libdir)/${PN}/VBox
	fperms 0750 /usr/$(get_libdir)/${PN}/VBox

	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxManage
	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxVRDP
	dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxHeadless
	dosym /usr/$(get_libdir)/${PN}/VBoxTunctl /usr/bin/VBoxTunctl

	# Install binaries and libraries
	insinto /usr/$(get_libdir)/${PN}
	doins -r components

	if use sdk ; then
		doins -r sdk
	fi

	if use vboxwebsrv ; then
		doins vboxwebsrv
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/vboxwebsrv
		fperms 0750 /usr/$(get_libdir)/${PN}/vboxwebsrv
		dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/vboxwebsrv
		newinitd "${FILESDIR}"/vboxwebsrv-initd vboxwebsrv
		newconfd "${FILESDIR}"/vboxwebsrv-confd vboxwebsrv
	fi

	local gcfiles="*gc"
	if use amd64 && ! has_multilib_profile ; then
		gcfiles=""
	fi

	for each in VBox{Manage,SVC,XPCOMIPCD,Tunctl,ExtPackHelperApp} *so *r0 ${gcfiles} ; do
		doins ${each}
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/${each}
		fperms 0750 /usr/$(get_libdir)/${PN}/${each}
	done

	# VBoxNetAdpCtl and VBoxNetDHCP binaries need to be suid root in any case..
	for each in VBoxNet{AdpCtl,DHCP,NAT} ; do
		doins ${each}
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/${each}
		fperms 4750 /usr/$(get_libdir)/${PN}/${each}
	done

	# VBoxSVC and VBoxManage need to be pax-marked (bug #403453)
	# VBoxXPCOMIPCD (bug #524202)
	for each in VBox{Manage,SVC,XPCOMIPCD} ; do
		pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/${each} || die
	done

	if ! use headless ; then
		for each in VBox{SDL,Headless} ; do
			doins ${each}
			fowners root:vboxusers /usr/$(get_libdir)/${PN}/${each}
			fperms 4750 /usr/$(get_libdir)/${PN}/${each}
			pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/${each}
		done

		if use opengl && use qt4 ; then
			doins VBoxTestOGL
			fowners root:vboxusers /usr/$(get_libdir)/${PN}/VBoxTestOGL
			fperms 0750 /usr/$(get_libdir)/${PN}/VBoxTestOGL
			pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/VBoxTestOGL
		fi

		dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VBoxSDL

		if use qt4 ; then
			doins VirtualBox
			fowners root:vboxusers /usr/$(get_libdir)/${PN}/VirtualBox
			fperms 4750 /usr/$(get_libdir)/${PN}/VirtualBox
			pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/VirtualBox \
				|| die

			dosym /usr/$(get_libdir)/${PN}/VBox /usr/bin/VirtualBox

			newmenu "${FILESDIR}"/${PN}-ose.desktop-2 ${PN}.desktop
		fi

		pushd "${S}"/src/VBox/Resources/OSE &>/dev/null || die
		for size in 16 32 48 64 128 ; do
			newicon -s ${size} ${PN}-${size}px.png ${PN}.png
		done
		newicon ${PN}-48px.png ${PN}.png
		popd &>/dev/null || die
	else
		doins VBoxHeadless
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/VBoxHeadless
		fperms 4750 /usr/$(get_libdir)/${PN}/VBoxHeadless
		pax-mark -m "${D}"/usr/$(get_libdir)/${PN}/VBoxHeadless || die
	fi

	insinto /usr/$(get_libdir)/${PN}
	# Install EFI Firmware files (bug #320757)
	pushd "${S}"/src/VBox/Devices/EFI/FirmwareBin &>/dev/null || die
	for fwfile in VBoxEFI{32,64}.fd ; do
		doins ${fwfile}
		fowners root:vboxusers /usr/$(get_libdir)/${PN}/${fwfile}
	done
	popd &>/dev/null || die

	if use udev ; then
		# New way of handling USB device nodes for VBox (bug #356215)
		local udevdir="$(get_udevdir)"
		insinto ${udevdir}
		doins VBoxCreateUSBNode.sh
		fowners root:vboxusers ${udevdir}/VBoxCreateUSBNode.sh
		fperms 0750 ${udevdir}/VBoxCreateUSBNode.sh
		insinto ${udevdir}/rules.d
		doins "${FILESDIR}"/10-virtualbox.rules
		sed "s@%UDEVDIR%@${udevdir}@" \
			-i "${D}"${udevdir}/rules.d/10-virtualbox.rules || die
	fi

	insinto /usr/share/${PN}
	if ! use headless && use qt4 ; then
		doins -r nls
	fi

	# VRDPAuth only works with this (bug #351949)
	dosym VBoxAuth.so  /usr/$(get_libdir)/${PN}/VRDPAuth.so

	# set an env-variable for 3rd party tools
	echo -n "VBOX_APP_HOME=/usr/$(get_libdir)/${PN}" > "${T}/90virtualbox"
	doenvd "${T}/90virtualbox"

	if use java ; then
		java-pkg_regjar "${D}/usr/$(get_libdir)/${PN}/sdk/bindings/xpcom/java/vboxjxpcom.jar"
		java-pkg_regso "${D}/usr/$(get_libdir)/${PN}/libvboxjxpcom.so"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	if use udev ; then
		udevadm control --reload-rules \
			&& udevadm trigger --subsystem-match=usb
	fi

	if ! use headless && use qt4 ; then
		elog "To launch VirtualBox just type: \"VirtualBox\"."
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
