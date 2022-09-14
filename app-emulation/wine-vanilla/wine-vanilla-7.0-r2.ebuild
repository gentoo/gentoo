# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ar ast bg ca cs da de el en en_US eo es fa fi fr he hi hr hu it ja ko lt ml nb_NO nl or pa pl pt_BR pt_PT rm ro ru si sk sl sr_RS@cyrillic sr_RS@latin sv ta te th tr uk wa zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit autotools estack flag-o-matic multilib-minimal pax-utils plocale toolchain-funcs virtualx wrapper xdg-utils

MY_PN="${PN%%-*}"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://source.winehq.org/git/wine.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
	#KEYWORDS=""
else
	MAJOR_V=$(ver_cut 1)
	SRC_URI="https://dl.winehq.org/wine/source/${MAJOR_V}.0/${MY_P}.tar.xz"
	KEYWORDS="-* amd64 x86"
fi
S="${WORKDIR}/${MY_P}"

GWP_V="20211122"
PATCHDIR="${WORKDIR}/gentoo-wine-patches"

DESCRIPTION="Free implementation of Windows(tm) on Unix, without external patchsets"
HOMEPAGE="https://www.winehq.org/"
SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~sarnex/distfiles/wine/gentoo-wine-patches-${GWP_V}.tar.xz
"

LICENSE="LGPL-2.1"
SLOT="${PV}"
IUSE="+abi_x86_32 +abi_x86_64 +alsa capi crossdev-mingw cups custom-cflags dos +fontconfig +gecko gphoto2 gssapi gstreamer kerberos ldap mingw +mono mp3 netapi nls odbc openal opencl +opengl osmesa oss +perl pcap pulseaudio +realtime +run-exes samba scanner sdl selinux +ssl test +threads +truetype udev +udisks +unwind usb v4l vkd3d vulkan +X +xcomposite xinerama"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )
	X? ( truetype )
	crossdev-mingw? ( mingw )
	elibc_glibc? ( threads )
	osmesa? ( opengl )
	test? ( abi_x86_32 )
	vkd3d? ( vulkan )" # osmesa-opengl #286560 # X-truetype #551124

# FIXME: the test suite is unsuitable for us; many tests require net access
# or fail due to Xvfb's opengl limitations.
RESTRICT="test"

BDEPEND="sys-devel/flex
	virtual/yacc
	virtual/pkgconfig
	mingw? ( !crossdev-mingw? ( dev-util/mingw64-toolchain[${MULTILIB_USEDEP}] ) )"

COMMON_DEPEND="
	X? (
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	capi? ( net-libs/libcapi[${MULTILIB_USEDEP}] )
	cups? ( net-print/cups:=[${MULTILIB_USEDEP}] )
	fontconfig? ( media-libs/fontconfig:=[${MULTILIB_USEDEP}] )
	gphoto2? (
		media-libs/libgphoto2:=[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	)
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP}]
	)
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	ldap? ( net-nds/openldap:=[${MULTILIB_USEDEP}] )
	netapi? ( net-fs/samba[netapi(+),${MULTILIB_USEDEP}] )
	nls? ( sys-devel/gettext[${MULTILIB_USEDEP}] )
	odbc? ( dev-db/unixODBC:=[${MULTILIB_USEDEP}] )
	openal? ( media-libs/openal:=[${MULTILIB_USEDEP}] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	opengl? (
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	osmesa? ( >=media-libs/mesa-13[osmesa,${MULTILIB_USEDEP}] )
	pcap? ( net-libs/libpcap[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	scanner? ( media-gfx/sane-backends:=[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2:=[haptic,joystick,${MULTILIB_USEDEP}] )
	ssl? ( net-libs/gnutls:=[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.0.0[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	udisks? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}]  )
	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )
	vkd3d? ( >=app-emulation/vkd3d-1.2[${MULTILIB_USEDEP}] )
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )
	xcomposite? ( x11-libs/libXcomposite[${MULTILIB_USEDEP}] )
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )"

RDEPEND="${COMMON_DEPEND}
	app-emulation/wine-desktop-common
	>app-eselect/eselect-wine-0.3
	dos? ( >=games-emulation/dosbox-0.74_p20160629 )
	gecko? ( app-emulation/wine-gecko:2.47.2[abi_x86_32?,abi_x86_64?] )
	mono? ( app-emulation/wine-mono:7.0.0 )
	perl? (
		dev-lang/perl
		dev-perl/XML-Simple
	)
	pulseaudio? (
		realtime? ( sys-auth/rtkit )
	)
	samba? ( >=net-fs/samba-3.0.25[winbind] )
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )"

# tools/make_requests requires perl
DEPEND="${COMMON_DEPEND}
	${BDEPEND}
	>=sys-kernel/linux-headers-2.6
	X? ( x11-base/xorg-proto )
	xinerama? ( x11-base/xorg-proto )"

# These use a non-standard "Wine" category, which is provided by
# /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="usr/share/applications/wine-browsedrive.desktop
usr/share/applications/wine-notepad.desktop
usr/share/applications/wine-uninstaller.desktop
usr/share/applications/wine-winecfg.desktop"

PATCHES=(
	"${PATCHDIR}/patches/${MY_PN}-6.22-winegcc.patch" #260726
	"${PATCHDIR}/patches/${MY_PN}-4.7-multilib-portage.patch" #395615
	"${PATCHDIR}/patches/${MY_PN}-2.0-multislot-apploader.patch" #310611
)
PATCHES_BIN=()

# https://bugs.gentoo.org/show_bug.cgi?id=635222
if [[ ${#PATCHES_BIN[@]} -ge 1 ]] || [[ ${PV} == 9999 ]]; then
	DEPEND+=" dev-util/patchbin"
fi

wine_compiler_check() {
	# Ensure compiler support
	# (No checks here as of 2022)
	return 0
}

wine_build_environment_check() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0

	if use abi_x86_32 && use opencl && [[ "$(eselect opencl show 2> /dev/null)" == "intel" ]]; then
		eerror "You cannot build wine with USE=opencl because intel-ocl-sdk is 64-bit only."
		eerror "See https://bugs.gentoo.org/487864 for more details."
		eerror
		return 1
	fi
}

wine_env_vcs_vars() {
	local pn_live_var="${PN//[-+]/_}_LIVE_COMMIT"
	local pn_live_val="${pn_live_var}"
	eval pn_live_val='$'${pn_live_val}
	if [[ ! -z ${EGIT_COMMIT} ]]; then
		eerror "Commits must now be specified using the environmental variables"
		eerror "EGIT_OVERRIDE_COMMIT_WINE"
		eerror
		return 1
	fi
}

pkg_pretend() {
	wine_build_environment_check || die

	# Verify OSS support
	if use oss; then
		if ! has_version ">=media-sound/oss-4"; then
			eerror "You cannot build wine with USE=oss without having support from"
			eerror ">=media-sound/oss-4 (only available through external repos)"
			eerror
			die
		fi
	fi

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local mingw=-w64-mingw32
		for mingw in $(usev abi_x86_64 x86_64${mingw}) $(usev abi_x86_32 i686${mingw}); do
			type -P ${mingw}-gcc && continue
			eerror "With USE=crossdev-mingw, you must prepare the MinGW toolchain"
			eerror "yourself by installing sys-devel/crossdev then running:"
			eerror
			eerror "    crossdev --target ${mingw}"
			eerror
			eerror "For more information, please see: https://wiki.gentoo.org/wiki/Mingw"
			die "USE=crossdev-mingw is enabled, but ${mingw}-gcc was not found"
		done
	fi
}

pkg_setup() {
	wine_build_environment_check || die
	wine_env_vcs_vars || die

	WINE_VARIANT="${PN#wine}-${PV}"
	WINE_VARIANT="${WINE_VARIANT#-}"

	MY_PREFIX="${EPREFIX}/usr/lib/wine-${WINE_VARIANT}"
	MY_DATAROOTDIR="${EPREFIX}/usr/share/wine-${WINE_VARIANT}"
	MY_DATADIR="${MY_DATAROOTDIR}"
	MY_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	MY_INCLUDEDIR="${EPREFIX}/usr/include/wine-${WINE_VARIANT}"
	MY_LIBEXECDIR="${EPREFIX}/usr/libexec/wine-${WINE_VARIANT}"
	MY_LOCALSTATEDIR="${EPREFIX}/var/wine-${WINE_VARIANT}"
	MY_MANDIR="${MY_DATADIR}/man"
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		EGIT_CHECKOUT_DIR="${S}" git-r3_src_unpack
	fi

	default

	plocale_find_changes "${S}/po" "" ".po"
}

src_prepare() {

	eapply_bin(){
		local patch
		for patch in ${PATCHES_BIN[@]}; do
			patchbin --nogit < "${patch}" || die
		done
	}

	local md5="$(md5sum server/protocol.def)"

	default
	eapply_bin
	eautoreconf

	# Modification of the server protocol requires regenerating the server requests
	if [[ "$(md5sum server/protocol.def)" != "${md5}" ]]; then
		einfo "server/protocol.def was patched; running tools/make_requests"
		tools/make_requests || die #432348
	fi
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	if ! use run-exes; then
		sed -i '/^MimeType/d' loader/wine.desktop || die #117785
	fi

	# Edit wine.desktop to work for specific variant
	sed -e "/^Exec=/s/wine /wine-${WINE_VARIANT} /" -i loader/wine.desktop || die

	# hi-res default icon, #472990, https://bugs.winehq.org/show_bug.cgi?id=24652
	cp "${PATCHDIR}/files/oic_winlogo.ico" dlls/user32/resources/ || die

	plocale_get_locales > po/LINGUAS || die # otherwise wine doesn't respect LINGUAS

	# Fix manpage generation for locales #469418 and abi_x86_64 #617864

	# Duplicate manpages input files for wine64
	local f
	for f in loader/*.man.in; do
		cp ${f} ${f/wine/wine64} || die
	done
	# Add wine64 manpages to Makefile
	if use abi_x86_64; then
		sed -i "/wine.man.in/i \
			\\\twine64.man.in \\\\" loader/Makefile.in || die
		sed -i -E 's/(.*wine)(.*\.UTF-8\.man\.in.*)/&\
\164\2/' loader/Makefile.in || die
	fi

	rm_man_file(){
		local file="${1}"
		loc=${2}
		sed -i "/${loc}\.UTF-8\.man\.in/d" "${file}" || die
	}

	while read f; do
		plocale_for_each_disabled_locale rm_man_file "${f}"
	done < <(find -name "Makefile.in" -exec grep -q "UTF-8.man.in" "{}" \; -print)
}

src_configure() {
	wine_compiler_check || die

	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags
	if use mingw; then
		use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

		# use *FLAGS for mingw, but strip unsupported (e.g. --hash-style=gnu)
		local mingwcc=${CROSSCC:-$(usex x86 i686 x86_64)-w64-mingw32-gcc}
		: "${CROSSCFLAGS:=$(
			filter-flags '-fstack-protector*' #870136
			CC=${mingwcc} test-flags-CC ${CFLAGS:--O2})}"
		: "${CROSSLDFLAGS:=$(
			filter-flags '-fuse-ld=*'
			CC=${mingwcc} test-flags-CCLD ${LDFLAGS})}"
		export CROSS{C,LD}FLAGS
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--prefix="${MY_PREFIX}"
		--datarootdir="${MY_DATAROOTDIR}"
		--datadir="${MY_DATADIR}"
		--docdir="${MY_DOCDIR}"
		--includedir="${MY_INCLUDEDIR}"
		--libdir="${EPREFIX}/usr/$(get_libdir)/wine-${WINE_VARIANT}"
		--libexecdir="${MY_LIBEXECDIR}"
		--localstatedir="${MY_LOCALSTATEDIR}"
		--mandir="${MY_MANDIR}"
		--sysconfdir="${EPREFIX}/etc/wine"
		$(use_with alsa)
		$(use_with capi)
		$(use_with cups)
		$(use_with udisks dbus)
		$(use_with fontconfig)
		$(use_with ssl gnutls)
		$(use_enable gecko mshtml)
		$(use_with gphoto2 gphoto)
		$(use_with gssapi)
		$(use_with gstreamer)
		--enable-hal
		$(use_with kerberos krb5)
		$(use_with ldap)
		# TODO: Will bug 685172 still need special handling?
		$(use_with mingw)
		$(use_enable mono mscoree)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with openal)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		$(use_with oss)
		$(use_with pcap)
		$(use_with pulseaudio pulse)
		$(use_with threads pthread)
		$(use_with scanner sane)
		$(use_with sdl)
		$(use_enable test tests)
		$(use_with truetype freetype)
		$(use_with udev)
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with vkd3d)
		$(use_with vulkan)
		$(use_with X x)
		$(use_with X xfixes)
		$(use_with xcomposite)
		$(use_with xinerama)
	)

	local PKG_CONFIG
	# Avoid crossdev's i686-pc-linux-gnu-pkg-config if building wine32 on amd64; #472038
	tc-export PKG_CONFIG

	if use amd64; then
		if [[ ${ABI} == amd64 ]]; then
			myconf+=( --enable-win64 )
		else
			myconf+=( --disable-win64 )
		fi

		# Note: using --with-wine64 results in problems with multilib.eclass
		# CC/LD hackery. We're using separate tools instead.
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
	emake depend
}

multilib_src_test() {
	# FIXME: win32-only; wine64 tests fail with "could not find the Wine loader"
	if [[ ${ABI} == x86 ]]; then
		if [[ $(id -u) == 0 ]]; then
			ewarn "Skipping tests since they cannot be run under the root user."
			ewarn "To run the test ${MY_PN} suite, add userpriv to FEATURES in make.conf"
			return
		fi

		WINEPREFIX="${T}/.wine-${ABI}" \
		virtx emake test
	fi
}

multilib_src_install_all() {
	local DOCS=( ANNOUNCE AUTHORS README )
	add_locale_docs() {
		local locale_doc="documentation/README.$1"
		[[ ! -e ${locale_doc} ]] || DOCS+=( ${locale_doc} )
	}
	plocale_for_each_locale add_locale_docs

	einstalldocs
	find "${ED}" -name *.la -delete || die

	if ! use perl ; then # winedump calls function_grep.pl, and winemaker is a perl script
		rm "${D%}${MY_PREFIX}"/bin/{wine{dump,maker},function_grep.pl} \
			"${D%}${MY_MANDIR}"/man1/wine{dump,maker}.1 || die
	fi

	use abi_x86_32 && pax-mark psmr "${D%}${MY_PREFIX}"/bin/wine{,-preloader} #255055
	use abi_x86_64 && pax-mark psmr "${D%}${MY_PREFIX}"/bin/wine64{,-preloader}

	# Avoid double prefix from dosym and make_wrapper
	MY_PREFIX=${MY_PREFIX#${EPREFIX}}

	if use abi_x86_64 && ! use abi_x86_32; then
		dosym wine64 "${MY_PREFIX}"/bin/wine # 404331
		dosym wine64-preloader "${MY_PREFIX}"/bin/wine-preloader
	fi

	# Failglob for binloops, shouldn't be necessary, but including to stay safe
	eshopts_push -s failglob #615218
	# Make wrappers for binaries for handling multiple variants
	# Note: wrappers instead of symlinks because some are shell which use basename
	local b
	for b in "${ED%}${MY_PREFIX}"/bin/*; do
		make_wrapper "${b##*/}-${WINE_VARIANT}" "${MY_PREFIX}/bin/${b##*/}"
	done
	eshopts_pop
}

pkg_postinst() {
	eselect wine register ${P}
	if [[ ${PN} == "wine-vanilla" ]]; then
		eselect wine register --vanilla ${P} || die
	fi

	eselect wine update --all --if-unset || die

	xdg_desktop_database_update

	if ! use gecko; then
		ewarn "Without Wine Gecko, wine prefixes will not have a default"
		ewarn "implementation of iexplore.  Many older windows applications"
		ewarn "rely upon the existence of an iexplore implementation, so"
		ewarn "you will likely need to install an external one, like via winetricks"
	fi
	if ! use mono; then
		ewarn "Without Wine Mono, wine prefixes will not have a default"
		ewarn "implementation of .NET.  Many windows applications rely upon"
		ewarn "the existence of a .NET implementation, so you will likely need"
		ewarn "to install an external one, like via winetricks"
	fi
}

pkg_prerm() {
	eselect wine deregister ${P}
	if [[ ${PN} == "wine-vanilla" ]]; then
		eselect wine deregister --vanilla ${P} || die
	fi

	eselect wine update --all --if-unset || die
}

pkg_postrm() {
	xdg_desktop_database_update
}
