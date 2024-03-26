# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOCONF="2.1"

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE='ncurses,sqlite,ssl,threads(+)'

LLVM_MAX_SLOT=17

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
# note - could not roll langpacks for: ca fi
#MOZ_LANGS=(ca cs de en-GB es-AR es-ES fi fr gl hu it ja lt nb-NO nl pl pt-PT
#	    ru sk sv-SE tr uk zh-CN zh-TW)
MOZ_LANGS=(cs de en-GB es-AR es-ES fr hu it ja lt nl pl pt-PT
	    ru sk sv-SE zh-CN zh-TW)

MOZ_PV="${PV}"
MOZ_PV="${MOZ_PV/_beta/b}"
MOZ_P="${P}"
MY_MOZ_P="${PN}-${MOZ_PV}"
PATCH_PV="2.53.18"
PATCH="${PN}-${PATCH_PV}-patches"
PATCH_S="${WORKDIR}/gentoo-${PN}-patches-${PATCH_PV}"

SRC_URI="https://archive.seamonkey-project.org/releases/${MOZ_PV}/source/${MY_MOZ_P}.source.tar.xz -> ${P}.source.tar.xz
	https://archive.seamonkey-project.org/releases/${MOZ_PV}/source/${MY_MOZ_P}.source-l10n.tar.xz -> ${P}.source-l10n.tar.xz
	https://github.com/BioMike/gentoo-${PN}-patches/archive/refs/tags/${PATCH_PV}.tar.gz -> ${PATCH}.tar.gz"

S="${WORKDIR}/${MY_MOZ_P}"

MOZ_GENERATE_LANGPACKS=1
MOZ_L10N_SOURCEDIR="${S}/${P}-l10n"
inherit autotools check-reqs desktop edos2unix flag-o-matic llvm mozcoreconf-v6 mozlinguas-v2 pax-utils \
	toolchain-funcs xdg-utils

DESCRIPTION="Seamonkey Web Browser"
HOMEPAGE="https://www.seamonkey-project.org/"

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
SYSTEM_IUSE=( +system-{av1,harfbuzz,icu,jpeg,libevent,libvpx,png,sqlite} )
IUSE="+chatzilla cpu_flags_arm_neon dbus +gmp-autoupdate +ipc jack
lto pulseaudio selinux startup-notification test webrtc wifi"
IUSE+=" ${SYSTEM_IUSE[@]}"
KEYWORDS="amd64 ~ppc64 x86"

RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/unzip
	app-arch/zip
	>=dev-lang/nasm-2.13
	dev-lang/perl
	dev-util/cbindgen
	>=sys-devel/binutils-2.16.1
	|| (
		(
			sys-devel/clang:16
			sys-devel/llvm:16
		)
		(
			sys-devel/clang:15
			sys-devel/llvm:15
		)
	)
	virtual/pkgconfig
	virtual/rust
	amd64? ( >=dev-lang/yasm-1.1 )
	lto? ( sys-devel/binutils[gold] )
	x86? ( >=dev-lang/yasm-1.1 )
"
COMMON_DEPEND="
	app-arch/bzip2
	>=app-accessibility/at-spi2-core-2.46.0
	>=dev-libs/glib-2.26:2
	>=dev-libs/libffi-3.0.10:=
	>=dev-libs/nspr-4.23
	>=dev-libs/nss-3.47.1
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	>=media-libs/mesa-10.2:=
	>=sys-libs/zlib-1.2.3
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libxcb:=
	>=x11-libs/pango-1.22.0
	x11-libs/pixman
	media-video/ffmpeg
	virtual/freedesktop-icon-theme
	dbus? (
		>=dev-libs/dbus-glib-0.72
		>=sys-apps/dbus-0.60
	)
	jack? ( virtual/jack )
	kernel_linux? ( !pulseaudio? ( media-libs/alsa-lib ) )
	pulseaudio? ( || (
		media-libs/libpulse
		>=media-sound/apulse-0.1.9
	) )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	system-av1? (
		>=media-libs/dav1d-0.3.0:=
		>=media-libs/libaom-1.0.0:=
	)
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.9-r1
		>=media-libs/harfbuzz-1.3.3:0=
	)
	system-icu? ( >=dev-libs/icu-59.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0= )
	system-libvpx? ( >=media-libs/libvpx-1.8.0:0=[postproc] )
	system-png? ( >=media-libs/libpng-1.6.31:0=[apng] )
	system-sqlite? ( >=dev-db/sqlite-3.38.2:3[secure-delete] )
	wifi? (
		kernel_linux? (
			>=dev-libs/dbus-glib-0.72
			net-misc/networkmanager
			>=sys-apps/dbus-0.60
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-mozilla )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	amd64? ( virtual/opengl )
	x86? ( virtual/opengl )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	pthread_cond_timedwait_monotonic_np # Doesn't exist on Linux. Bug #905825
)

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
[[ -z ${GMP_PLUGIN_LIST} ]] && GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )

BUILD_OBJ_DIR="${S}/seamonk"

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
		einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build." >&2
}

pkg_setup() {
	if [[ ${PV} == *_beta* ]] || [[ ${PV} == *_pre* ]] ; then
		ewarn
		ewarn "You're using an unofficial release of ${PN}. Don't file any bug in"
		ewarn "Gentoo's Bugtracker against this package in case it breaks for you."
		ewarn "Those belong to upstream: https://bugzilla.mozilla.org"
	fi

	llvm_pkg_setup

	moz_pkgsetup
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use lto || use test ; then
		CHECKREQS_DISK_BUILD="16G"
	else
		CHECKREQS_DISK_BUILD="12G"
	fi
	check-reqs_pkg_setup
}

spkg_setup() {
	# Ensure we have enough disk space to compile
	if use lto || use test ; then
		CHECKREQS_DISK_BUILD="16G"
	else
		CHECKREQS_DISK_BUILD="12G"
	fi
	check-reqs_pkg_setup
}

src_unpack() {
	local l10n_sources="${P}.source-l10n.tar.xz"
	unpack ${A/ ${l10n_sources}}

	mkdir "${S}/${P}-l10n" || die
	cd "${S}/${P}-l10n" || die
	unpack ${l10n_sources}
}

src_prepare() {
	# Apply our patches
	eapply "${PATCH_S}/${PN}"

	# Shell scripts sometimes contain DOS line endings; bug 391889
	grep -rlZ --include="*.sh" $'\r$' . |
	while read -r -d $'\0' file ; do
		einfo edos2unix "${file}"
		edos2unix "${file}"
	done

	if use system-libvpx ; then
		eapply -p2 "${PATCH_S}/USE_flag/1009_seamonkey-2.53.3-system_libvpx-1.8.patch"
	fi

	# Fix for building on x86 https://bugs.gentoo.org/915336 (x86-only)
	if use x86 ; then
		eapply -p1 "${PATCH_S}/USE_flag/2021_seamonkey_2.53.17-floating-point_normalization_on_x86_build_fix.patch"
	fi

	# Patch for people who use their systems ICU 74
	if has_version ">=dev-libs/icu-74.1" && use system-icu ; then
		eapply -p1 "${PATCH_S}/USE_flag/2022-bmo-1862601-system-icu-74.patch"
	fi

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Fix wrong include, as suggested by SM upstream.
	sed -e 's|#include \"RemoteSpellCheckEngineChild.h\"|#include \"mozilla/RemoteSpellCheckEngineChild.h\"|' \
		-i extensions/spellcheck/src/mozSpellChecker.h || die

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/$(get_libdir)/mozilla/plugins:/usr/$(get_libdir)/${PN}/plugins:" \
		xpcom/io/nsAppFileLocationProvider.cpp || die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i comm/suite/installer/Makefile.in || die
	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i toolkit/mozapps/installer/packager.mk || die

	# Don't build libs-% locale files for chatzilla if we are not building chatzilla
	# (this is hard-coded in the build system at present rather than being based on configuration)
	if ! use chatzilla ; then
		sed '/extensions\/irc\/locales libs-/s@^@#@' \
			-i comm/suite/locales/Makefile.in || die
	fi

	eautoreconf old-configure.in
	cd js/src || die
	eautoconf old-configure.in
}

src_configure() {
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	######################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	######################################

	mozconfig_init

	##################################
	# Former mozconfig_config() part #
	##################################

	# Migrated from mozcoreconf-2
	mozconfig_annotate 'system_libs' --with-system-bz2
	mozconfig_annotate 'system_libs' --with-system-zlib
	mozconfig_annotate 'system_libs' --enable-system-pixman

	# Disable for testing purposes only
	mozconfig_annotate 'Upstream bug 1341234' --disable-stylo

	# Must pass release in order to properly select linker via gold useflag
	mozconfig_annotate 'Enable by Gentoo' --enable-release

	# Broken on PPC64, but outdated and should not be used according to upstream.
	mozconfig_annotate 'Outdated and broken, disabled' --disable-jemalloc

	# Must pass --enable-gold if using ld.gold
	if tc-ld-is-gold ; then
		mozconfig_annotate 'tc-ld-is-gold=true' --enable-gold
	else
		mozconfig_annotate 'tc-ld-is-gold=false' --disable-gold
	fi

	# Debug is broken, disable debug symbols
	mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols

	mozconfig_use_enable startup-notification

	# wifi pulls in dbus so manage both here
	mozconfig_use_enable wifi necko-wifi
	if use kernel_linux && use wifi && ! use dbus ; then
		echo "Enabling dbus support due to wifi request"
		mozconfig_annotate 'dbus required by necko-wifi on linux' --enable-dbus
	else
		mozconfig_use_enable dbus
		mozconfig_annotate 'disabled' --disable-necko-wifi
	fi

	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${ESYSROOT}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${ESYSROOT}"/usr
	mozconfig_annotate '' --x-includes="${ESYSROOT}"/usr/include --x-libraries="${ESYSROOT}"/usr/$(get_libdir)
	if use system-libevent ; then
		mozconfig_annotate '' --with-system-libevent="${ESYSROOT}"/usr
	fi
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate '' --disable-gconf
	mozconfig_annotate '' --with-intl-api

	# default toolkit is cairo-gtk3, optional use flags can change this
	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk3

	# Instead of the standard --build= and --host=, mozilla uses --host instead
	# of --build, and --target intstead of --host.
	# Note, mozilla also has --build but it does not do what you think it does.
	# Set both --target and --host as mozilla uses python to guess values otherwise
	mozconfig_annotate '' --target="${CHOST}"
	mozconfig_annotate '' --host="${CBUILD:-${CHOST}}"

	mozconfig_use_enable pulseaudio
	# force the deprecated alsa sound code if pulseaudio is disabled
	if use kernel_linux && ! use pulseaudio ; then
		mozconfig_annotate '-pulseaudio' --enable-alsa
	fi

	# For testing purpose only
	mozconfig_annotate 'Sandbox' --enable-content-sandbox

	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-png
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-av1

	# Modifications to better support ARM, bug 553364
	if use cpu_flags_arm_neon ; then
		mozconfig_annotate '' --with-fpu=neon
		mozconfig_annotate '' --with-thumb=yes
		mozconfig_annotate '' --with-thumb-interwork=no
	fi
	if [[ ${CHOST} == armv* ]] ; then
		mozconfig_annotate '' --with-float-abi=hard
		if ! use system-libvpx ; then
			sed -i -e "s|softfp|hard|" media/libvpx/moz.build || die
		fi
	fi

	if use lto ; then
		# Linking only works when using ld.gold when LTO is enabled
		mozconfig_annotate "forcing ld=gold due to USE=lto" --enable-linker=gold
		# ThinLTO is currently broken, see bmo#1644409
		mozconfig_annotate '+lto' --enable-lto=full
	else
		if tc-ld-is-gold ; then
			mozconfig_annotate "linker is set to gold" --enable-linker=gold
		else
			mozconfig_annotate "linker is set to bfd" --enable-linker=bfd
		fi
	fi
	# LTO flag was handled via configure
	filter-lto

	##################################
	# Former mozconfig_config() end  #
	##################################

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Linking fails without this due to memory exhaustion
	use x86 && append-ldflags "-Wl,--no-keep-memory"

	# Setup api key for location services
	printf '%s' "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-location-service-api-keyfile="${S}/google-api-key"
	mozconfig_annotate '' --with-google-safebrowsing-api-keyfile="${S}/google-api-key"

	mozconfig_use_enable chatzilla irc
	mozconfig_annotate '' --enable-dominspector

	# use startup-cache for faster startup time
	mozconfig_annotate '' --enable-startupcache

	# Elf-hack is known to be broken on multiple archs.
	# Disable it by default, because on the archs that still work,
	# it also gives more problems than it solves.
	# https://bugs.gentoo.org/851933
	# https://bugzilla.mozilla.org/show_bug.cgi?id=1706264
	if use x86 || use arm64 || use arm || use amd64 ; then
		mozconfig_annotate 'elf-hack is broken' --disable-elf-hack
	fi

	# Disabled by default. See bug 836319 , comment 17.
	if ! use webrtc ; then
	    mozconfig_annotate "disabled by Gentoo" --disable-webrtc
	fi

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig || die
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig || die

	mozlinguas_mozconfig

	# Finalize and report settings
	mozconfig_final

	# Work around breakage in makeopts with --no-print-directory
	MAKEOPTS="${MAKEOPTS/--no-print-directory/}"

	if use amd64 || use x86 ; then
		append-flags -mno-avx
	fi

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"
	# Use system's Python environment
	export MACH_USE_SYSTEM_PYTHON=1
	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# workaround for funky/broken upstream configure...
	export SHELL="${SHELL:-${EPREFIX}/bin/bash}"
	#emake V=1 -f client.mk configure
	./mach configure || die
}

src_compile() {
	#MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL}" \
	#emake V=1 -f client.mk
	./mach build --verbose || die

	mozlinguas_src_compile
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	DICTPATH="\"${EPREFIX}/usr/share/myspell\""

	local emid
	pushd "${BUILD_OBJ_DIR}" &>/dev/null || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m dist/bin/xpcshell

	# Copy our preference before omnijar is created.
	sed "s|SEAMONKEY_PVR|${PVR}|" "${FILESDIR}"/all-gentoo-1.js > \
		dist/bin/defaults/pref/all-gentoo.js \
		|| die

	# Set default path to search for dictionaries.
	echo "pref(\"spellchecker.dictionary_path\", ${DICTPATH});" \
		>> dist/bin/defaults/pref/all-gentoo.js \
		|| die

	echo 'pref("extensions.autoDisableScopes", 3);' >> \
		dist/bin/defaults/pref/all-gentoo.js \
		|| die

	local plugin
	if ! use gmp-autoupdate ; then
		for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
			echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
				dist/bin/defaults/pref/all-gentoo.js || die
		done
	fi

	popd &>/dev/null || die

	#MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
	#emake DESTDIR="${D}" install
	DESTDIR="${D}" ./mach install || die
	MOZ_P="${MY_MOZ_P}" mozlinguas_src_install

	cp "${FILESDIR}"/${PN}.desktop "${T}" || die

	sed 's|^\(MimeType=.*\)$|\1text/x-vcard;text/directory;application/mbox;message/rfc822;x-scheme-handler/mailto;|' \
		-i "${T}"/${PN}.desktop || die
	sed 's|^\(Categories=.*\)$|\1Email;|' -i "${T}"/${PN}.desktop \
		|| die

	# Install icon and .desktop for menu entry
	newicon "${S}"/comm/suite/branding/${PN}/default64.png ${PN}.png
	domenu "${T}"/${PN}.desktop

	# Required in order to use plugins and even run seamonkey on hardened.
	pax-mark m "${ED}"/${MOZILLA_FIVE_HOME}/{seamonkey,seamonkey-bin,plugin-container}

	if use chatzilla ; then
		local emid='{59c81df5-4b7a-477b-912d-4e0fdf64e5f2}'

		# remove the en_US-only xpi file so a version with all requested locales can be installed
		if [[ -e "${ED}"/${MOZILLA_FIVE_HOME}/extensions/${emid}.xpi ]] ; then
			rm -f "${ED}"/${MOZILLA_FIVE_HOME}/extensions/${emid}.xpi || die
		fi

		# merge the extra locales into the main extension
		mozlinguas_xpistage_langpacks dist/xpi-stage/chatzilla

		# install the merged extension
		mkdir -p "${T}/${emid}" || die
		cp -RLp -t "${T}/${emid}" dist/xpi-stage/chatzilla/* || die
		insinto ${MOZILLA_FIVE_HOME}/extensions
		doins -r "${T}/${emid}"
	fi

	# Provide a place for plugins
	keepdir "${MOZILLA_FIVE_HOME}/plugins"

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}*" >> "${T}"/11${PN} || die
	doins "${T}"/11${PN}
}

pkg_preinst() {
	SEAMONKEY_PLUGINS_DIR="${EROOT}/usr/$(get_libdir)/${PN}/plugins"

	if [[ -L "${SEAMONKEY_PLUGINS_DIR}" ]] ; then
		rm "${SEAMONKEY_PLUGINS_DIR}" || die
	fi
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	xdg_desktop_database_update

	if ! use gmp-autoupdate ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do
			elog "\t ${plugin}" ;
		 done
	fi

	if use chatzilla ; then
		elog "chatzilla is now an extension which can be en-/disabled and configured via"
		elog "the Add-on manager."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
