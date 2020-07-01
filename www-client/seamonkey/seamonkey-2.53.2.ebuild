# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='ncurses,sqlite,ssl,threads(+)'

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
# note - could not roll langpacks for: ca fi
#MOZ_LANGS=(ca cs de en-GB es-AR es-ES fi fr gl hu it ja lt nb-NO nl pl pt-PT
#	    ru sk sv-SE tr uk zh-CN zh-TW)
MOZ_LANGS=(cs de en-GB es-AR es-ES fr hu it ja lt nl pl pt-PT
	    ru sk sv-SE zh-CN zh-TW)

MOZ_PV="${PV/_pre*}"
MOZ_PV="${MOZ_PV/_alpha/a}"
MOZ_PV="${MOZ_PV/_beta/b}"
MOZ_PV="${MOZ_PV/_rc/rc}"
MOZ_PV="${MOZ_PV/_p[0-9]}"
MOZ_P="${P}"
MY_MOZ_P="${PN}-${MOZ_PV}"

if [[ ${PV} == *_pre* ]] ; then
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/candidates/${MOZ_PV}-candidates/build${PV##*_pre}"
else
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/releases/${MOZ_PV}"
fi

S="${WORKDIR}/${MY_MOZ_P}"
SRC_URI="${MOZ_HTTP_URI}/source/${MY_MOZ_P}.source.tar.xz -> ${P}.source.tar.xz
	${MOZ_HTTP_URI}/source/${MY_MOZ_P}.source-l10n.tar.xz -> ${P}.source-l10n.tar.xz"

MOZ_GENERATE_LANGPACKS=1
MOZ_L10N_SOURCEDIR="${S}/${P}-l10n"
inherit autotools check-reqs flag-o-matic mozcoreconf-v6 mozextension mozlinguas-v2 nsplugins pax-utils toolchain-funcs xdg-utils

PATCH="${PN}-2.53.2-patches-01"

DESCRIPTION="Seamonkey Web Browser"
HOMEPAGE="http://www.seamonkey-project.org"
KEYWORDS="amd64 ~ppc64 x86"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="+calendar +chatzilla +crypt dbus debug +gmp-autoupdate +ipc jack minimal
neon pulseaudio +roaming selinux startup-notification system-harfbuzz system-icu
system-jpeg system-libevent system-sqlite system-libvpx test wifi"
RESTRICT="!test? ( test )"

SRC_URI+="
	https://dev.gentoo.org/~polynomial-c/mozilla/patchsets/${PATCH}.tar.xz
"

ASM_DEPEND=">=dev-lang/yasm-1.1"

DEPEND="
	>=app-text/hunspell-1.5.4:=
	dev-libs/atk
	>=dev-libs/glib-2.26:2
	>=dev-libs/libffi-3.0.10:=
	>=dev-libs/nspr-4.23
	>=dev-libs/nss-3.47.1
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	>=media-libs/libpng-1.6.31:0=[apng]
	>=media-libs/mesa-10.2:=
	>=sys-libs/zlib-1.2.3
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/pango-1.22.0
	>=x11-libs/pixman-0.19.2
	media-video/ffmpeg
	virtual/freedesktop-icon-theme
	dbus? (
		>=dev-libs/dbus-glib-0.72
		>=sys-apps/dbus-0.60
	)
	jack? ( virtual/jack )
	crypt? ( <x11-plugins/enigmail-2.1.0 )
	kernel_linux? ( !pulseaudio? ( media-libs/alsa-lib ) )
	pulseaudio? ( || (
		media-sound/pulseaudio
		>=media-sound/apulse-0.1.9
	) )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.9-r1
		>=media-libs/harfbuzz-1.3.3:0=
	)
	system-icu? ( >=dev-libs/icu-59.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0= )
	system-libvpx? ( >=media-libs/libvpx-1.5.0:0=[postproc] )
	system-sqlite? ( >=dev-db/sqlite-3.19.3:3[secure-delete,debug=] )
	wifi? (
		kernel_linux? (
			>=dev-libs/dbus-glib-0.72
			net-misc/networkmanager
			>=sys-apps/dbus-0.60
		)
	)
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-mozilla )
"
# Convert to BDEPEND once the ebuild goes EAPI-7
DEPEND+="
	app-arch/unzip
	app-arch/zip
	dev-lang/perl
	sys-apps/findutils
	>=sys-devel/binutils-2.16.1
	virtual/pkgconfig
	>=virtual/rust-1.34.0
	amd64? (
		${ASM_DEPEND}
		virtual/opengl
	)
	x86? (
		${ASM_DEPEND}
		virtual/opengl
	)
"

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z $GMP_PLUGIN_LIST ]] ; then
	GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

BUILD_OBJ_DIR="${S}/seamonk"

pkg_setup() {
	if [[ ${PV} == *_pre* ]] ; then
		ewarn "You're using an unofficial release of ${PN}. Don't file any bug in"
		ewarn "Gentoo's Bugtracker against this package in case it breaks for you."
		ewarn "Those belong to upstream: https://bugzilla.mozilla.org"
	fi

	moz_pkgsetup
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use debug || use test ; then
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
	eapply "${WORKDIR}"/seamonkey

	# browser patches go here
	pushd "${S}"/mozilla &>/dev/null || die
	eapply "${WORKDIR}"/firefox
	popd &>/dev/null || die

	# Shell scripts sometimes contain DOS line endings; bug 391889
	grep -rlZ --include="*.sh" $'\r$' . |
	while read -r -d $'\0' file ; do
		einfo edos2unix "${file}"
		edos2unix "${file}"
	done

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	local ms="${S}/mozilla"

	# Don't error for format with gcc-9
	grep -rl -- '-Werror=format' | xargs sed -i 's/error=format/no-&/' || die "sed failed"

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${ms}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${ms}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${ms}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/suite/installer/Makefile.in || die
	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${ms}"/toolkit/mozapps/installer/packager.mk || die

	# Don't build libs-% locale files for chatzilla if we are not building chatzilla
	# (this is hard-coded in the build system at present rather than being based on configuration)
	if ! use chatzilla ; then
		sed '/extensions\/irc\/locales libs-/s@^@#@' \
			-i "${S}"/suite/locales/Makefile.in || die
	fi

	eautoreconf old-configure.in
	cd "${S}"/mozilla || die
	eautoconf old-configure.in
	cd "${S}"/mozilla/js/src || die
	eautoconf old-configure.in
}

src_configure() {
	MEXTENSIONS="default"
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init

	##################################
	# Former mozconfig_config() part #
	##################################

	# Migrated from mozcoreconf-2
	mozconfig_annotate 'system_libs' --with-system-bz2
	mozconfig_annotate 'system_libs' --with-system-zlib

	# Disable for testing purposes only
	mozconfig_annotate 'Upstream bug 1341234' --disable-stylo

	# Must pass release in order to properly select linker via gold useflag
	mozconfig_annotate 'Enable by Gentoo' --enable-release

	# Must pass --enable-gold if using ld.gold
	if tc-ld-is-gold ; then
		mozconfig_annotate 'tc-ld-is-gold=true' --enable-gold
	else
		mozconfig_annotate 'tc-ld-is-gold=false' --disable-gold
	fi

	# Enable position independent executables
	mozconfig_annotate 'enabled by Gentoo' --enable-pie

	mozconfig_use_enable debug
	mozconfig_use_enable debug tests
	if ! use debug ; then
		mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols
	else
		mozconfig_annotate 'enabled by Gentoo' --enable-debug-symbols
	fi

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
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${SYSROOT}${EPREFIX}"/usr/include --x-libraries="${SYSROOT}${EPREFIX}"/usr/$(get_libdir)
	if use system-libevent ; then
		mozconfig_annotate '' --with-system-libevent="${SYSROOT}${EPREFIX}"/usr
	fi
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate 'Gentoo default' --enable-system-hunspell
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate 'Gentoo default' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate '' --disable-gconf
	mozconfig_annotate '' --with-intl-api

	# skia has no support for big-endian platforms
	if [[ $(tc-endian) == "big" ]] ; then
		mozconfig_annotate 'big endian target' --disable-skia
	else
		mozconfig_annotate '' --enable-skia
	fi

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
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2

	# Modifications to better support ARM, bug 553364
	if use neon ; then
		mozconfig_annotate '' --with-fpu=neon
		mozconfig_annotate '' --with-thumb=yes
		mozconfig_annotate '' --with-thumb-interwork=no
	fi
	if [[ ${CHOST} == armv* ]] ; then
		mozconfig_annotate '' --with-float-abi=hard
		if ! use system-libvpx ; then
			sed -i -e "s|softfp|hard|" \
				"${S}"/mozilla/media/libvpx/moz.build \
				|| die
		fi
	fi
	##################################
	# Former mozconfig_config() end  #
	##################################

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Linking fails without this due to memory exhaustion
	use x86 && append-ldflags "-Wl,--no-keep-memory"

	if ! use chatzilla ; then
		MEXTENSIONS+=",-irc"
	fi
	if ! use roaming ; then
		MEXTENSIONS+=",-sroaming"
	fi

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-location-service-api-keyfile="${S}/google-api-key"
	mozconfig_annotate '' --with-google-safebrowsing-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	# sm-specific settings
	mozconfig_use_enable calendar

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	mozlinguas_mozconfig

	# Finalize and report settings
	mozconfig_final

	# Required until mozcoreconf-v?.eclass-es are finally fixed...
	sed \
		-e '/--enable-application/s@comm/suite@suite@' \
		-i .mozconfig || die

	# Work around breakage in makeopts with --no-print-directory
	MAKEOPTS="${MAKEOPTS/--no-print-directory/}"

	if [[ $(gcc-major-version) -lt 4 ]] ; then
		append-cxxflags -fno-stack-protector
	elif [[ $(gcc-major-version) -gt 4 || $(gcc-minor-version) -gt 3 ]] ; then
		if use amd64 || use x86 ; then
			append-flags -mno-avx
		fi
	fi

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake V=1 -f client.mk configure
}

src_compile() {
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL}" \
	emake V=1 -f client.mk

	mozlinguas_src_compile
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	DICTPATH="\"${EPREFIX}/usr/share/myspell\""

	local emid
	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}/dist/bin/xpcshell"

	# Copy our preference before omnijar is created.
	sed "s|SEAMONKEY_PVR|${PVR}|" "${FILESDIR}"/all-gentoo-1.js > \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	# Set default path to search for dictionaries.
	echo "pref(\"spellchecker.dictionary_path\", ${DICTPATH});" \
		>> "${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	echo 'pref("extensions.autoDisableScopes", 3);' >> \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	local plugin
	if ! use gmp-autoupdate ; then
		for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
			echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
				"${S}/${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
				|| dir
		done
	fi

	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake DESTDIR="${D}" install
	MOZ_P="${MY_MOZ_P}" mozlinguas_src_install
	cp "${FILESDIR}"/${PN}.desktop "${T}" || die

	sed 's|^\(MimeType=.*\)$|\1text/x-vcard;text/directory;application/mbox;message/rfc822;x-scheme-handler/mailto;|' \
		-i "${T}"/${PN}.desktop || die
	sed 's|^\(Categories=.*\)$|\1Email;|' -i "${T}"/${PN}.desktop \
		|| die

	# Install icon and .desktop for menu entry
	newicon "${S}"/suite/branding/${PN}/default64.png ${PN}.png
	domenu "${T}"/${PN}.desktop

	# Required in order to use plugins and even run seamonkey on hardened.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/{seamonkey,seamonkey-bin,plugin-container}

	if use minimal ; then
		rm -rf "${ED}"/usr/include "${ED}${MOZILLA_FIVE_HOME}"/{idl,include,lib,sdk}
	fi

	if use chatzilla ; then
		local emid='{59c81df5-4b7a-477b-912d-4e0fdf64e5f2}'

		# remove the en_US-only xpi file so a version with all requested locales can be installed
		if [[ -e "${ED}"${MOZILLA_FIVE_HOME}/distribution/extensions/${emid}.xpi ]]; then
			rm -f "${ED}"${MOZILLA_FIVE_HOME}/distribution/extensions/${emid}.xpi || die
		fi

		# merge the extra locales into the main extension
		mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/xpi-stage/chatzilla

		# install the merged extension
		mkdir -p "${T}/${emid}" || die
		cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/xpi-stage/chatzilla/* || die
		insinto ${MOZILLA_FIVE_HOME}/distribution/extensions
		doins -r "${T}/${emid}"
	fi

	# Handle plugins dir through nsplugins.eclass
	share_plugins_dir

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}*" >> ${T}/11${PN}
	doins "${T}"/11${PN}
}

pkg_preinst() {
	MOZILLA_FIVE_HOME="${ROOT}/usr/$(get_libdir)/${PN}"

	if [ -d ${MOZILLA_FIVE_HOME}/plugins ] ; then
		rm ${MOZILLA_FIVE_HOME}/plugins -rf
	fi
}

pkg_postinst() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# Update mimedb for the new .desktop file
	xdg_desktop_database_update

	if ! use gmp-autoupdate ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do elog "\t ${plugin}" ; done
	fi

	if use chatzilla ; then
		elog "chatzilla is now an extension which can be en-/disabled and configured via"
		elog "the Add-on manager."
	fi
}
