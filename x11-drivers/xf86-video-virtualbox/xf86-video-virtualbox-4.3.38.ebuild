# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils linux-mod multilib python-single-r1 versionator toolchain-funcs

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=VirtualBox-${MY_PV}
DESCRIPTION="VirtualBox video driver"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.7:=[-minimal]
	x11-libs/libXcomposite"
DEPEND="${RDEPEND}
	>=dev-util/kbuild-0.1.9998_pre20131130
	${PYTHON_DEPS}
	>=dev-lang/yasm-0.6.2
	>=sys-devel/gcc-4.9.0
	sys-power/iasl
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/resourceproto
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	x11-libs/libXdmcp
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXext
	dri? (  x11-proto/xf86driproto
		>=x11-libs/libdrm-2.4.5 )"

REQUIRED_USE=( "${PYTHON_REQUIRED_USE}" )

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="vboxvideo(misc:${WORKDIR}/vboxvideo_drm:${WORKDIR}/vboxvideo_drm)"

S="${WORKDIR}/${MY_P}"

QA_TEXTRELS_x86="usr/lib/VBoxOGL.so"

pkg_setup() {
	if [ "${MERGE_TYPE}" != "binary" ]; then
		version_is_at_least 4.9 $(gcc-version) || die "Please set gcc 4.9 or higher as active in gcc-config to build ${PN}"
	fi

	linux-mod_pkg_setup
	BUILD_PARAMS="KERN_DIR=${KV_OUT_DIR} KERNOUT=${KV_OUT_DIR}"

	python-single-r1_pkg_setup
}

src_prepare() {
	# Prepare the vboxvideo_drm sources and Makefile in ${WORKDIR}
	cp -a "${S}"/src/VBox/Additions/linux/drm "${WORKDIR}/vboxvideo_drm" \
		|| die "cannot copy vboxvideo_drm directory"
	cp "${FILESDIR}/${PN}-3-vboxvideo_drm.makefile" \
		"${WORKDIR}/vboxvideo_drm/Makefile" \
			|| die "cannot copy vboxvideo_drm Makefile"

	# stupid new header references...
	for vboxheader in {product,version}-generated.h ; do
		ln -sf "${S}"/out/linux.${ARCH}/release/${vboxheader} \
			"${WORKDIR}/vboxvideo_drm/${vboxheader}"
	done

	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -rf kBuild/bin tools

	# Remove pointless GCC version limitations in check_gcc()
	sed -e "/\s*-o\s*\\\(\s*\$cc_maj\s*-eq\s*[5-9]\s*-a\s*\$cc_min\s*-gt\s*[0-5]\s*\\\)\s*\\\/d" \
		-i configure || die

	# Disable things unused or splitted into separate ebuilds
	cp "${FILESDIR}/${PN}-3-localconfig" LocalConfig.kmk || die

	# Ugly hack to build the opengl part of the video driver
	epatch "${FILESDIR}/${PN}-2.2.0-enable-opengl.patch"

	# unset useless/problematic checks in configure
	epatch "${FILESDIR}/${PN}-3.2.8-mesa-check.patch" \
		"${FILESDIR}/${PN}-4-makeself-check.patch" \
		"${FILESDIR}/${PN}-4-mkisofs-check.patch"

	# link with lazy on hardened #394757
	sed -i '/^TEMPLATE_VBOXR3EXE_LDFLAGS.linux/s/$/ -Wl,-z,lazy/' Config.kmk || die
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
	for each in /src/VBox/{Runtime,Additions/common/VBoxGuestLib} \
		/src/VBox/{GuestHost/OpenGL,Additions/x11/x11stubs,Additions/common/crOpenGL} \
		/src/VBox/Additions/x11/vboxvideo ; do
			cd "${S}"${each} || die
			MAKE="kmk" \
			emake TOOL_YASM_AS=yasm \
			VBOX_USE_SYSTEM_XORG_HEADERS=1 \
			KBUILD_PATH="${S}/kBuild" \
			KBUILD_VERBOSE=2
	done

	if use dri ; then
		# Now creating the kernel modules. We must do this _after_
		# we compiled the user-space tools as we need two of the
		# automatically generated header files. (>=3.2.0)
		linux-mod_src_compile
	fi
}

src_install() {
	if use dri; then
		linux-mod_src_install
	fi

	cd "${S}/out/linux.${ARCH}/release/bin/additions"
	insinto /usr/$(get_libdir)/xorg/modules/drivers
	newins vboxvideo_drv_system.so vboxvideo_drv.so

	# Guest OpenGL driver
	insinto /usr/$(get_libdir)
	doins -r VBoxOGL*

	if use dri ; then
		dosym /usr/$(get_libdir)/VBoxOGL.so \
			/usr/$(get_libdir)/dri/vboxvideo_dri.so
	fi
}

pkg_postinst() {
	elog "You need to edit the file /etc/X11/xorg.conf and set:"
	elog ""
	elog "  Driver  \"vboxvideo\""
	elog ""
	elog "in the Graphics device section (Section \"Device\")"
	elog ""
	if use dri; then
		elog "To use the kernel drm video driver, please add:"
		elog "\"vboxvideo\" to:"
		if has_version sys-apps/openrc ; then
			elog "/etc/conf.d/modules"
		else
			elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
		fi
		elog ""
	fi
}
