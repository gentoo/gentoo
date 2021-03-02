# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar ast bg ca cs da de el en en_US eo es fa fi fr he hi hr hu it ja ko lt ml nb_NO nl or pa pl pt_BR pt_PT rm ro ru si sk sl sr_RS@cyrillic sr_RS@latin sv ta te th tr uk wa zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit autotools eapi7-ver estack eutils flag-o-matic gnome2-utils l10n multilib multilib-minimal pax-utils toolchain-funcs virtualx xdg-utils
MY_PN="${PN%%-*}"
MY_PV="${PV/_/-}"
MY_P="${MY_PN}-${MY_PV}"

if [[ ${MY_PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://source.winehq.org/git/wine.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
	#KEYWORDS=""
else
	MAJOR_V=$(ver_cut 1)
	MINOR_V=$(ver_cut 2)
    if [[ ${MINOR_V} != "0" ]] ; then
        MINOR_V="x"
    fi
	SRC_URI="https://dl.winehq.org/wine/source/${MAJOR_V}.${MINOR_V}/${MY_P}.tar.xz"
	KEYWORDS="-* ~amd64 ~x86"
fi
S="${WORKDIR}/${MY_P}"

STAGING_P="wine-staging-${MY_PV}"
STAGING_DIR="${WORKDIR}/${STAGING_P}"
GWP_V="20210302"
PATCHDIR="${WORKDIR}/gentoo-wine-patches"

DESCRIPTION="Free implementation of Windows(tm) on Unix, with Wine-Staging patchset"
HOMEPAGE="https://www.winehq.org/"
SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~sarnex/distfiles/wine/gentoo-wine-patches-${GWP_V}.tar.xz
"

if [[ ${MY_PV} == "9999" ]] ; then
	STAGING_EGIT_REPO_URI="https://github.com/wine-staging/wine-staging.git"
else
	SRC_URI="${SRC_URI}
	staging? ( https://github.com/wine-staging/wine-staging/archive/v${MY_PV}.tar.gz -> ${STAGING_P}.tar.gz )"
fi

LICENSE="LGPL-2.1"
SLOT="${MY_PV}"
IUSE="+abi_x86_32 +abi_x86_64 +alsa capi cups custom-cflags dos elibc_glibc +faudio +fontconfig +gcrypt +gecko gphoto2 gsm gssapi gstreamer +jpeg kerberos kernel_FreeBSD +lcms ldap mingw +mono mp3 netapi nls odbc openal opencl +opengl osmesa oss +perl pcap pipelight +png prelink pulseaudio +realtime +run-exes samba scanner sdl selinux +ssl staging test themes +threads +truetype udev +udisks +unwind usb v4l vaapi vkd3d vulkan +X +xcomposite xinerama +xml"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )
	X? ( truetype )
	elibc_glibc? ( threads )
	osmesa? ( opengl )
	pipelight? ( staging )
	test? ( abi_x86_32 )
	themes? ( staging )
	vaapi? ( staging )
	vkd3d? ( vulkan )" # osmesa-opengl #286560 # X-truetype #551124

# FIXME: the test suite is unsuitable for us; many tests require net access
# or fail due to Xvfb's opengl limitations.
RESTRICT="test"

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
	faudio? ( app-emulation/faudio:=[${MULTILIB_USEDEP}] )
	fontconfig? ( media-libs/fontconfig:=[${MULTILIB_USEDEP}] )
	gcrypt? ( dev-libs/libgcrypt:=[${MULTILIB_USEDEP}] )
	gphoto2? ( media-libs/libgphoto2:=[${MULTILIB_USEDEP}] )
	gsm? ( media-sound/gsm:=[${MULTILIB_USEDEP}] )
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-plugins/gst-plugins-meta:1.0[${MULTILIB_USEDEP}]
	)
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	kerberos? ( virtual/krb5:0=[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms:2=[${MULTILIB_USEDEP}] )
	ldap? ( net-nds/openldap:=[${MULTILIB_USEDEP}] )
	mp3? ( >=media-sound/mpg123-1.5.0[${MULTILIB_USEDEP}] )
	netapi? ( net-fs/samba[netapi(+),${MULTILIB_USEDEP}] )
	nls? ( sys-devel/gettext[${MULTILIB_USEDEP}] )
	odbc? ( dev-db/unixODBC:=[${MULTILIB_USEDEP}] )
	openal? ( media-libs/openal:=[${MULTILIB_USEDEP}] )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	opengl? (
		virtual/glu[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	osmesa? ( >=media-libs/mesa-13[osmesa,${MULTILIB_USEDEP}] )
	pcap? ( net-libs/libpcap[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	scanner? ( media-gfx/sane-backends:=[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2:=[haptic,joystick,${MULTILIB_USEDEP}] )
	ssl? ( net-libs/gnutls:=[${MULTILIB_USEDEP}] )
	staging? ( sys-apps/attr[${MULTILIB_USEDEP}] )
	themes? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	)
	truetype? ( >=media-libs/freetype-2.0.0[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	udisks? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}]  )
	v4l? ( media-libs/libv4l[${MULTILIB_USEDEP}] )
	vaapi? ( x11-libs/libva[X,${MULTILIB_USEDEP}] )
	vkd3d? ( >=app-emulation/vkd3d-1.2[${MULTILIB_USEDEP}] )
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )
	xcomposite? ( x11-libs/libXcomposite[${MULTILIB_USEDEP}] )
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	xml? (
		dev-libs/libxml2[${MULTILIB_USEDEP}]
		dev-libs/libxslt[${MULTILIB_USEDEP}]
	)"

RDEPEND="${COMMON_DEPEND}
	app-emulation/wine-desktop-common
	>app-eselect/eselect-wine-0.3
	!app-emulation/wine:0
	dos? ( >=games-emulation/dosbox-0.74_p20160629 )
	gecko? ( app-emulation/wine-gecko:2.47.2[abi_x86_32?,abi_x86_64?] )
	mono? ( app-emulation/wine-mono:6.0.0 )
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
	sys-devel/flex
	>=sys-kernel/linux-headers-2.6
	virtual/pkgconfig
	virtual/yacc
	X? ( x11-base/xorg-proto )
	prelink? ( sys-devel/prelink )
	staging? (
		dev-lang/perl
		dev-perl/XML-Simple
	)
	xinerama? ( x11-base/xorg-proto )"

# These use a non-standard "Wine" category, which is provided by
# /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="usr/share/applications/wine-browsedrive.desktop
usr/share/applications/wine-notepad.desktop
usr/share/applications/wine-uninstaller.desktop
usr/share/applications/wine-winecfg.desktop"

PATCHES=(
	"${PATCHDIR}/patches/${MY_PN}-5.0-winegcc.patch" #260726
	"${PATCHDIR}/patches/${MY_PN}-4.7-multilib-portage.patch" #395615
	"${PATCHDIR}/patches/${MY_PN}-2.0-multislot-apploader.patch" #310611
	"${PATCHDIR}/patches/${MY_PN}-5.9-Revert-makedep-Install-also-generated-typelib-for-in.patch"
	"${PATCHDIR}/patches/${MY_PN}-6.3-Fix-nine.patch"
)
PATCHES_BIN=()

# https://bugs.gentoo.org/show_bug.cgi?id=635222
if [[ ${#PATCHES_BIN[@]} -ge 1 ]] || [[ ${MY_PV} == 9999 ]]; then
	DEPEND+=" dev-util/patchbin"
fi

wine_compiler_check() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0

	# GCC-specific bugs
	if tc-is-gcc; then
		# bug #549768
		if use abi_x86_64 && [[ $(gcc-major-version) = 5 && $(gcc-minor-version) -le 2 ]]; then
			ebegin "Checking for gcc-5 ms_abi compiler bug"
			$(tc-getCC) -O2 "${PATCHDIR}/files/pr66838.c" -o "${T}"/pr66838 || die
			# Run in subshell to prevent "Aborted" message
			( "${T}"/pr66838 || false ) >/dev/null 2>&1
			if ! eend $?; then
				eerror "64-bit wine cannot be built with gcc-5.1 or initial patchset of 5.2.0"
				eerror "due to compiler bugs; please re-emerge the latest gcc-5.2.x ebuild,"
				eerror "or use gcc-config to select a different compiler version."
				eerror "See https://bugs.gentoo.org/549768"
				eerror
				return 1
			fi
		fi
		# bug #574044
		if use abi_x86_64 && [[ $(gcc-major-version) = 5 && $(gcc-minor-version) = 3 ]]; then
			ebegin "Checking for gcc-5-3 stack realignment compiler bug"
			# Compile in subshell to prevent "Aborted" message
			( $(tc-getCC) -O2 -mincoming-stack-boundary=3 "${PATCHDIR}/files/pr69140.c" -o "${T}"/pr69140 ) >/dev/null 2>&1
			if ! eend $?; then
				eerror "Wine cannot be built with this version of gcc-5.3"
				eerror "due to compiler bugs; please re-emerge the latest gcc-5.3.x ebuild,"
				eerror "or use gcc-config to select a different compiler version."
				eerror "See https://bugs.gentoo.org/574044"
				eerror
				return 1
			fi
		fi
	fi

	# Ensure compiler support
	if use abi_x86_64; then
		ebegin "Checking for 64-bit compiler with builtin_ms_va_list support"
		# Compile in subshell to prevent "Aborted" message
		( $(tc-getCC) -O2 "${PATCHDIR}/files/builtin_ms_va_list.c" -o "${T}"/builtin_ms_va_list >/dev/null 2>&1)
		if ! eend $?; then
			eerror "This version of $(tc-getCC) does not support builtin_ms_va_list, can't enable 64-bit wine"
			eerror
			eerror "You need gcc-4.4+ or clang 3.8+ to build 64-bit wine"
			eerror
			return 1
		fi
	fi
}

wine_build_environment_check() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0

	if use abi_x86_64; then
		if tc-is-gcc && [[ $(gcc-major-version) -lt 4 || ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 4 ) ]]; then
			eerror "You need gcc-4.4+ to compile 64-bit wine"
			die
		elif tc-is-clang && [[ $(clang-major-version) -lt 3 || ( $(clang-major-version) -eq 3 && $(clang-minor-version) -lt 8 ) ]]; then
			eerror "You need clang-3.8+ to compile 64-bit wine"
			die
		fi
	fi
	if tc-is-gcc && [[ $(gcc-major-version) -eq 5 && $(gcc-minor-version) -le 3 ]]; then
		ewarn "GCC-5.0-5.3 suffered from compiler bugs and are no longer supported by"
		ewarn "Gentoo's Toolchain Team. If your ebuild fails the compiler checks in"
		ewarn "the configure phase, either update your compiler or switch to <5.0 || >=5.4"
	fi
	if tc-is-gcc && [[ $(gcc-major-version) -eq 5 && $(gcc-minor-version) -eq 4 ]]; then
		if has "-march=i686" ${CFLAGS} && ! has "-mtune=generic" ${CFLAGS}; then
			ewarn "Compilation can hang with CFLAGS=\"-march=i686\".  You can temporarily work"
			ewarn "around this by adding \"-mtune=generic\" to your CFLAGS for wine."
			ewarn "See package.env in man 5 portage for more information on how to do this."
			ewarn "See https://bugs.gentoo.org/show_bug.cgi?id=613128 for more details"
		fi
	fi

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
	if [[ ! -z ${pn_live_val} ]]; then
		if use staging; then
			eerror "Because of the multi-repo nature of ${MY_PN}, ${pn_live_var}"
			eerror "cannot be used to set the commit. Instead, you may use the"
			eerror "environment variables:"
			eerror "  EGIT_OVERRIDE_COMMIT_WINE"
			eerror "  EGIT_OVERRIDE_COMMIT_WINE_STAGING_WINE_STAGING"
			eerror
			return 1
		fi
	fi
	if [[ ! -z ${EGIT_COMMIT} ]]; then
		eerror "Commits must now be specified using the environment variables:"
		eerror "  EGIT_OVERRIDE_COMMIT_WINE"
		eerror "  EGIT_OVERRIDE_COMMIT_WINE_STAGING_WINE_STAGING"
		eerror
		return 1
	fi
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		wine_build_environment_check || die

		# Verify OSS support
		if use oss && ! use kernel_FreeBSD; then
			if ! has_version ">=media-sound/oss-4"; then
				eerror "You cannot build wine with USE=oss without having support from a"
				eerror "FreeBSD kernel or >=media-sound/oss-4 (only available through external repos)"
				eerror
				die
			fi
		fi

		if use mingw && use abi_x86_32 && ! has_version "cross-i686-w64-mingw32/gcc"; then
			eerror
			eerror "USE=\"mingw\" is currently experimental, and requires the"
			eerror "'cross-i686-w64-mingw32' compiler and its runtime for 32-bit builds."
			eerror
			eerror "These can be installed by using 'sys-devel/crossdev':"
			eerror
			eerror "crossdev --target i686-w64-mingw32"
			eerror
			eerror "For more information on setting up MinGW, see: https://wiki.gentoo.org/wiki/Mingw"
			eerror
			die "MinGW build was enabled, but no compiler to support it was found."
		fi

		if use mingw && use abi_x86_64 && ! has_version "cross-x86_64-w64-mingw32/gcc"; then
			eerror
			eerror "USE=\"mingw\" is currently experimental, and requires the"
			eerror "'cross-x86_64-w64-mingw32' compiler and its runtime for 64-bit builds."
			eerror
			eerror "These can be installed by using 'sys-devel/crossdev':"
			eerror
			eerror "crossdev --target x86_64-w64-mingw32"
			eerror
			eerror "For more information on setting up MinGW, see: https://wiki.gentoo.org/wiki/Mingw"
			eerror
			die "MinGW build was enabled, but no compiler to support it was found."
		fi
	fi
}

pkg_setup() {
	wine_build_environment_check || die
	wine_env_vcs_vars || die

	WINE_VARIANT="${PN#wine}-${MY_PV}"
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
	if [[ ${MY_PV} == "9999" ]] ; then
		EGIT_CHECKOUT_DIR="${S}" git-r3_src_unpack
		if use staging; then
			local CURRENT_WINE_COMMIT=${EGIT_VERSION}

			EGIT_CHECKOUT_DIR="${STAGING_DIR}" EGIT_REPO_URI="${STAGING_EGIT_REPO_URI}" git-r3_src_unpack

			local COMPAT_WINE_COMMIT=$("${STAGING_DIR}/patches/patchinstall.sh" --upstream-commit) || die

			if [[ "${CURRENT_WINE_COMMIT}" != "${COMPAT_WINE_COMMIT}" ]]; then
				einfo "The current Staging patchset is not guaranteed to apply on this WINE commit."
				einfo "If src_prepare fails, try emerging with the env var WINE_COMMIT."
				einfo "Example: EGIT_OVERRIDE_COMMIT_WINE=${COMPAT_WINE_COMMIT} emerge -1 wine"
			fi
		fi
	fi

	default

	l10n_find_plocales_changes "${S}/po" "" ".po"
}

src_prepare() {

	eapply_bin(){
		local patch
		for patch in ${PATCHES_BIN[@]}; do
			patchbin --nogit < "${patch}" || die
		done
	}

	local md5="$(md5sum server/protocol.def)"

	if use staging; then
		ewarn "Applying the Wine-Staging patchset. Any bug reports to the"
		ewarn "Wine bugzilla should explicitly state that staging was used."

		local STAGING_EXCLUDE="-W winemenubuilder-Desktop_Icon_Path" #652176
		use pipelight || STAGING_EXCLUDE="${STAGING_EXCLUDE} -W Pipelight"

		# Launch wine-staging patcher in a subshell, using eapply as a backend, and gitapply.sh as a backend for binary patches
		ebegin "Running Wine-Staging patch installer"
		(
			set -- DESTDIR="${S}" --backend=eapply --no-autoconf --all ${STAGING_EXCLUDE}
			cd "${STAGING_DIR}/patches"
			source "${STAGING_DIR}/patches/patchinstall.sh"
		)
		eend $? || die "Failed to apply Wine-Staging patches"
	fi

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

	l10n_get_locales > po/LINGUAS || die # otherwise wine doesn't respect LINGUAS

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
		l10n_for_each_disabled_locale_do rm_man_file "${f}"
	done < <(find -name "Makefile.in" -exec grep -q "UTF-8.man.in" "{}" \; -print)
}

src_configure() {
	wine_compiler_check || die

	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags
	if use mingw; then
		export CROSSCFLAGS="${CFLAGS}"
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
		$(use_with lcms cms)
		$(use_with cups)
		$(use_with udisks dbus)
		$(use_with faudio)
		$(use_with fontconfig)
		$(use_with ssl gnutls)
		$(use_enable gecko mshtml)
		$(use_with gcrypt)
		$(use_with gphoto2 gphoto)
		$(use_with gsm)
		$(use_with gssapi)
		$(use_with gstreamer)
		--without-hal
		$(use_with jpeg)
		$(use_with kerberos krb5)
		$(use_with ldap)
		# TODO: Will bug 685172 still need special handling?
		$(use_with mingw)
		$(use_enable mono mscoree)
		$(use_with mp3 mpg123)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with openal)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		$(use_with oss)
		$(use_with pcap)
		$(use_with png)
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
		$(use_with xml)
		$(use_with xml xslt)
	)

	use staging && myconf+=(
		--with-xattr
		$(use_with themes gtk3)
		$(use_with vaapi va)
	)

	local PKG_CONFIG AR RANLIB
	# Avoid crossdev's i686-pc-linux-gnu-pkg-config if building wine32 on amd64; #472038
	# set AR and RANLIB to make QA scripts happy; #483342
	tc-export PKG_CONFIG AR RANLIB

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
		Xemake test
	fi
}

multilib_src_install_all() {
	local DOCS=( ANNOUNCE AUTHORS README )
	add_locale_docs() {
		local locale_doc="documentation/README.$1"
		[[ ! -e ${locale_doc} ]] || DOCS+=( ${locale_doc} )
	}
	l10n_for_each_locale_do add_locale_docs

	einstalldocs
	prune_libtool_files --all

	if ! use perl ; then # winedump calls function_grep.pl, and winemaker is a perl script
		rm "${D%/}${MY_PREFIX}"/bin/{wine{dump,maker},function_grep.pl} \
			"${D%/}${MY_MANDIR}"/man1/wine{dump,maker}.1 || die
	fi

	# Remove wineconsole if neither backend is installed #551124
	if ! use X; then
		rm "${D%/}${MY_PREFIX}"/bin/wineconsole* || die
		rm "${D%/}${MY_MANDIR}"/man1/wineconsole* || die

		if ! use mingw; then
			rm_wineconsole() {
				rm "${D%/}/usr/$(get_libdir)/wine-${WINE_VARIANT}"/wine/{,fakedlls/}wineconsole.exe* || die
			}
		else
			rm_wineconsole() {
				rm "${D%/}/usr/$(get_libdir)/wine-${WINE_VARIANT}"/wine/wineconsole.exe* || die
			}
		fi

		multilib_foreach_abi rm_wineconsole
	fi

	use abi_x86_32 && pax-mark psmr "${D%/}${MY_PREFIX}"/bin/wine{,-preloader} #255055
	use abi_x86_64 && pax-mark psmr "${D%/}${MY_PREFIX}"/bin/wine64{,-preloader}

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
	for b in "${ED%/}${MY_PREFIX}"/bin/*; do
		make_wrapper "${b##*/}-${WINE_VARIANT}" "${MY_PREFIX}/bin/${b##*/}"
	done
	eshopts_pop
}

pkg_postinst() {
	eselect wine register ${PN}-${MY_PV}
	if [[ ${PN} == "wine-vanilla" ]]; then
		eselect wine register --vanilla ${PN}-${MY_PV} || die
	else
		if use staging; then
			eselect wine register --staging ${PN}-${MY_PV} || die
		fi
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
	eselect wine deregister ${PN}-${MY_PV}
	if [[ ${PN} == "wine-vanilla" ]]; then
		eselect wine deregister --vanilla ${PN}-${MY_PV} || die
	else
		if use staging; then
			eselect wine deregister --staging  ${PN}-${MY_PV}|| die
		fi
	fi

	eselect wine update --all --if-unset || die
}

pkg_postrm() {
	xdg_desktop_database_update
}
