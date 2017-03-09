# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils multilib python-single-r1 versionator toolchain-funcs

MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=VirtualBox-${MY_PV}
DESCRIPTION="VirtualBox X11 video driver for Gentoo guest"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.7:=[-minimal]
	x11-libs/libXcomposite"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/yasm-0.6.2
	>=dev-util/kbuild-0.1.9998_pre20131130
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
PDEPEND="dri? ( ~app-emulation/virtualbox-guest-additions-${PV} )"

REQUIRED_USE=( "${PYTHON_REQUIRED_USE}" )

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
S="${WORKDIR}/${MY_P}"
MODULES_SRC_DIR="${S}/src/VBox/Additions/linux/drm"

PATCHES=(
	# Ugly hack to build the opengl part of the video driver
	"${FILESDIR}/${PN}-2.2.0-enable-opengl.patch"

	# unset useless/problematic checks in configure
	"${FILESDIR}/${PN}-5.0.0_beta3-configure_checks.patch"

	# xorg-1.19 patch from opensuse (bug #602784)
	"${FILESDIR}/${PN}-5.1.10-xorg119.patch"
)

QA_TEXTRELS_x86="usr/lib/VBoxOGL.so"

pkg_setup() {
	if [ "${MERGE_TYPE}" != "binary" ]; then
		version_is_at_least 4.9 $(gcc-version) || die "Please set gcc 4.9 or higher as active in gcc-config to build ${PN}"
	fi

	python-single-r1_pkg_setup
}

src_prepare() {
	# Prepare the vboxvideo_drm Makefiles and build dir
	eapply "${FILESDIR}"/${PN}-5.1.4-Makefile.module.kms.patch

	# Remove shipped binaries (kBuild,yasm), see bug #232775
	rm -r kBuild/bin tools || die

	# Disable things unused or splitted into separate ebuilds
	cp "${FILESDIR}/${PN}-5-localconfig" LocalConfig.kmk || die

	# Remove pointless GCC version limitations in check_gcc()
	sed -e "/\s*-o\s*\\\(\s*\$cc_maj\s*-eq\s*[5-9]\s*-a\s*\$cc_min\s*-gt\s*[0-5]\s*\\\)\s*\\\/d" \
		-i configure || die

	default

	# link with lazy on hardened #394757
	sed '/^TEMPLATE_VBOXR3EXE_LDFLAGS.linux/s/$/ -Wl,-z,lazy/' \
		-i Config.kmk || die
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
	local each targets=(
		Runtime
		Additions/common/VBoxGuestLib
		GuestHost/OpenGL
		Additions/x11/x11stubs
		Additions/common/crOpenGL
		Additions/x11/vboxvideo
	)

	# need to use the upstream build system to create necessary objects properly
	use dri && targets+=( Additions/linux/drm )

	for each in ${targets[@]} ; do
		pushd "${S}"/src/VBox/${each} &>/dev/null || die
		MAKE="kmk" \
		emake TOOL_YASM_AS=yasm \
		VBOX_USE_SYSTEM_XORG_HEADERS=1 \
		KBUILD_PATH="${S}/kBuild" \
		KBUILD_VERBOSE=2
		popd &>/dev/null || die
	done

	if use dri; then
		local objdir="out/linux.${ARCH}/release/obj/vboxvideo_drm"
		# We need a Makefile, so use Makefile.module.kms
		ln -s Makefile.module.kms "${MODULES_SRC_DIR}"/Makefile || die
		# All of these are expected to be in $(KBUILD_EXTMOD)/ so symlink them into place
		targets=(
			include
			src/VBox/Runtime/r0drv
			src/VBox/Installer/linux/Makefile.include.{head,foot}er
			out/linux.${ARCH}/release/{product,version,revision}-generated.h
		)
		for each in ${targets[@]} ; do
			ln -s "${S}"/${each} \
				"${MODULES_SRC_DIR}"/${each##*/} || die
		done
		# see the vboxvideo_drm_SOURCES list in Makefile.kmk for the below,
		# and replace '..' with 'dt'
		targets=(
			dt/dt/common/VBoxVideo/HGSMIBase.o
			dt/dt/common/VBoxVideo/Modesetting.o
			dt/dt/common/VBoxVideo/VBVABase.o
			dt/dt/dt/GuestHost/HGSMI/HGSMICommon.o
			dt/dt/dt/GuestHost/HGSMI/HGSMIMemAlloc.o
			dt/dt/dt/Runtime/common/alloc/heapoffset.o
		)
		for each in ${targets[@]} ; do
			ln -s "${S}"/${objdir}/${each} \
				"${MODULES_SRC_DIR}" || die
			ln -s "${S}"/${objdir}/${each}.dep \
				"${MODULES_SRC_DIR}" || die
		done
	fi
}

src_install() {
	cd "${S}/out/linux.${ARCH}/release/bin/additions" || die
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
}
