# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )
PYTHON_COMPAT=( python3_{10..12} )
inherit autotools flag-o-matic multilib multilib-build python-any-r1
inherit readme.gentoo-r1 toolchain-funcs wrapper

WINE_GECKO=2.47.3
WINE_MONO=7.4.1
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
	usb v4l +xcomposite xinerama"

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	dev-libs/libgcrypt:=[${MULTILIB_USEDEP}]
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/libglvnd[X,${MULTILIB_USEDEP}]
	media-libs/vulkan-loader[${MULTILIB_USEDEP}]
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
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )"
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
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
	usb? ( dev-libs/libusb:1[${MULTILIB_USEDEP}] )"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	gecko? ( app-emulation/wine-gecko:${WINE_GECKO}[${MULTILIB_USEDEP}] )
	gstreamer? ( media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP}] )
	mono? ( app-emulation/wine-mono:${WINE_MONO} )
	perl? (
		dev-lang/perl
		dev-perl/XML-LibXML
	)
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )"
DEPEND="
	${WINE_COMMON_DEPEND}
	sys-kernel/linux-headers
	x11-base/xorg-proto"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	sys-devel/binutils
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	!crossdev-mingw? ( dev-util/mingw64-toolchain[${MULTILIB_USEDEP}] )"
IDEPEND=">=app-eselect/eselect-wine-2"

QA_CONFIG_IMPL_DECL_SKIP=(
	__clear_cache # unused on amd64+x86 (bug #900332)
	res_getservers # false positive
)
QA_TEXTRELS="usr/lib/*/wine/i386-unix/*.so" # uses -fno-PIC -Wl,-z,notext

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-musl.patch
	"${FILESDIR}"/${PN}-7.0.4-noexecstack.patch
	"${FILESDIR}"/${PN}-7.0.4-restore-menubuilder.patch
	"${FILESDIR}"/${PN}-8.0.1c-unwind.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local mingw=-w64-mingw32
		for mingw in $(usev abi_x86_64 x86_64${mingw}) $(usev abi_x86_32 i686${mingw}); do
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

	# ensure .desktop calls this variant + slot
	sed -i "/^Exec=/s/wine /${P} /" loader/wine.desktop || die

	# similarly to staging, append to `wine --version` for identification
	sed -i "s/wine_build[^1]*1/& (Proton-${WINE_PV})/" configure.ac || die

	# always update for patches (including user's wrt #432348)
	eautoreconf
	tools/make_requests || die # perl
	dlls/winevulkan/make_vulkan -x vk.xml || die # python, needed for proton's
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

		# upstream (Valve) doesn't really support misc configurations (e.g.
		# adds vulkan code not always guarded by --with-vulkan), so force
		# some major options that are typically needed by games either way
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
		--without-sane
		ac_cv_lib_soname_odbc=

		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
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

	tc-ld-force-bfd # builds with non-bfd but broken at runtime (bug #867097)
	filter-lto # build failure
	use custom-cflags || strip-flags # can break in obscure ways at runtime
	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	# temporary workaround for tc-ld-force-bfd not yet enforcing with mold
	# https://github.com/gentoo/gentoo/pull/28355
	[[ $($(tc-getCC) ${LDFLAGS} -Wl,--version 2>/dev/null) == mold* ]] &&
		append-ldflags -fuse-ld=bfd

	# build using upstream's way (--with-wine64)
	# order matters: configure+compile 64->32, install 32->64
	local -i bits
	for bits in $(usev abi_x86_64 64) $(usev abi_x86_32 32); do
	(
		einfo "Configuring ${PN} for ${bits}bits in ${WORKDIR}/build${bits} ..."

		mkdir ../build${bits} || die
		cd ../build${bits} || die

		pe_arch=i386
		if (( bits == 64 )); then
			pe_arch=x86_64
			: "${CROSSCC:=${CROSSCC_amd64:-x86_64-w64-mingw32-gcc}}"
			conf+=( --enable-win64 )
		elif use amd64; then
			conf+=(
				$(usev abi_x86_64 --with-wine64=../build64)
				TARGETFLAGS=-m32 # for widl
			)
			# _setup is optional, but use over Wine's auto-detect (+#472038)
			multilib_toolchain_setup x86
		fi
		: "${CROSSCC:=${CROSSCC_x86:-i686-w64-mingw32-gcc}}"

		# CROSSCC is no longer recognized by Wine, but still use for now
		# (future handling for CROSS* variables is subject to changes)
		conf+=( ac_cv_prog_${pe_arch}_CC="${CROSSCC}" )

		# use *FLAGS for mingw, but strip unsupported
		: "${CROSSCFLAGS:=$(
			# >=wine-7.21 <8.10's configure.ac does not pass -fno-strict when
			# it should (can be removed when proton is rebased on >=8.10)
			append-cflags '-fno-strict-aliasing'
			filter-flags '-fstack-protector*' #870136
			filter-flags '-mfunction-return=thunk*' #878849
			# -mavx with mingw-gcc has a history of obscure issues and
			# disabling is seen as safer, e.g. `WINEARCH=win32 winecfg`
			# crashes with -march=skylake >=wine-8.10, similar issues with
			# znver4: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110273
			append-cflags -mno-avx
			CC=${CROSSCC} test-flags-CC ${CFLAGS:--O2})}"
		: "${CROSSLDFLAGS:=$(
			filter-flags '-fuse-ld=*'
			CC=${CROSSCC} test-flags-CCLD ${LDFLAGS})}"
		export CROSS{C,LD}FLAGS

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

	# symlink for plain 'wine' and install its man pages if 64bit-only #404331
	if use abi_x86_64 && use !abi_x86_32; then
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

	# don't let portage try to strip PE files with the wrong
	# strip executable and instead handle it here (saves ~120MB)
	dostrip -x ${WINE_PREFIX}/wine/{i386,x86_64}-windows

	if use strip; then
		ebegin "Stripping Windows (PE) binaries"
		find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(a\|dll\|exe\)' \
			-exec $(usex abi_x86_64 x86_64 i686)-w64-mingw32-strip --strip-unneeded {} +
		eend ${?} || die
	fi

	dodoc ANNOUNCE AUTHORS README* documentation/README*
	readme.gentoo_create_doc
}

pkg_preinst() {
	has_version ${CATEGORY}/${PN} && WINE_HAD_ANY_SLOT=
}

pkg_postinst() {
	[[ -v WINE_HAD_ANY_SLOT ]] || readme.gentoo_print_elog

	eselect wine update --if-unset || die
}

pkg_postrm() {
	eselect wine update --if-unset || die
}
