# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit optfeature python-any-r1 readme.gentoo-r1 toolchain-funcs wine

WINE_GECKO=2.47.4
WINE_MONO=10.4.1
WINE_PV=$(ver_rs 2 -)

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ValveSoftware/wine.git"
	EGIT_BRANCH="bleeding-edge"
else
	SRC_URI="https://github.com/ValveSoftware/wine/archive/refs/tags/proton-wine-${WINE_PV}.tar.gz"
	S=${WORKDIR}/${PN}-wine-${WINE_PV}
	KEYWORDS="-* ~amd64 ~x86"
fi

DESCRIPTION="Valve Software's fork of Wine"
HOMEPAGE="https://github.com/ValveSoftware/wine/"

LICENSE="
	LGPL-2.1+ BSD BSD-2 IJG MIT OPENLDAP ZLIB gsm libpng2 libtiff
	|| ( WTFPL-2 public-domain )
"
SLOT="${PV}"
IUSE="
	+X +alsa crossdev-mingw +dbus ffmpeg +fontconfig +gecko +gstreamer
	llvm-libunwind +mono nls perl pulseaudio +sdl selinux +ssl udev
	+unwind usb v4l wayland video_cards_amdgpu xinerama
"
# headless is not really supported here, and udev needs sdl due to Valve's
# changes (bug #959263), use normal wine instead if need to avoid these
REQUIRED_USE="
	|| ( X wayland )
	udev? ( sdl )
"

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	dev-libs/libgcrypt:=[${WINE_USEDEP}]
	media-libs/freetype[${WINE_USEDEP}]
	media-libs/libglvnd[X?,${WINE_USEDEP}]
	media-libs/vulkan-loader[X?,wayland?,${WINE_USEDEP}]
	X? (
		x11-libs/libXcomposite[${WINE_USEDEP}]
		x11-libs/libXcursor[${WINE_USEDEP}]
		x11-libs/libXfixes[${WINE_USEDEP}]
		x11-libs/libXi[${WINE_USEDEP}]
		x11-libs/libXrandr[${WINE_USEDEP}]
		x11-libs/libXrender[${WINE_USEDEP}]
		x11-libs/libXxf86vm[${WINE_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${WINE_USEDEP}] )
	)
	dbus? ( sys-apps/dbus[${WINE_USEDEP}] )
	fontconfig? ( media-libs/fontconfig[${WINE_USEDEP}] )
	sdl? ( media-libs/libsdl2[haptic,joystick,${WINE_USEDEP}] )
	ssl? (
		dev-libs/gmp:=[${WINE_USEDEP}]
		net-libs/gnutls:=[${WINE_USEDEP}]
	)
	v4l? ( media-libs/libv4l[${WINE_USEDEP}] )
"
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	X? (
		x11-libs/libX11[${WINE_USEDEP}]
		x11-libs/libXext[${WINE_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${WINE_USEDEP}] )
	ffmpeg? ( media-video/ffmpeg:=[${WINE_USEDEP}] )
	gstreamer? (
		dev-libs/glib:2[${WINE_USEDEP}]
		media-libs/gst-plugins-base:1.0[opengl,${WINE_USEDEP}]
		media-libs/gstreamer:1.0[${WINE_USEDEP}]
	)
	pulseaudio? ( media-libs/libpulse[${WINE_USEDEP}] )
	udev? ( virtual/libudev:=[${WINE_USEDEP}] )
	unwind? (
		llvm-libunwind? ( llvm-runtimes/libunwind[${WINE_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${WINE_USEDEP}] )
	)
	usb? ( dev-libs/libusb:1[${WINE_USEDEP}] )
	video_cards_amdgpu? ( x11-libs/libdrm[video_cards_amdgpu,${WINE_USEDEP}] )
	wayland? (
		dev-libs/wayland[${WINE_USEDEP}]
		x11-libs/libxkbcommon[${WINE_USEDEP}]
	)
"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	gecko? (
		app-emulation/wine-gecko:${WINE_GECKO}[${WINE_USEDEP}]
		wow64? ( app-emulation/wine-gecko[abi_x86_32] )
	)
	gstreamer? (
		media-libs/gst-plugins-bad:1.0[${WINE_USEDEP}]
		media-plugins/gst-plugins-libav:1.0[${WINE_USEDEP}]
		media-plugins/gst-plugins-meta:1.0[${WINE_USEDEP}]
	)
	mono? ( app-emulation/wine-mono:${WINE_MONO} )
	perl? (
		dev-lang/perl
		dev-perl/XML-LibXML
	)
	selinux? ( sec-policy/selinux-wine )
"
DEPEND="
	${WINE_COMMON_DEPEND}
	|| (
		sys-devel/gcc:*
		llvm-runtimes/compiler-rt:*[atomic-builtins(-)]
	)
	sys-kernel/linux-headers
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	wayland? ( dev-util/wayland-scanner )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	__clear_cache # unused on amd64+x86 (bug #900332)
	res_getservers # false positive
)
QA_TEXTRELS="usr/lib/*/wine/i386-unix/*.so" # uses -fno-PIC -Wl,-z,notext

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-musl.patch
	"${FILESDIR}"/${PN}-7.0.4-noexecstack.patch
	"${FILESDIR}"/${PN}-8.0.1c-unwind.patch
	"${FILESDIR}"/${PN}-8.0.4-restore-menubuilder.patch
	"${FILESDIR}"/${PN}-9.0-rpath.patch
	"${FILESDIR}"/${PN}-9.0.4-binutils2.44.patch
)

src_prepare() {
	# similarly to staging, append to `wine --version` for identification
	sed -i "s/wine_build[^1]*1/& (Proton-${WINE_PV})/" configure.ac || die

	wine_src_prepare

	# this is kind-of best effort and ignores llvm slots, ideally
	# atomic-builtins should be package.use.force then could drop this
	if tc-is-clang && [[ $(tc-get-c-rtlib) == compiler-rt ]] &&
		has_version -d 'llvm-runtimes/compiler-rt[-atomic-builtins(-)]'
	then
		# needed by Valve's fsync patches if using compiler-rt w/o atomics
		sed -e '/^UNIX_LIBS.*=/s/$/ -latomic/' \
			-i dlls/{ntdll,winevulkan}/Makefile.in || die
	fi

	# proton variant also needs specfiles and vulkan
	tools/make_specfiles || die # perl
	dlls/winevulkan/make_vulkan -X video.xml -x vk.xml || die # python
}

src_configure() {
	local wineconfargs=(
		# upstream (Valve) doesn't really support misc configurations (e.g.
		# adds vulkan code not always guarded by --with-vulkan), so force
		# some options that are typically needed by games either way
		--with-freetype
		--with-opengl
		--with-vulkan

		# ...and disable most options unimportant for games and unused by
		# Proton rather than expose as volatile USEs with little support
		--without-capi
		--without-cups
		--without-gphoto
		--without-gssapi
		--without-krb5
		--without-netapi
		--without-opencl
		--without-pcap
		--without-pcsclite
		--without-sane
		ac_cv_lib_soname_odbc=

		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
		$(use_enable video_cards_amdgpu amd_ags_x64)
		--disable-tests

		$(use_with X x)
		$(use_with alsa)
		$(use_with dbus)
		$(use_with ffmpeg)
		$(use_with fontconfig)
		$(use_with gstreamer)
		$(use_with nls gettext)
		--without-osmesa # media-libs/mesa no longer supports this
		--without-oss # media-sound/oss is not packaged (OSSv4)
		$(use_with pulseaudio pulse)
		$(use_with sdl)
		$(use_with ssl gnutls)
		$(use_with udev)
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with wayland)
		$(use_with xinerama)

		--without-piper # unpackaged, for tts but unusable without steam
		--without-vosk # unpackaged, file a bug if you need this
	)

	wine_src_configure
}

src_install() {
	use perl || local WINE_SKIP_INSTALL=(
		${WINE_DATADIR}/man/man1/wine{dump,maker}.1
		${WINE_PREFIX}/bin/{function_grep.pl,wine{dump,maker}}
	)

	wine_src_install

	dodoc ANNOUNCE* AUTHORS README* documentation/README*
	readme.gentoo_create_doc
}

pkg_preinst() {
	has_version ${CATEGORY}/${PN} && WINE_HAD_ANY_SLOT=
}

pkg_postinst() {
	wine_src_postinst

	[[ -v WINE_HAD_ANY_SLOT ]] || readme.gentoo_print_elog

	optfeature "/dev/hidraw* access used for *some* controllers (e.g. DualShock4)" \
		games-util/game-device-udev-rules

	ewarn
	ewarn "Warning: please consider ${PN} provided as-is without real"
	ewarn "support. Upstream does not want bug reports unless can reproduce"
	ewarn "with real Steam+Proton, and Gentoo is largely unable to help"
	ewarn "unless it is a build/packaging issue. So, if need support, try"
	ewarn "normal Wine or Proton instead."
}
