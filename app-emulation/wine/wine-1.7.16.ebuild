# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-1.7.16.ebuild,v 1.6 2015/06/14 16:18:11 ulm Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
PLOCALES="ar bg ca cs da de el en en_US eo es fa fi fr he hi hr hu it ja ko lt ml nb_NO nl or pa pl pt_BR pt_PT rm ro ru sk sl sr_RS@cyrillic sr_RS@latin sv te th tr uk wa zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit autotools-multilib eutils fdo-mime flag-o-matic gnome2-utils l10n multilib pax-utils toolchain-funcs virtualx

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://source.winehq.org/git/wine.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="mirror://sourceforge/${PN}/Source/${MY_P}.tar.bz2"
	KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
	S=${WORKDIR}/${MY_P}
fi

GV="2.24"
MV="4.5.2"
PULSE_PATCHES="winepulse-patches-1.7.12"
WINE_GENTOO="wine-gentoo-2013.06.24"
DESCRIPTION="Free implementation of Windows(tm) on Unix"
HOMEPAGE="http://www.winehq.org/"
SRC_URI="${SRC_URI}
	gecko? (
		abi_x86_32? ( mirror://sourceforge/${PN}/Wine%20Gecko/${GV}/wine_gecko-${GV}-x86.msi )
		abi_x86_64? ( mirror://sourceforge/${PN}/Wine%20Gecko/${GV}/wine_gecko-${GV}-x86_64.msi )
	)
	mono? ( mirror://sourceforge/${PN}/Wine%20Mono/${MV}/wine-mono-${MV}.msi )
	pulseaudio? ( http://dev.gentoo.org/~tetromino/distfiles/${PN}/${PULSE_PATCHES}.tar.bz2 )
	http://dev.gentoo.org/~tetromino/distfiles/${PN}/${WINE_GENTOO}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+abi_x86_32 +abi_x86_64 +alsa capi cups custom-cflags dos elibc_glibc +fontconfig +gecko gphoto2 gsm gstreamer +jpeg lcms ldap +mono mp3 ncurses netapi nls odbc openal opencl +opengl osmesa oss +perl +png +prelink pulseaudio +realtime +run-exes samba scanner selinux +ssl test +threads +truetype +udisks v4l +X xcomposite xinerama +xml"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )
	test? ( abi_x86_32 )
	elibc_glibc? ( threads )
	mono? ( abi_x86_32 )
	osmesa? ( opengl )" #286560

# FIXME: the test suite is unsuitable for us; many tests require net access
# or fail due to Xvfb's opengl limitations.
RESTRICT="test"

NATIVE_DEPEND="
	truetype? ( >=media-libs/freetype-2.0.0  )
	capi? ( net-dialup/capi4k-utils )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	udisks? ( sys-apps/dbus )
	fontconfig? ( media-libs/fontconfig:= )
	gphoto2? ( media-libs/libgphoto2:= )
	openal? ( media-libs/openal:= )
	gstreamer? ( media-libs/gstreamer:0.10 media-libs/gst-plugins-base:0.10 )
	X? (
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	xinerama? ( x11-libs/libXinerama )
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups:= )
	opencl? ( virtual/opencl )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	gsm? ( media-sound/gsm:= )
	jpeg? ( virtual/jpeg:0= )
	ldap? ( net-nds/openldap:= )
	lcms? ( media-libs/lcms:2= )
	mp3? ( >=media-sound/mpg123-1.5.0 )
	netapi? ( net-fs/samba[netapi(+)] )
	nls? ( sys-devel/gettext )
	odbc? ( dev-db/unixODBC:= )
	osmesa? ( media-libs/mesa[osmesa] )
	pulseaudio? ( media-sound/pulseaudio )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	scanner? ( media-gfx/sane-backends:= )
	ssl? ( net-libs/gnutls:= )
	png? ( media-libs/libpng:0= )
	v4l? ( media-libs/libv4l )
	xcomposite? ( x11-libs/libXcomposite )"

COMMON_DEPEND="
	!amd64? ( ${NATIVE_DEPEND} )
	amd64? (
		abi_x86_64? ( ${NATIVE_DEPEND} )
		abi_x86_32? (
			truetype? ( >=media-libs/freetype-2.5.0.1[abi_x86_32(-)] )
			ncurses? ( >=sys-libs/ncurses-5.9-r3[abi_x86_32(-)] )
			udisks? ( >=sys-apps/dbus-1.6.18-r1[abi_x86_32(-)] )
			fontconfig? ( >=media-libs/fontconfig-2.10.92[abi_x86_32(-)] )
			gphoto2? ( >=media-libs/libgphoto2-2.5.3.1[abi_x86_32(-)] )
			openal? ( >=media-libs/openal-1.15.1[abi_x86_32(-)] )
			gstreamer? (
				>=media-libs/gstreamer-0.10.36-r2:0.10[abi_x86_32(-)]
				>=media-libs/gst-plugins-base-0.10.36:0.10[abi_x86_32(-)]
			)
			X? (
				>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
				>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
				>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
				>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
				>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]
			)
			xinerama? ( >=x11-libs/libXinerama-1.1.3[abi_x86_32(-)] )
			alsa? ( >=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)] )
			cups? ( >=net-print/cups-1.7.1-r1[abi_x86_32(-)] )
			opencl? ( >=virtual/opencl-0-r3[abi_x86_32(-)] )
			opengl? (
				>=virtual/glu-9.0-r1[abi_x86_32(-)]
				>=virtual/opengl-7.0-r1[abi_x86_32(-)]
			)
			gsm? ( >=media-sound/gsm-1.0.13-r1[abi_x86_32(-)] )
			jpeg? ( >=virtual/jpeg-0-r2:0[abi_x86_32(-)] )
			ldap? ( >=net-nds/openldap-2.4.38-r1:=[abi_x86_32(-)] )
			lcms? ( >=media-libs/lcms-2.5:2[abi_x86_32(-)] )
			mp3? ( >=media-sound/mpg123-1.15.4[abi_x86_32(-)] )
			nls? ( >=sys-devel/gettext-0.18.3.2[abi_x86_32(-)] )
			odbc? ( >=dev-db/unixODBC-2.3.2:=[abi_x86_32(-)] )
			osmesa? ( >=media-libs/mesa-9.1.6[osmesa,abi_x86_32(-)] )
			pulseaudio? ( >=media-sound/pulseaudio-5.0[abi_x86_32(-)] )
			xml? (
				>=dev-libs/libxml2-2.9.1-r4[abi_x86_32(-)]
				>=dev-libs/libxslt-1.1.28-r1[abi_x86_32(-)]
			)
			scanner? ( >=media-gfx/sane-backends-1.0.23:=[abi_x86_32(-)] )
			ssl? ( >=net-libs/gnutls-2.12.23-r6:=[abi_x86_32(-)] )
			png? ( >=media-libs/libpng-1.6.10:0[abi_x86_32(-)] )
			v4l? ( >=media-libs/libv4l-0.9.5[abi_x86_32(-)] )
			xcomposite? ( >=x11-libs/libXcomposite-0.4.4-r1[abi_x86_32(-)] )
		)
	)"

RDEPEND="${COMMON_DEPEND}
	dos? ( games-emulation/dosbox )
	perl? ( dev-lang/perl dev-perl/XML-Simple )
	samba? ( >=net-fs/samba-3.0.25 )
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )
	pulseaudio? ( realtime? ( sys-auth/rtkit ) )"

DEPEND="${COMMON_DEPEND}
	amd64? ( abi_x86_32? ( !abi_x86_64? ( ${NATIVE_DEPEND} ) ) )
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	xinerama? ( x11-proto/xineramaproto )
	prelink? ( sys-devel/prelink )
	>=sys-kernel/linux-headers-2.6
	virtual/pkgconfig
	virtual/yacc
	sys-devel/flex"

# These use a non-standard "Wine" category, which is provided by
# /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="usr/share/applications/wine-browsedrive.desktop
usr/share/applications/wine-notepad.desktop
usr/share/applications/wine-uninstaller.desktop
usr/share/applications/wine-winecfg.desktop"

wine_build_environment_check() {
	[[ ${MERGE_TYPE} = "binary" ]] && return 0

	if use abi_x86_64 && [[ $(( $(gcc-major-version) * 100 + $(gcc-minor-version) )) -lt 404 ]]; then
		eerror "You need gcc-4.4+ to build 64-bit wine"
		eerror
		return 1
	fi

	if use abi_x86_32 && use opencl && [[ x$(eselect opencl show 2> /dev/null) = "xintel" ]]; then
		eerror "You cannot build wine with USE=opencl because intel-ocl-sdk is 64-bit only."
		eerror "See https://bugs.gentoo.org/487864 for more details."
		eerror
		return 1
	fi
}

pkg_pretend() {
	wine_build_environment_check || die
}

pkg_setup() {
	wine_build_environment_check || die
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
	else
		unpack ${MY_P}.tar.bz2
	fi

	use pulseaudio && unpack "${PULSE_PATCHES}.tar.bz2"
	unpack "${WINE_GENTOO}.tar.bz2"

	l10n_find_plocales_changes "${S}/po" "" ".po"
}

src_prepare() {
	local md5="$(md5sum server/protocol.def)"
	local PATCHES=(
		"${FILESDIR}"/${PN}-1.5.26-winegcc.patch #260726
		"${FILESDIR}"/${PN}-1.4_rc2-multilib-portage.patch #395615
		"${FILESDIR}"/${PN}-1.7.12-osmesa-check.patch #429386
		"${FILESDIR}"/${PN}-1.6-memset-O3.patch #480508
	)
	use pulseaudio && PATCHES+=(
		"../${PULSE_PATCHES}"/*.patch #421365
	)

	autotools-utils_src_prepare

	if [[ "$(md5sum server/protocol.def)" != "${md5}" ]]; then
		einfo "server/protocol.def was patched; running tools/make_requests"
		tools/make_requests || die #432348
	fi
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	if ! use run-exes; then
		sed -i '/^MimeType/d' tools/wine.desktop || die #117785
	fi

	# hi-res default icon, #472990, http://bugs.winehq.org/show_bug.cgi?id=24652
	cp "${WORKDIR}"/${WINE_GENTOO}/icons/oic_winlogo.ico dlls/user32/resources/ || die

	l10n_get_locales > po/LINGUAS # otherwise wine doesn't respect LINGUAS
}

do_configure() {
	local myeconfargs=( "${myeconfargs[@]}" )

	if use amd64; then
		if [[ ${ABI} == amd64 ]]; then
			myeconfargs+=( --enable-win64 )
		else
			use netapi && ewarn "Disabling netapi in wine32; see https://bugs.gentoo.org/494394"
			# We currently don't have 32-bit libnetapi on amd64; #494394
			myeconfargs+=(
				--without-netapi
				--disable-win64
			)
		fi

		# Note: using --with-wine64 results in problems with multilib.eclass
		# CC/LD hackery. We're using separate tools instead.
	fi

	autotools-utils_src_configure
}

src_configure() {
	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags

	local myeconfargs=( # common
		--sysconfdir=/etc/wine
		$(use_with alsa)
		$(use_with capi)
		$(use_with lcms cms)
		$(use_with cups)
		$(use_with ncurses curses)
		$(use_with udisks dbus)
		$(use_with fontconfig)
		$(use_with ssl gnutls)
		$(use_with gphoto2 gphoto)
		$(use_with gsm)
		$(use_with gstreamer)
		--without-hal
		$(use_with jpeg)
		$(use_with ldap)
		$(use_with mp3 mpg123)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with openal)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		$(use_with oss)
		$(use_with png)
		$(use_with threads pthread)
		$(use_with scanner sane)
		$(use_enable test tests)
		$(use_with truetype freetype)
		$(use_with v4l)
		$(use_with X x)
		$(use_with xcomposite)
		$(use_with xinerama)
		$(use_with xml)
		$(use_with xml xslt)
	)

	use pulseaudio && myeconfargs+=( --with-pulse )

	if use amd64 && use abi_x86_32; then
		# Avoid crossdev's i686-pc-linux-gnu-pkg-config if building wine32 on amd64; #472038
		# set AR and RANLIB to make QA scripts happy; #483342
		tc-export PKG_CONFIG AR RANLIB
	fi

	multilib_parallel_foreach_abi do_configure
}

src_compile() {
	autotools-multilib_src_compile depend
	autotools-multilib_src_compile all
}

src_test() {
	if [[ $(id -u) == 0 ]]; then
		ewarn "Skipping tests since they cannot be run under the root user."
		ewarn "To run the test ${PN} suite, add userpriv to FEATURES in make.conf"
		return
	fi

	# FIXME: win32-only; wine64 tests fail with "could not find the Wine loader"
	multilib_toolchain_setup x86
	local BUILD_DIR="${S}-${ABI}"
	cd "${BUILD_DIR}" || die
	WINEPREFIX="${T}/.wine-${ABI}" Xemake test
}

src_install() {
	local DOCS=( ANNOUNCE AUTHORS README )
	add_locale_docs() {
		local locale_doc="documentation/README.$1"
		[[ ! -e ${locale_doc} ]] || DOCS=( "${DOCS[@]}" ${locale_doc} )
	}
	l10n_for_each_locale_do add_locale_docs
	autotools-multilib_src_install

	emake -C "../${WINE_GENTOO}" install DESTDIR="${D}" EPREFIX="${EPREFIX}"
	if use gecko ; then
		insinto /usr/share/wine/gecko
		use abi_x86_32 && doins "${DISTDIR}"/wine_gecko-${GV}-x86.msi
		use abi_x86_64 && doins "${DISTDIR}"/wine_gecko-${GV}-x86_64.msi
	fi
	if use mono ; then
		insinto /usr/share/wine/mono
		doins "${DISTDIR}"/wine-mono-${MV}.msi
	fi
	if ! use perl ; then
		rm "${D}"usr/bin/{wine{dump,maker},function_grep.pl} "${D}"usr/share/man/man1/wine{dump,maker}.1 || die
	fi

	use abi_x86_32 && pax-mark psmr "${D}"usr/bin/wine{,-preloader} #255055
	use abi_x86_64 && pax-mark psmr "${D}"usr/bin/wine64{,-preloader}

	if use abi_x86_64 && ! use abi_x86_32; then
		dosym /usr/bin/wine{64,} # 404331
		dosym /usr/bin/wine{64,}-preloader
	fi

	# respect LINGUAS when installing man pages, #469418
	for l in de fr pl; do
		use linguas_${l} || rm -r "${D}"usr/share/man/${l}*
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
