# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )
PYTHON_COMPAT=( python3_{10..13} )
inherit autotools flag-o-matic multilib multilib-build prefix
inherit python-any-r1 readme.gentoo-r1 toolchain-funcs wrapper

WINE_GECKO=2.47.4
WINE_MONO=9.1.0
WINE_PV=$(ver_rs 2 -)

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ValveSoftware/wine.git"
	EGIT_BRANCH="experimental_$(ver_cut 1-2)"
else
	SRC_URI="https://github.com/ValveSoftware/wine/archive/refs/tags/proton-wine-${WINE_PV}.tar.gz"
	S="${WORKDIR}/${PN}-wine-${WINE_PV}"
	KEYWORDS="-* ~amd64 ~x86"
fi

DESCRIPTION="Valve Software's fork of Wine"
HOMEPAGE="https://github.com/ValveSoftware/wine/"

LICENSE="LGPL-2.1+ BSD-2 IJG MIT OPENLDAP ZLIB gsm libpng2 libtiff"
SLOT="${PV}"
IUSE="
	+abi_x86_32 +abi_x86_64 +alsa crossdev-mingw custom-cflags
	+fontconfig +gecko +gstreamer llvm-libunwind +mono nls osmesa
	perl pulseaudio +sdl selinux +ssl +strip udev udisks +unwind
	usb v4l video_cards_amdgpu wow64 +xcomposite xinerama
"
REQUIRED_USE="wow64? ( abi_x86_64 !abi_x86_32 )"

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	dev-libs/libgcrypt:=[${MULTILIB_USEDEP}]
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/libglvnd[X,${MULTILIB_USEDEP}]
	media-libs/vulkan-loader[X,${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	osmesa? ( media-libs/mesa[osmesa,${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[haptic,joystick,${MULTILIB_USEDEP}] )
	ssl? (
		dev-libs/gmp:=[${MULTILIB_USEDEP}]
		net-libs/gnutls:=[${MULTILIB_USEDEP}]
	)
	udisks? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )
	xcomposite? ( x11-libs/libXcomposite[${MULTILIB_USEDEP}] )
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
"
# gcc: for -latomic with clang
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	sys-devel/gcc:*
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libdrm[video_cards_amdgpu?,${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	gstreamer? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[opengl,${MULTILIB_USEDEP}]
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
	)
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${MULTILIB_USEDEP}] )
	)
	usb? ( dev-libs/libusb:1[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	gecko? (
		app-emulation/wine-gecko:${WINE_GECKO}[${MULTILIB_USEDEP}]
		wow64? ( app-emulation/wine-gecko[abi_x86_32] )
	)
	gstreamer? ( media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP}] )
	mono? ( app-emulation/wine-mono:${WINE_MONO} )
	perl? (
		dev-lang/perl
		dev-perl/XML-LibXML
	)
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )
"
DEPEND="
	${WINE_COMMON_DEPEND}
	sys-kernel/linux-headers
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	|| (
		sys-devel/binutils
		sys-devel/lld
	)
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	!crossdev-mingw? (
		>=dev-util/mingw64-toolchain-10.0.0_p1-r2[${MULTILIB_USEDEP}]
		wow64? ( dev-util/mingw64-toolchain[abi_x86_32] )
	)
"
IDEPEND=">=app-eselect/eselect-wine-2"

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
	"${FILESDIR}"/${PN}-8.0.5c-vulkan-libm.patch
	"${FILESDIR}"/${PN}-9.0-rpath.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local mingw=-w64-mingw32
		for mingw in $(usev abi_x86_64 x86_64${mingw}) \
			$(use abi_x86_32 || use wow64 && echo i686${mingw}); do
			if ! type -P ${mingw}-gcc >/dev/null; then
				eerror "With USE=crossdev-mingw, you must prepare the MinGW toolchain"
				eerror "yourself by installing sys-devel/crossdev then running:"
				eerror
				eerror "    crossdev --target ${mingw}"
				eerror
				eerror "For more information, please see: https://wiki.gentoo.org/wiki/Mingw"
				eerror "--> Note that mingw builds are default for ${PN} even without this USE."
				die "USE=crossdev-mingw is enabled, but ${mingw}-gcc was not found"
			fi
		done
	fi
}

src_prepare() {
	# sanity check, bumping these has a history of oversights
	local geckomono=$(sed -En '/^#define (GECKO|MONO)_VER/{s/[^0-9.]//gp}' \
		dlls/appwiz.cpl/addons.c || die)
	if [[ ${WINE_GECKO}$'\n'${WINE_MONO} != "${geckomono}" ]]; then
		local gmfatal=
		[[ ${PV} == *9999 ]] && gmfatal=nonfatal
		${gmfatal} die -n "gecko/mono mismatch in ebuild, has: " ${geckomono} " (please file a bug)"
	fi

	default

	if tc-is-clang; then
		# -mabi=ms was ignored by <clang:16 then turned error in :17
		# and it still gets used in install phase despite --with-mingw,
		# drop as a quick fix for now which hopefully should be safe
		sed -i '/MSVCRTFLAGS=/s/-mabi=ms//' configure.ac || die

		# needed by Valve's fsync patches if using clang (undef atomic_load_8)
		sed -e '/^UNIX_LIBS.*=/s/$/ -latomic/' \
			-i dlls/{ntdll,winevulkan}/Makefile.in || die
	fi

	# ensure .desktop calls this variant + slot
	sed -i "/^Exec=/s/wine /${P} /" loader/wine.desktop || die

	# similarly to staging, append to `wine --version` for identification
	sed -i "s/wine_build[^1]*1/& (Proton-${WINE_PV})/" configure.ac || die

	# datadir is not where wine-mono is installed, so prefixy alternate paths
	hprefixify -w /get_mono_path/ dlls/mscoree/metahost.c

	# always update for patches (including user's wrt #432348)
	eautoreconf
	tools/make_requests || die # perl
	# proton variant also needs specfiles and vulkan
	tools/make_specfiles || die # perl
	dlls/winevulkan/make_vulkan -x vk.xml || die # python
	# tip: if need more for user patches, with portage can e.g. do
	# echo "post_src_prepare() { tools/make_specfiles || die; }" \
	#     > /etc/portage/env/app-emulation/wine-proton
}

src_configure() {
	WINE_PREFIX=/usr/lib/${P}
	WINE_DATADIR=/usr/share/${P}

	local conf=(
		--prefix="${EPREFIX}"${WINE_PREFIX}
		--datadir="${EPREFIX}"${WINE_DATADIR}
		--includedir="${EPREFIX}"/usr/include/${P}
		--libdir="${EPREFIX}"${WINE_PREFIX}
		--mandir="${EPREFIX}"${WINE_DATADIR}/man

		$(usev wow64 --enable-archs=x86_64,i386)

		# upstream (Valve) doesn't really support misc configurations (e.g.
		# adds vulkan code not always guarded by --with-vulkan), so force
		# some major options that are typically needed by games either way
		# TODO?: --without-mingw could make sense *if* using clang, assuming
		# bug #912237 is resolved (consider when do USE=wow64 in proton-9)
		--with-freetype
		--with-mingw # needed by many, notably Blizzard titles
		--with-opengl
		--with-vulkan
		--with-x

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

		# afaik wayland support in 9.0.x currently cannot do opengl/vulkan
		# yet making it mostly pointless for a gaming-oriented build
		# (IUSE="X wayland" may be added in wine-proton-10 or 11)
		--without-wayland

		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
		$(use_enable video_cards_amdgpu amd_ags_x64)
		--disable-tests
		$(use_with alsa)
		$(use_with fontconfig)
		$(use_with gstreamer)
		$(use_with nls gettext)
		$(use_with osmesa)
		--without-oss # media-sound/oss is not packaged (OSSv4)
		$(use_with pulseaudio pulse)
		$(use_with sdl)
		$(use_with ssl gnutls)
		$(use_with udev)
		$(use_with udisks dbus) # dbus is only used for udisks
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with xcomposite)
		$(use_with xinerama)
	)

	filter-lto # build failure
	filter-flags -Wl,--gc-sections # runtime issues (bug #931329)
	use custom-cflags || strip-flags # can break in obscure ways at runtime

	# wine uses linker tricks unlikely to work with non-bfd/lld (bug #867097)
	# (do self test until https://github.com/gentoo/gentoo/pull/28355)
	if [[ $(LC_ALL=C $(tc-getCC) ${LDFLAGS} -Wl,--version 2>/dev/null) != @(LLD|GNU\ ld)* ]]
	then
		has_version -b sys-devel/binutils &&
			append-ldflags -fuse-ld=bfd ||
			append-ldflags -fuse-ld=lld
		strip-unsupported-flags
	fi

	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	# CROSSCC was formerly recognized by wine, thus been using similar
	# variables (subject to change, esp. if ever make a mingw.eclass).
	local mingwcc_amd64=${CROSSCC:-${CROSSCC_amd64:-x86_64-w64-mingw32-gcc}}
	local mingwcc_x86=${CROSSCC:-${CROSSCC_x86:-i686-w64-mingw32-gcc}}
	local -n mingwcc=mingwcc_$(usex abi_x86_64 amd64 x86)

	conf+=(
		ac_cv_prog_x86_64_CC="${mingwcc_amd64}"
		ac_cv_prog_i386_CC="${mingwcc_x86}"

		CROSSCFLAGS="${CROSSCFLAGS:-$(
			filter-flags '-fstack-protector*' #870136
			filter-flags '-mfunction-return=thunk*' #878849

			# some bashrc-mv users tend to do CFLAGS="${LDFLAGS}" and then
			# strip-unsupported-flags miss these during compile-only tests
			# (primarily done for 23.0 profiles' -z, not full coverage)
			filter-flags '-Wl,-z,*'

			CC=${mingwcc} test-flags-CC ${CFLAGS:--O2}
		)}"

		CROSSLDFLAGS="${CROSSLDFLAGS:-$(
			filter-flags '-fuse-ld=*'

			CC=${mingwcc} test-flags-CCLD ${LDFLAGS}
		)}"
	)

	# order matters with multilib: configure+compile 64->32, install 32->64
	local -i bits
	for bits in $(usev abi_x86_64 64) $(usev abi_x86_32 32); do
	(
		einfo "Configuring ${PN} for ${bits}bits in ${WORKDIR}/build${bits} ..."

		mkdir ../build${bits} || die
		cd ../build${bits} || die

		if (( bits == 64 )); then
			conf+=( --enable-win64 )
		elif use amd64; then
			conf+=(
				$(usev abi_x86_64 --with-wine64=../build64)
				TARGETFLAGS=-m32 # for widl
			)
			# _setup is optional, but use over Wine's auto-detect (+#472038)
			multilib_toolchain_setup x86
		fi

		ECONF_SOURCE=${S} econf "${conf[@]}"
	)
	done
}

src_compile() {
	use abi_x86_64 && emake -C ../build64 # do first
	use abi_x86_32 && emake -C ../build32
}

src_install() {
	use abi_x86_32 && emake DESTDIR="${D}" -C ../build32 install
	use abi_x86_64 && emake DESTDIR="${D}" -C ../build64 install # do last

	# Ensure both wine64 and wine are available if USE=abi_x86_64 (wow64,
	# -abi_x86_32, and/or EXTRA_ECONF could cause varying scenarios where
	# one or the other could be missing and that is unexpected for users
	# and some tools like winetricks)
	if use abi_x86_64; then
		if [[ -e ${ED}${WINE_PREFIX}/bin/wine64 && ! -e ${ED}${WINE_PREFIX}/bin/wine ]]; then
			dosym wine64 ${WINE_PREFIX}/bin/wine
			dosym wine64-preloader ${WINE_PREFIX}/bin/wine-preloader

			# also install wine(1) man pages (incl. translations)
			local man
			for man in ../build64/loader/wine.*man; do
				: "${man##*/wine}"
				: "${_%.*}"
				insinto ${WINE_DATADIR}/man/${_:+${_#.}/}man1
				newins ${man} wine.1
			done
		elif [[ ! -e ${ED}${WINE_PREFIX}/bin/wine64 && -e ${ED}${WINE_PREFIX}/bin/wine ]]; then
			dosym wine ${WINE_PREFIX}/bin/wine64
			dosym wine-preloader ${WINE_PREFIX}/bin/wine64-preloader
		fi
	fi

	use perl || rm "${ED}"${WINE_DATADIR}/man/man1/wine{dump,maker}.1 \
		"${ED}"${WINE_PREFIX}/bin/{function_grep.pl,wine{dump,maker}} || die

	# create variant wrappers for eselect-wine
	local bin
	for bin in "${ED}"${WINE_PREFIX}/bin/*; do
		make_wrapper "${bin##*/}-${P#wine-}" "${bin#"${ED}"}"
	done

	# don't let portage try to strip PE files with the wrong
	# strip executable and instead handle it here (saves ~120MB)
	dostrip -x ${WINE_PREFIX}/wine/{i386,x86_64}-windows

	if use strip; then
		ebegin "Stripping Windows (PE) binaries"
		find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(a\|dll\|exe\)' \
			-exec $(usex abi_x86_64 x86_64 i686)-w64-mingw32-strip --strip-unneeded {} +
		eend ${?} || die
	fi

	dodoc ANNOUNCE* AUTHORS README* documentation/README*
	readme.gentoo_create_doc
}

pkg_preinst() {
	has_version ${CATEGORY}/${PN} && WINE_HAD_ANY_SLOT=
}

pkg_postinst() {
	[[ -v WINE_HAD_ANY_SLOT ]] || readme.gentoo_print_elog

	if use !abi_x86_32 && use !wow64; then
		ewarn "32bit support is disabled. While 64bit applications themselves will"
		ewarn "work, be warned that it is not unusual that installers or other helpers"
		ewarn "will attempt to use 32bit and fail. If do not want full USE=abi_x86_32,"
		ewarn "note the experimental/WIP USE=wow64 can allow 32bit without multilib."
	elif use abi_x86_32; then
		# difficult to tell what is needed from here, but try to warn
		if has_version 'x11-drivers/nvidia-drivers'; then
			if has_version 'x11-drivers/nvidia-drivers[-abi_x86_32]'; then
				ewarn "x11-drivers/nvidia-drivers is installed but is built without"
				ewarn "USE=abi_x86_32 (ABI_X86=32), hardware acceleration with 32bit"
				ewarn "applications under ${PN} will likely not be usable."
				ewarn "Multi-card setups may need this on media-libs/mesa as well."
			fi
		elif has_version 'media-libs/mesa[-abi_x86_32]'; then
			ewarn "media-libs/mesa seems to be in use but is built without"
			ewarn "USE=abi_x86_32 (ABI_X86=32), hardware acceleration with 32bit"
			ewarn "applications under ${PN} will likely not be usable."
		fi
	fi

	eselect wine update --if-unset || die
}

pkg_postrm() {
	eselect wine update --if-unset || die
}
