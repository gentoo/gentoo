# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To add a new Python here:
# 1. Patch src/libs/xpcom18a4/python/Makefile.kmk (copy the previous impl's logic)
#    Do NOT skip this part. It'll end up silently not-building the Python extension
#    or otherwise misbehaving if you do.
#
# 2. Then update PYTHON_COMPAT & set PYTHON_SINGLE_TARGET for testing w/ USE=python.
#
#  May need to look at other distros (e.g. Arch Linux) to find patches for newer
#  Python versions as upstream tends to lag. Upstream may have patches on their
#  trunk branch but not release branch.
#
#  See bug #785835, bug #856121.
PYTHON_COMPAT=( python3_{10..11} )

inherit desktop edo flag-o-matic java-pkg-opt-2 linux-info multilib optfeature pax-utils \
	python-single-r1 tmpfiles toolchain-funcs udev xdg

PATCHES_PV="7.0.14"
ORIGIN_PN="VirtualBox"
ORIGIN_PV=${PATCHES_PV}

MY_PN=virtualbox
MY_PV=${PV#*_pre}

PATCHES_DIR="${WORKDIR}"/${PN}-${MY_PV}

DESCRIPTION="Family of powerful x86 virtualization products for enterprise and home use"
HOMEPAGE="https://www.virtualbox.org/ https://github.com/cyberus-technology/virtualbox-kvm"
SRC_URI="https://gitweb.gentoo.org/proj/virtualbox-patches.git/snapshot/virtualbox-patches-${PATCHES_PV}.tar.bz2"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3

	ORIGIN_PV=${PATCHES_PV}
	EGIT_REPO_URI="https://github.com/cyberus-technology/virtualbox-kvm"
else
	ORIGIN_PV=${PV%_pre*}
	PATCHES_DIR="${WORKDIR}"/${PN}-dev-${MY_PV}
	SRC_URI+=" https://github.com/cyberus-technology/virtualbox-kvm/archive/dev-${MY_PV}.tar.gz -> ${P}.tar.gz"
fi
MY_P=${ORIGIN_PN}-${ORIGIN_PV}
SRC_URI+="
	https://download.virtualbox.org/virtualbox/${ORIGIN_PV}/${MY_P}.tar.bz2
	gui? ( !doc? ( https://dev.gentoo.org/~ceamac/${CATEGORY}/${MY_PN}/${MY_PN}-help-${ORIGIN_PV}.tar.xz ) )
"
S="${WORKDIR}/${ORIGIN_PN}-${ORIGIN_PV}"

LICENSE="GPL-2+ GPL-3 LGPL-2.1 MIT dtrace? ( CDDL )"
SLOT="0"
IUSE="alsa dbus debug doc dtrace +gui java lvm nls pam pch pulseaudio +opengl python +sdk +sdl +udev vboxwebsrv vde vnc"

unset WATCOM #856769

COMMON_DEPEND="
	${PYTHON_DEPS}
	acct-group/vboxusers
	dev-libs/libtpms
	dev-libs/libxml2
	dev-libs/openssl:0=
	media-libs/libpng:0=
	media-libs/libvpx:0=
	net-misc/curl
	sys-libs/zlib
	dbus? ( sys-apps/dbus )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
		x11-libs/libX11
		x11-libs/libXt
		opengl? ( dev-qt/qtopengl:5 )
	)
	lvm? ( sys-fs/lvm2 )
	opengl? (
		media-libs/libglvnd[X]
		media-libs/vulkan-loader
		x11-libs/libX11
		x11-libs/libXt
	)
	pam? ( sys-libs/pam )
	sdl? (
		media-libs/libsdl2[X,video]
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXt
	)
	vboxwebsrv? ( net-libs/gsoap[-gnutls(-),debug?] )
	vde? ( net-misc/vde )
	vnc? ( >=net-libs/libvncserver-0.9.9 )
"
# We're stuck on JDK (and JRE, I guess?) 1.8 because of need for wsimport
# with USE="vboxwebsrv java". Note that we have to put things in DEPEND,
# not (only, anyway) BDEPEND, as the eclass magic to set the environment variables
# based on *DEPEND doesn't work for BDEPEND at least right now.
#
# There's a comment in Config.kmk about it
# ("With Java 11 wsimport was removed, usually part of a separate install now.")
# but it needs more investigation.
#
# See bug #878299 to track this issue.
DEPEND="
	${COMMON_DEPEND}
	>=dev-libs/libxslt-1.1.19
	virtual/libcrypt:=
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	gui? (
		x11-base/xorg-proto
		x11-libs/libxcb:=
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXmu
		x11-libs/libXrandr
	)
	java? ( virtual/jdk:1.8 )
	opengl? (
		x11-base/xorg-proto
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXmu
		x11-libs/libXrandr
		virtual/glu
	)
	sdl? ( x11-libs/libXinerama )
	pulseaudio? ( media-libs/libpulse )
	udev? ( >=virtual/udev-171 )
"
RDEPEND="
	!app-emulation/virtualbox
	${COMMON_DEPEND}
	gui? ( x11-libs/libxcb:= )
	java? ( virtual/jre:1.8 )
"
BDEPEND="
	${PYTHON_DEPS}
	>=app-arch/tar-1.34-r2
	>=dev-lang/yasm-0.6.2
	dev-libs/libIDL
	dev-util/glslang
	>=dev-build/kbuild-0.1.9998.3592
	sys-apps/which
	sys-devel/bin86
	sys-libs/libcap
	sys-power/iasl
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-dtd:4.4
		app-text/docbook-xsl-ns-stylesheets
		dev-texlive/texlive-basic
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-fontsextra
		dev-qt/qthelp:5
	)
	gui? ( dev-qt/linguist-tools:5 )
	nls? ( dev-qt/linguist-tools:5 )
	java? ( virtual/jdk:1.8 )
"

QA_FLAGS_IGNORED="
	usr/lib64/virtualbox/VBoxDDR0.r0
	usr/lib64/virtualbox/VMMR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.debug
"

QA_TEXTRELS="
	usr/lib64/virtualbox/VMMR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.r0
"

QA_EXECSTACK="
	usr/lib64/virtualbox/iPxeBaseBin
	usr/lib64/virtualbox/VMMR0.r0
	usr/lib64/virtualbox/VBoxDDR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.debug
"

QA_WX_LOAD="
	usr/lib64/virtualbox/iPxeBaseBin
"

QA_PRESTRIPPED="
	usr/lib64/virtualbox/VMMR0.r0
	usr/lib64/virtualbox/VBoxDDR0.r0
	usr/lib64/virtualbox/ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack/linux.amd64/VBoxDTraceR0.r0
"

REQUIRED_USE="
	java? ( sdk )
	python? ( sdk )
	vboxwebsrv? ( java )
	${PYTHON_REQUIRED_USE}
"

PATCHES=(
	# Downloaded patchset
	"${WORKDIR}"/virtualbox-patches-${PATCHES_PV}/patches
	"${PATCHES_DIR}"/
)

pkg_pretend() {
	if ! use gui; then
		einfo "No USE=\"gui\" selected, this build will not include any Qt frontend."
	fi

	if ! use opengl; then
		einfo "No USE=\"opengl\" selected, this build will lack"
		einfo "the OpenGL feature."
	fi
	if ! use python; then
		einfo "You have disabled the \"python\" USE flag. This will only"
		einfo "disable the python bindings being installed."
	fi
	if ! use nls && use gui; then
		einfo "USE=\"gui\" also selects USE=\"nls\".  This build"
		einfo "will have NLS support."
	fi

	# 749273
	local d=${ROOT}
	for i in usr "$(get_libdir)"; do
		d="${d}/$i"
		if [[ "$(stat -L -c "%g %u" "${d}")" != "0 0" ]]; then
			die "${d} should be owned by root, VirtualBox will not start otherwise"
		fi
	done
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	[[ ${PV} == *9999* ]] && git-r3_src_unpack
	default
}

src_prepare() {
	default

	# Only add nopie patch when we're on hardened
	if gcc-specs-pie; then
		eapply "${FILESDIR}"/050_virtualbox-5.2.8-nopie.patch
	fi

	# Remove shipped binaries (kBuild, yasm) and tools, see bug #232775
	rm -r kBuild/bin || die
	# Remove everything in tools except kBuildUnits
	find tools -mindepth 1 -maxdepth 1 -name kBuildUnits -prune -o -exec rm -r {} \+ || die

	# Disable things unused or split into separate ebuilds
	sed -e "s@MY_LIBDIR@$(get_libdir)@" \
		"${FILESDIR}"/${MY_PN}-5-localconfig > LocalConfig.kmk || die

	if ! use pch; then
		# bug #753323
		printf '\n%s\n' "VBOX_WITHOUT_PRECOMPILED_HEADERS=1" \
			>> LocalConfig.kmk || die
	fi

	# bug #916002, #488176
	tc-ld-force-bfd

	# Respect LDFLAGS
	sed -e "s@_LDFLAGS\.${ARCH}*.*=@& ${LDFLAGS}@g" \
		-i Config.kmk src/libs/xpcom18a4/Config.kmk || die

	# Do not use hard-coded ld (related to bug #488176)
	sed -e '/QUIET)ld /s@ld @$(LD) @' \
		-i src/VBox/Devices/PC/ipxe/Makefile.kmk || die

	# Use PAM only when pam USE flag is enbaled (bug #376531)
	if ! use pam; then
		einfo "Disabling PAM removes the possibility to use the VRDP features."
		sed -i 's@^.*VBOX_WITH_PAM@#VBOX_WITH_PAM@' Config.kmk || die
		sed -i 's@\(.*/auth/Makefile.kmk.*\)@#\1@' \
			src/VBox/HostServices/Makefile.kmk || die
		echo -e "\nIPRT_WITHOUT_PAM=1" >> LocalConfig.kmk || die
	fi

	# add correct java path
	if use java; then
		sed "s@/usr/lib/jvm/java-6-sun@$(java-config -O)@" \
			-i "${S}"/Config.kmk || die
		java-pkg-opt-2_src_prepare
	fi

	#856811 #864274
	# cannot filter out only one flag, some combinations of these flags produce buggy executables
	for i in abm avx avx2 bmi bmi2 fma fma4 popcnt; do
		append-cflags $(test-flags-CC -mno-$i)
		append-cxxflags $(test-flags-CXX -mno-$i)
	done

	# bug #908814
	filter-lto

	# bug #843437
	cat >> LocalConfig.kmk <<-EOF || die
		CXXFLAGS=${CXXFLAGS}
		CFLAGS=${CFLAGS}
	EOF

	if use sdl; then
		sed -i 's/sdl-config/sdl2-config/' configure || die
		echo -e "\nVBOX_WITH_VBOXSDL=1" >> LocalConfig.kmk || die
	fi

	#443830
	echo -e "\nVBOX_WITH_VBOX_IMG=1" >> LocalConfig.kmk || die

	if tc-is-clang; then
		# clang assembler chokes on comments starting with /
		sed -i -e '/^\//d' src/libs/xpcom18a4/nsprpub/pr/src/md/unix/os_Linux_x86_64.s || die

		# clang does not support this extension
		eapply "${FILESDIR}"/${MY_PN}-7.0.8-disable-rebuild-iPxeBiosBin.patch
	fi

	# fix doc generation
	echo -e "\nVBOX_PATH_DOCBOOK=/usr/share/sgml/docbook/xsl-ns-stylesheets" >> LocalConfig.kmk || die
	# replace xhtml names with numeric equivalents
	find doc/manual -name \*.xml -exec sed -i \
		-e 's/&nbsp;/\&#160;/g' \
		-e 's/&ndash;/\&#8211;/g' \
		-e 's/&larr;/\&#8592;/g' \
		-e 's/&rarr;/\&#8594;/g' \
		-e 's/&harr;/\&#8596;/g' {} \+ || die

	# fix help path #891879
	echo -e "\nVBOX_PATH_PACKAGE_DOCS=/usr/share/doc/${PF}" >> LocalConfig.kmk || die

	# 489208
	# Cannot patch the whole text, many translations.  Use sed instead to replace the command
	find src/VBox/Frontends/VirtualBox/nls -name \*.ts -exec sed -i \
		's/&apos;[^&]*\(vboxdrv setup\|vboxconfig\)&apos;/\&apos;emerge -1 virtualbox-modules\&apos;/' {} \+ || die
	sed -i "s:'/sbin/vboxconfig':'emerge -1 virtualbox-modules':" \
		src/VBox/Frontends/VirtualBox/src/main.cpp \
		src/VBox/VMM/VMMR3/VM.cpp || die

	# 890561
	echo -e "\nVBOX_GTAR=gtar" >> LocalConfig.kmk || die

	if ! use nls && ! use gui; then
		cat >> LocalConfig.kmk <<-EOF || die
			VBOX_WITH_NLS :=
			VBOX_WITH_MAIN_NLS :=
			VBOX_WITH_PUEL_NLS :=
			VBOX_WITH_VBOXMANAGE_NLS :=
		EOF
	fi
}

src_configure() {
	tc-export AR CC CXX LD RANLIB
	export HOST_CC="$(tc-getBUILD_CC)"

	local myconf=(
		--with-gcc="$(tc-getCC)"
		--with-g++="$(tc-getCXX)"

		--disable-kmods
		--with-kvm

		# this is required for kvm to work.
		# also this prohibits installation with suid.
		--disable-hardening

		$(usev !alsa --disable-alsa)
		$(usev !dbus --disable-dbus)
		$(usev debug --build-debug)
		$(usev !doc --disable-docs)
		$(usev !java --disable-java)
		$(usev !lvm --disable-devmapper)
		$(usev !pulseaudio --disable-pulse)
		$(usev !python --disable-python)
		$(usev vboxwebsrv --enable-webservice)
		$(usev vde --enable-vde)
		$(usev vnc --enable-vnc)
	)

	if use gui || use sdl || use opengl; then
		myconf+=(
			$(usev !opengl --disable-opengl)
			$(usev !gui --disable-qt)
			$(usev !sdl --disable-sdl)
		)
	else
		myconf+=(
			--build-headless
		)
	fi

	if use amd64 && ! has_multilib_profile; then
		myconf+=( --disable-vmmraw )
	fi

	# not an autoconf script
	edo ./configure "${myconf[@]}"

	# Force usage of chosen Python implementation
	# bug #856121, bug #785835
	sed -i \
		-e '/VBOX_WITH_PYTHON.*=/d' \
		-e '/VBOX_PATH_PYTHON_INC.*=/d' \
		-e '/VBOX_LIB_PYTHON.*=/d' \
		AutoConfig.kmk || die

	cat >> AutoConfig.kmk <<-EOF || die
		VBOX_WITH_PYTHON=$(usev python 1)
		VBOX_PATH_PYTHON_INC=$(python_get_includedir)
		VBOX_LIB_PYTHON=$(python_get_library_path)
	EOF

	if use python; then
		local mangled_python="${EPYTHON#python}"
		mangled_python="${mangled_python/.}"

		# Stub out the script which defines what the Makefile ends up
		# building for. gen_python_deps.py gets called by the Makefile
		# with some args and it spits out a bunch of paths for a hardcoded
		# list of Pythons. We just override it with what we're actually using.
		# This minimises the amount of patching we have to do for new Pythons.
		cat > src/libs/xpcom18a4/python/gen_python_deps.py <<-EOF || die
			print("VBOX_PYTHON${mangled_python}_INC=$(python_get_includedir)")
			print("VBOX_PYTHON${mangled_python}_LIB=$(python_get_library_path)")
			print("VBOX_PYTHONDEF_INC=$(python_get_includedir)")
			print("VBOX_PYTHONDEF_LIB=$(python_get_library_path)")
		EOF

		chmod +x src/libs/xpcom18a4/python/gen_python_deps.py || die
	fi
}

src_compile() {
	source ./env.sh || die

	# Force kBuild to respect C[XX]FLAGS and MAKEOPTS (bug #178529)
	MAKEJOBS=$(grep -Eo '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS})
	MAKELOAD=$(grep -Eo '(\-l|\-\-load-average)(=?|[[:space:]]*)[[:digit:]]+' <<< ${MAKEOPTS})
	MAKEOPTS="${MAKEJOBS} ${MAKELOAD}"

	local myemakeargs=(
		VBOX_BUILD_PUBLISHER=_Gentoo
		VBOX_WITH_VBOXIMGMOUNT=1

		KBUILD_VERBOSE=2

		AS="$(tc-getCC)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"

		TOOL_GCC3_CC="$(tc-getCC)"
		TOOL_GCC3_LD="$(tc-getCC)"
		TOOL_GCC3_AS="$(tc-getCC)"
		TOOL_GCC3_AR="$(tc-getAR)"
		TOOL_GCC3_OBJCOPY="$(tc-getOBJCOPY)"

		TOOL_GXX3_CC="$(tc-getCC)"
		TOOL_GXX3_CXX="$(tc-getCXX)"
		TOOL_GXX3_LD="$(tc-getCXX)"
		TOOL_GXX3_AS="$(tc-getCXX)"
		TOOL_GXX3_AR="$(tc-getAR)"
		TOOL_GXX3_OBJCOPY="$(tc-getOBJCOPY)"

		TOOL_GCC3_CFLAGS="${CFLAGS}"
		TOOL_GCC3_CXXFLAGS="${CXXFLAGS}"
		VBOX_GCC_OPT="${CXXFLAGS}"
		VBOX_NM="$(tc-getNM)"

		TOOL_YASM_AS=yasm
	)

	if use amd64 && has_multilib_profile; then
		myemakeargs+=(
			CC32="$(tc-getCC) -m32"
			CXX32="$(tc-getCXX) -m32"

			TOOL_GCC32_CC="$(tc-getCC) -m32"
			TOOL_GCC32_CXX="$(tc-getCXX) -m32"
			TOOL_GCC32_LD="$(tc-getCC) -m32"
			TOOL_GCC32_AS="$(tc-getCC) -m32"
			TOOL_GCC32_AR="$(tc-getAR)"
			TOOL_GCC32_OBJCOPY="$(tc-getOBJCOPY)"

			TOOL_GXX32_CC="$(tc-getCC) -m32"
			TOOL_GXX32_CXX="$(tc-getCXX) -m32"
			TOOL_GXX32_LD="$(tc-getCXX) -m32"
			TOOL_GXX32_AS="$(tc-getCXX) -m32"
			TOOL_GXX32_AR="$(tc-getAR)"
			TOOL_GXX32_OBJCOPY="$(tc-getOBJCOPY)"
		)
	fi

	MAKE="kmk" emake "${myemakeargs[@]}" all
}

src_install() {
	cd "${S}"/out/linux.${ARCH}/$(usex debug debug release)/bin || die

	local vbox_inst_path="/usr/$(get_libdir)/${MY_PN}" each size ico icofile

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
	newins "${FILESDIR}/${MY_PN}-4-config" vbox.cfg

	# Set the correct libdir
	sed \
		-e "s@MY_LIBDIR@$(get_libdir)@" \
		-i "${ED}"/etc/vbox/vbox.cfg || die "vbox.cfg sed failed"

	# Install the wrapper script
	exeinto ${vbox_inst_path}
	newexe "${FILESDIR}/${MY_PN}-ose-6-wrapper" "VBox"
	fowners root:vboxusers ${vbox_inst_path}/VBox
	fperms 0750 ${vbox_inst_path}/VBox

	# Install binaries and libraries
	insinto ${vbox_inst_path}
	doins -r components

	for each in VBox{Autostart,BalloonCtrl,BugReport,CpuReport,ExtPackHelperApp,Manage,SVC,VMMPreload,XPCOMIPCD} \
		vboximg-mount vbox-img *so *r0; do
		vbox_inst ${each}
	done

	# These binaries need to be suid root.
	for each in VBox{Headless,Net{AdpCtl,DHCP,NAT}} ; do
		vbox_inst ${each} 0750
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
	for each in vbox{autostart,balloonctrl,bugreport,headless,manage} \
		VBox{Autostart,BalloonCtrl,BugReport,Headless,Manage,VRDP} ; do
			dosym ${vbox_inst_path}/VBox /usr/bin/${each}
	done
	dosym ${vbox_inst_path}/vboximg-mount /usr/bin/vboximg-mount
	dosym ${vbox_inst_path}/vbox-img /usr/bin/vbox-img

	if use pam; then
		# VRDPAuth only works with this (bug #351949)
		dosym VBoxAuth.so ${vbox_inst_path}/VRDPAuth.so
	fi

	# set an env-variable for 3rd party tools
	echo "VBOX_APP_HOME=${vbox_inst_path}" > "${T}/90virtualbox"
	# environment variables used during SDK binding installation
	echo "VBOX_SDK_PATH=${vbox_inst_path}/sdk" >> "${T}/90virtualbox"
	echo "VBOX_INSTALL_PATH=${vbox_inst_path}" >> "${T}/90virtualbox"
	doenvd "${T}/90virtualbox"

	if use sdl; then
		vbox_inst VBoxSDL 0750
		pax-mark -m "${ED}"${vbox_inst_path}/VBoxSDL

		for each in vboxsdl VBoxSDL ; do
			dosym ${vbox_inst_path}/VBox /usr/bin/${each}
		done
	fi

	if use gui; then
		vbox_inst VirtualBox
		vbox_inst VirtualBoxVM 0750
		for each in VirtualBox{,VM} ; do
			pax-mark -m "${ED}"${vbox_inst_path}/${each}
		done

		if use opengl; then
			vbox_inst VBoxTestOGL
			pax-mark -m "${ED}"${vbox_inst_path}/VBoxTestOGL
		fi

		for each in virtualbox{,vm} VirtualBox{,VM} ; do
			dosym ${vbox_inst_path}/VBox /usr/bin/${each}
		done

		insinto /usr/share/${PN}
		doins -r nls
		doins -r UnattendedTemplates

		newmenu ${MY_PN}.desktop ${PN}.desktop

		pushd "${S}"/src/VBox/Artwork/OSE &>/dev/null || die
		for size in 16 32 48 64 128 ; do
			newicon -s ${size} ${MY_PN}-${size}px.png ${PN}.png
		done
		newicon ${MY_PN}-48px.png ${PN}.png
		newicon -s scalable ${MY_PN}.svg ${PN}.png
		popd &>/dev/null || die
		pushd "${S}"/src/VBox/Artwork/other &>/dev/null || die
		for size in 16 24 32 48 64 72 96 128 256 512 ; do
			for ico in hdd ova ovf vbox{,-extpack} vdi vdh vmdk ; do
				icofile="${MY_PN}-${ico}-${size}px.png"
				if [[ -f "${icofile}" ]]; then
					newicon -s ${size} ${icofile} ${MY_PN}-${ico}.png
				fi
			done
		done
		popd &>/dev/null || die
	fi

	if use lvm; then
		vbox_inst VBoxVolInfo 0750
		dosym ${vbox_inst_path}/VBoxVolInfo /usr/bin/VBoxVolInfo
	fi

	if use sdk; then
		insinto ${vbox_inst_path}
		doins -r sdk

		if use java; then
			java-pkg_regjar "${ED}/${vbox_inst_path}/sdk/bindings/xpcom/java/vboxjxpcom.jar"
			java-pkg_regso "${ED}/${vbox_inst_path}/libvboxjxpcom.so"
		fi
	fi

	if use udev; then
		local udevdir="$(get_udevdir)"
		local udev_file="VBoxCreateUSBNode.sh"
		local rules_file="10-virtualbox.rules"

		insinto ${udevdir}
		doins ${udev_file}
		fowners root:vboxusers ${udevdir}/${udev_file}
		fperms 0750 ${udevdir}/${udev_file}

		insinto ${udevdir}/rules.d
		sed "s@%UDEVDIR%@${udevdir}@" "${FILESDIR}"/${rules_file} \
			> "${T}"/${rules_file} || die
		doins "${T}"/${rules_file}
	fi

	if use vboxwebsrv; then
		vbox_inst vboxwebsrv
		dosym ${vbox_inst_path}/VBox /usr/bin/vboxwebsrv
		newinitd "${FILESDIR}"/vboxwebsrv-initd vboxwebsrv
		newconfd "${FILESDIR}"/vboxwebsrv-confd vboxwebsrv
	fi

	# Remove dead symlinks (bug #715338)
	find "${ED}"/usr/$(get_libdir)/${MY_PN} -xtype l -delete || die

	# Fix version string in extensions or else they don't get accepted
	# by the virtualbox host process (see bug #438930)
	find ExtensionPacks -type f -name "ExtPack.xml" -exec sed -i '/Version/s@_Gentoo@@' {} \+ || die

	local extensions_dir="${vbox_inst_path}/ExtensionPacks"

	if use vnc; then
		insinto ${extensions_dir}
		doins -r ExtensionPacks/VNC
	fi

	if use dtrace; then
		insinto ${extensions_dir}
		doins -r ExtensionPacks/Oracle_VBoxDTrace_Extension_Pack
	fi

	if use doc; then
		dodoc UserManual.pdf UserManual.q{ch,hc}
		docompress -x /usr/share/doc/${PF}/UserManual.*
	elif use gui; then
		dodoc "${WORKDIR}"/${MY_PN}-help-${ORIGIN_PV}/UserManual.q{ch,hc}
		docompress -x /usr/share/doc/${PF}/UserManual.*
	fi
	dodoc ${PATCHES_DIR}/README.*

	if use python; then
		local python_path_ext="${ED}/usr/$(get_libdir)/virtualbox/VBoxPython3.so"
		if [[ ! -x "${python_path_ext}" ]]; then
			eerror "Couldn't find ${python_path_ext}! Bindings were requested with USE=python"
			eerror "but none were installed. This may happen if support for a Python target"
			eerror "(listed in PYTHON_COMPAT in the ebuild) is incomplete within the Makefiles."
			die "Incomplete installation of Python bindings! File a bug with Gentoo!"
		fi

		# 378871
		local installer_dir="${ED}/usr/$(get_libdir)/virtualbox/sdk/installer"
		pushd "${installer_dir}" &> /dev/null || die
		sed -e "s;%VBOX_INSTALL_PATH%;${vbox_inst_path};" \
			-e "s;%VBOX_SDK_PATH%;${vbox_inst_path}/sdk;" \
			-i vboxapi/__init__.py || die
		# insert shebang, the files come without one
		find vboxapi -name \*.py -exec sed -e "1 i\#! ${PYTHON}" -i {} \+ || die
		python_domodule vboxapi
		popd &> /dev/null || die
		python_doscript vboxshell.py

		# do not install the installer
		rm -r "${installer_dir}" || die
	fi

	newtmpfiles "${FILESDIR}"/${MY_PN}-vboxusb_tmpfilesd virtualbox-vboxusb.conf
}

pkg_postinst() {
	xdg_pkg_postinst

	if use udev; then
		udev_reload
		udevadm trigger --subsystem-match=usb
	fi

	tmpfiles_process virtualbox-vboxusb.conf

	if use gui; then
		elog "To launch VirtualBox just type: \"virtualbox\"."
	fi

	elog "You must be in the vboxusers group to use VirtualBox."
	elog ""
	elog "The latest user manual is available for download at:"
	elog "https://download.virtualbox.org/virtualbox/${ORIGIN_PV}/UserManual.pdf"
	elog ""

	optfeature "Advanced networking setups" net-misc/bridge-utils sys-apps/usermode-utilities
	optfeature "USB2, USB3, PXE boot, and VRDP support" app-emulation/virtualbox-extpack-oracle
	optfeature "Guest additions ISO" app-emulation/virtualbox-additions

	if ! use udev; then
		ewarn "Without USE=udev, USB devices will likely not work in ${MY_PN}."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm

	use udev && udev_reload
}
