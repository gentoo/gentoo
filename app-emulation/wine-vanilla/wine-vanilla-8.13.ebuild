# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit autotools flag-o-matic multilib multilib-build
inherit prefix toolchain-funcs wrapper

WINE_GECKO=2.47.4
WINE_MONO=8.0.0

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.winehq.org/wine/wine.git"
else
	(( $(ver_cut 2) )) && WINE_SDIR=$(ver_cut 1).x || WINE_SDIR=$(ver_cut 1).0
	SRC_URI="https://dl.winehq.org/wine/source/${WINE_SDIR}/wine-${PV}.tar.xz"
	S="${WORKDIR}/wine-${PV}"
	KEYWORDS="-* ~amd64 ~x86"
fi

DESCRIPTION="Free implementation of Windows(tm) on Unix, without external patchsets"
HOMEPAGE="
	https://www.winehq.org/
	https://gitlab.winehq.org/wine/wine/"

LICENSE="LGPL-2.1+ BSD-2 IJG MIT OPENLDAP ZLIB gsm libpng2 libtiff"
SLOT="${PV}"
IUSE="
	+X +abi_x86_32 +abi_x86_64 +alsa capi crossdev-mingw cups dos
	llvm-libunwind custom-cflags +fontconfig +gecko gphoto2 +gstreamer
	kerberos +mingw +mono netapi nls odbc opencl +opengl osmesa pcap
	perl pulseaudio samba scanner +sdl selinux smartcard +ssl +strip
	+truetype udev udisks +unwind usb v4l +vulkan wayland wow64
	+xcomposite xinerama"
# bug #551124 for truetype
REQUIRED_USE="
	X? ( truetype )
	crossdev-mingw? ( mingw )
	wow64? ( abi_x86_64 !abi_x86_32 mingw )"

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	X? (
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		opengl? (
			media-libs/libglvnd[X,${MULTILIB_USEDEP}]
			osmesa? ( media-libs/mesa[osmesa,${MULTILIB_USEDEP}] )
		)
		xcomposite? ( x11-libs/libXcomposite[${MULTILIB_USEDEP}] )
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
	cups? ( net-print/cups[${MULTILIB_USEDEP}] )
	fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	netapi? ( net-fs/samba[${MULTILIB_USEDEP}] )
	odbc? ( dev-db/unixODBC[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[haptic,joystick,${MULTILIB_USEDEP}] )
	ssl? ( net-libs/gnutls:=[${MULTILIB_USEDEP}] )
	truetype? ( media-libs/freetype[${MULTILIB_USEDEP}] )
	udisks? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )"
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	capi? ( net-libs/libcapi:=[${MULTILIB_USEDEP}] )
	gphoto2? ( media-libs/libgphoto2:=[${MULTILIB_USEDEP}] )
	gstreamer? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
	)
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	pcap? ( net-libs/libpcap[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	scanner? ( media-gfx/sane-backends[${MULTILIB_USEDEP}] )
	smartcard? ( sys-apps/pcsc-lite[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${MULTILIB_USEDEP}] )
	)
	usb? ( dev-libs/libusb:1[${MULTILIB_USEDEP}] )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	dos? (
		|| (
			games-emulation/dosbox
			games-emulation/dosbox-staging
		)
	)
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
	samba? ( net-fs/samba[winbind] )
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )"
DEPEND="
	${WINE_COMMON_DEPEND}
	sys-kernel/linux-headers
	X? ( x11-base/xorg-proto )"
BDEPEND="
	dev-lang/perl
	sys-devel/binutils
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	mingw? ( !crossdev-mingw? (
		>=dev-util/mingw64-toolchain-10.0.0_p1-r2[${MULTILIB_USEDEP}]
		wow64? ( dev-util/mingw64-toolchain[abi_x86_32] )
	) )
	nls? ( sys-devel/gettext )
	wayland? ( dev-util/wayland-scanner )"
IDEPEND=">=app-eselect/eselect-wine-2"

QA_CONFIG_IMPL_DECL_SKIP=(
	__clear_cache # unused on amd64+x86 (bug #900338)
	res_getservers # false positive
)
QA_TEXTRELS="usr/lib/*/wine/i386-unix/*.so" # uses -fno-PIC -Wl,-z,notext

PATCHES=(
	"${FILESDIR}"/${PN}-7.0-noexecstack.patch
	"${FILESDIR}"/${PN}-7.20-unwind.patch
	"${FILESDIR}"/${PN}-8.13-rpath.patch
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

	# ensure .desktop calls this variant + slot
	sed -i "/^Exec=/s/wine /${P} /" loader/wine.desktop || die

	# datadir is not where wine-mono is installed, so prefixy alternate paths
	hprefixify -w /get_mono_path/ dlls/mscoree/metahost.c

	# always update for patches (including user's wrt #432348)
	eautoreconf
	tools/make_requests || die # perl
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

		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
		--disable-tests

		$(use_with X x)
		$(use_with alsa)
		$(use_with capi)
		$(use_with cups)
		$(use_with fontconfig)
		$(use_with gphoto2 gphoto)
		$(use_with gstreamer)
		$(use_with kerberos gssapi)
		$(use_with kerberos krb5)
		$(use_with mingw)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		--without-oss # media-sound/oss is not packaged (OSSv4)
		$(use_with pcap)
		$(use_with pulseaudio pulse)
		$(use_with scanner sane)
		$(use_with sdl)
		$(use_with smartcard pcsclite)
		$(use_with ssl gnutls)
		$(use_with truetype freetype)
		$(use_with udev)
		$(use_with udisks dbus) # dbus is only used for udisks
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with vulkan)
		$(use_with wayland)
		$(use_with xcomposite)
		$(use_with xinerama)
		$(usev !odbc ac_cv_lib_soname_odbc=)
	)

	# builds with non-bfd but broken at runtime (bug #867097)
	# TODO: retest mold and lld, and figure out what's wrong if
	# still broken given (at least) lld is supposed to work
	tc-ld-force-bfd

	filter-lto # build failure
	use custom-cflags || strip-flags # can break in obscure ways at runtime

	# temporary workaround for tc-ld-force-bfd not yet enforcing with mold
	# https://github.com/gentoo/gentoo/pull/28355
	[[ $($(tc-getCC) ${LDFLAGS} -Wl,--version 2>/dev/null) == mold* ]] &&
		append-ldflags -fuse-ld=bfd

	if use mingw; then
		use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

		filter-flags -fno-plt # build failure

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

				# -mavx with mingw-gcc has a history of obscure issues and
				# disabling is seen as safer, e.g. `WINEARCH=win32 winecfg`
				# crashes with -march=skylake >=wine-8.10, similar issues with
				# znver4: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110273
				use custom-cflags || append-cflags -mno-avx

				CC=${mingwcc} test-flags-CC ${CFLAGS:--O2}
			)}"

			CROSSLDFLAGS="${CROSSLDFLAGS:-$(
				filter-flags '-fuse-ld=*'

				CC=${mingwcc} test-flags-CCLD ${LDFLAGS}
			)}"
		)
	fi

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

	if use wow64; then
		# compat symlinks, albeit ideally no one should call "wine64"
		dosym wine ${WINE_PREFIX}/bin/wine64
		dosym wine-preloader ${WINE_PREFIX}/bin/wine64-preloader
	elif use abi_x86_64 && use !abi_x86_32; then
		# if no 32bit support it instead only installs "wine64" which may
		# come as unexpected, so provide "wine" alongside its man page
		dosym wine64 ${WINE_PREFIX}/bin/wine
		dosym wine64-preloader ${WINE_PREFIX}/bin/wine-preloader
		local man
		for man in ../build64/loader/wine.*man; do
			: "${man##*/wine}"
			: "${_%.*}"
			insinto ${WINE_DATADIR}/man/${_:+${_#.}/}man1
			newins ${man} wine.1
		done
	fi

	use perl || rm "${ED}"${WINE_DATADIR}/man/man1/wine{dump,maker}.1 \
		"${ED}"${WINE_PREFIX}/bin/{function_grep.pl,wine{dump,maker}} || die

	# create variant wrappers for eselect-wine
	local bin
	for bin in "${ED}"${WINE_PREFIX}/bin/*; do
		make_wrapper "${bin##*/}-${P#wine-}" "${bin#"${ED}"}"
	done

	if use mingw; then
		# don't let portage try to strip PE files with the wrong
		# strip executable and instead handle it here (saves ~120MB)
		dostrip -x ${WINE_PREFIX}/wine/{i386,x86_64}-windows

		if use strip; then
			ebegin "Stripping Windows (PE) binaries"
			find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(a\|dll\|exe\)' \
				-exec $(usex abi_x86_64 x86_64 i686)-w64-mingw32-strip --strip-unneeded {} +
			eend ${?} || die
		fi
	fi

	dodoc ANNOUNCE AUTHORS README* documentation/README*
}

pkg_postinst() {
	if use !abi_x86_32 && use !wow64; then
		ewarn "32bit support is disabled. While 64bit applications themselves will"
		ewarn "work, be warned that it is not unusual that installers or other helpers"
		ewarn "will attempt to use 32bit and fail. If do not want full USE=abi_x86_32,"
		ewarn "note that the experimental USE=wow64 can allow 32bit without multilib."
	fi

	eselect wine update --if-unset || die
}

pkg_postrm() {
	eselect wine update --if-unset || die
}
