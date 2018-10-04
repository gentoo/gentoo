# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VIRTUALX_REQUIRED="pgo"
WANT_AUTOCONF="2.1"
MOZ_ESR=""

PYTHON_COMPAT=( python3_{5,6,7} )
PYTHON_REQ_USE='ncurses,sqlite,ssl,threads(+)'

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=( ach af an ar as ast az bg bn-BD bn-IN br bs ca cak cs cy da de dsb
el en en-GB en-US en-ZA eo es-AR es-CL es-ES es-MX et eu fa ff fi fr fy-NL ga-IE
gd gl gn gu-IN he hi-IN hr hsb hu hy-AM id is it ja ka kab kk km kn ko lij lt lv
mai mk ml mr ms nb-NO nl nn-NO or pa-IN pl pt-BR pt-PT rm ro ru si sk sl son sq
sr sv-SE ta te th tr uk uz vi xh zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_alpha/a}" # Handle alpha for SRC_URI
MOZ_PV="${MOZ_PV/_beta/b}" # Handle beta for SRC_URI
MOZ_PV="${MOZ_PV/_rc/rc}" # Handle rc for SRC_URI

if [[ ${MOZ_ESR} == 1 ]]; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

# Patch version
PATCH="${PN}-62.0-patches-01"
MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/releases"

inherit check-reqs flag-o-matic toolchain-funcs eutils gnome2-utils llvm \
		mozcoreconf-v6 pax-utils xdg-utils autotools mozlinguas-v2

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="https://www.mozilla.com/firefox"

KEYWORDS="~amd64 ~x86"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="bindist clang dbus debug eme-free geckodriver +gmp-autoupdate hardened hwaccel
	jack lto neon pulseaudio +screenshot selinux startup-notification
	system-harfbuzz system-icu system-jpeg system-libevent system-sqlite
	system-libvpx test wifi"
RESTRICT="!bindist? ( bindist )"

PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c}/mozilla/patchsets/${PATCH}.tar.xz )
SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/${MOZ_PV}/source/firefox-${MOZ_PV}.source.tar.xz
	${PATCH_URIS[@]}"

CDEPEND="
	>=dev-libs/nss-3.38
	>=dev-libs/nspr-4.19
	>=app-text/hunspell-1.5.4:=
	dev-libs/atk
	dev-libs/expat
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.34:0=[apng]
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	kernel_linux? ( !pulseaudio? ( media-libs/alsa-lib ) )
	virtual/freedesktop-icon-theme
	dbus? ( >=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	>=x11-libs/pixman-0.19.2
	>=dev-libs/glib-2.26:2
	>=sys-libs/zlib-1.2.3
	>=virtual/libffi-3.0.10:=
	virtual/ffmpeg
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	system-icu? ( >=dev-libs/icu-60.2:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0= )
	system-sqlite? ( >=dev-db/sqlite-3.24.0:3[secure-delete,debug=] )
	system-libvpx? ( >=media-libs/libvpx-1.5.0:0=[postproc] )
	system-harfbuzz? ( >=media-libs/harfbuzz-1.4.2:0= >=media-gfx/graphite2-1.3.9-r1 )
	wifi? ( kernel_linux? ( >=sys-apps/dbus-0.60
			>=dev-libs/dbus-glib-0.72
			net-misc/networkmanager ) )
	jack? ( virtual/jack )
	selinux? ( sec-policy/selinux-mozilla )"

RDEPEND="${CDEPEND}
	jack? ( virtual/jack )
	pulseaudio? ( || ( media-sound/pulseaudio
		>=media-sound/apulse-0.1.9 ) )
	selinux? ( sec-policy/selinux-mozilla )"

DEPEND="${CDEPEND}
	app-arch/zip
	app-arch/unzip
	>=sys-devel/binutils-2.30
	sys-apps/findutils
	>=sys-devel/llvm-4.0.1
	>=sys-devel/clang-4.0.1
	clang? (
		>=sys-devel/llvm-4.0.1[gold]
		>=sys-devel/lld-4.0.1
	)
	pulseaudio? ( media-sound/pulseaudio )
	elibc_glibc? (
		virtual/cargo
		virtual/rust
	)
	elibc_musl? (
		virtual/cargo
		virtual/rust
	)
	amd64? ( >=dev-lang/yasm-1.1 virtual/opengl )
	x86? ( >=dev-lang/yasm-1.1 virtual/opengl )"

REQUIRED_USE="wifi? ( dbus )"

S="${WORKDIR}/firefox-${PV%_*}"

QA_PRESTRIPPED="usr/lib*/${PN}/firefox"

BUILD_OBJ_DIR="${S}/ff"

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z $GMP_PLUGIN_LIST ]]; then
	GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	moz_pkgsetup

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
	unset DBUS_SESSION_BUS_ADDRESS \
		DISPLAY \
		ORBIT_SOCKETDIR \
		SESSION_MANAGER \
		XDG_SESSION_COOKIE \
		XAUTHORITY

	if ! use bindist; then
		einfo
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation."
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag."
	fi

	addpredict /proc/self/oom_score_adj

	llvm_pkg_setup
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	CHECKREQS_DISK_BUILD="4G"

	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
}

src_prepare() {
	eapply "${WORKDIR}/firefox"

	eapply "${FILESDIR}"/${PN}-60.0-blessings-TERM.patch # 654316
	eapply "${FILESDIR}"/${PN}-60.0-do-not-force-lld.patch
	eapply "${FILESDIR}"/${PN}-60.0-sandbox-lto.patch # 666580
	eapply "${FILESDIR}"/${PN}-60.0-missing-errno_h-in-SandboxOpenedFiles_cpp.patch

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${S}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Drop -Wl,--as-needed related manipulation for ia64 as it causes ld sefgaults, bug #582432
	if use ia64 ; then
		sed -i \
		-e '/^OS_LIBS += no_as_needed/d' \
		-e '/^OS_LIBS += as_needed/d' \
		"${S}"/widget/gtk/mozgtk/gtk2/moz.build \
		"${S}"/widget/gtk/mozgtk/gtk3/moz.build \
		|| die "sed failed to drop --as-needed for ia64"
	fi

	# Ensure that our plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Fix sandbox violations during make clean, bug 372817
	sed -e "s:\(/no-such-file\):${T}\1:g" \
		-i "${S}"/config/rules.mk \
		-i "${S}"/nsprpub/configure{.in,} \
		|| die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/browser/installer/Makefile.in || die

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/toolkit/mozapps/installer/packager.mk || die

	# Keep codebase the same even if not using official branding
	sed '/^MOZ_DEV_EDITION=1/d' \
		-i "${S}"/browser/branding/aurora/configure.sh || die

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Autotools configure is now called old-configure.in
	# This works because there is still a configure.in that happens to be for the
	# shell wrapper configure script
	eautoreconf old-configure.in

	# Must run autoconf in js/src
	cd "${S}"/js/src || die
	eautoconf old-configure.in
}

src_configure() {
	MEXTENSIONS="default"
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	# Add information about TERM to output (build.log) to aid debugging
	# blessings problems
	if [[ -n "${TERM}" ]] ; then
		einfo "TERM is set to: \"${TERM}\""
	else
		einfo "TERM is unset."
	fi

	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		strip-unsupported-flags
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		strip-unsupported-flags
	fi

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	# common config components
	mozconfig_annotate 'system_libs' \
		--with-system-zlib \
		--with-system-bz2

	# Must pass release in order to properly select linker
	mozconfig_annotate 'Enable by Gentoo' --enable-release

	# Don't let user's LTO flags clash with upstream's flags
	filter-flags -flto*

	if use lto ; then
		if use clang ; then
			# Upstream only supports lld when using clang
			mozconfig_annotate "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld
		else
			# Linking only works when using ld.gold when LTO is enabled
			mozconfig_annotate "forcing ld=gold due to USE=lto" --enable-linker=gold
		fi

		mozconfig_annotate '+lto' --enable-lto=full
	else
		# Avoid auto-magic on linker
		if use clang ; then
			# This is upstream's default
			mozconfig_annotate "forcing ld=lld due to USE=clang" --enable-linker=lld
		elif tc-ld-is-gold ; then
			mozconfig_annotate "linker is set to gold" --enable-linker=gold
		else
			mozconfig_annotate "linker is set to bfd" --enable-linker=bfd
		fi
	fi

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Add full relro support for hardened
	if use hardened; then
		append-ldflags "-Wl,-z,relro,-z,now"
		mozconfig_use_enable hardened hardening
	fi

	# Modifications to better support ARM, bug 553364
	if use neon ; then
		mozconfig_annotate '' --with-fpu=neon

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			mozconfig_annotate '' --with-thumb=yes
			mozconfig_annotate '' --with-thumb-interwork=no
		fi
	fi
	if [[ ${CHOST} == armv*h* ]] ; then
		mozconfig_annotate '' --with-float-abi=hard
		if ! use system-libvpx ; then
			sed -i -e "s|softfp|hard|" \
				"${S}"/media/libvpx/moz.build
		fi
	fi

	# disable webrtc for now, moz stated in #1496027 they're not going to put any ressources into a possible fix
	use arm && mozconfig_annotate 'broken on arm' --disable-webrtc

	mozconfig_use_enable !bindist official-branding
	# Enable position independent executables
	mozconfig_annotate 'enabled by Gentoo' --enable-pie

	mozconfig_use_enable debug
	mozconfig_use_enable debug tests
	if ! use debug ; then
		mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols
	else
		mozconfig_annotate 'enabled by Gentoo' --enable-debug-symbols
	fi
	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${SYSROOT}${EPREFIX}"/usr/include \
		--x-libraries="${SYSROOT}${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate 'Gentoo default' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate '' --disable-gconf
	mozconfig_annotate '' --with-intl-api
	mozconfig_annotate '' --enable-system-pixman
	# Instead of the standard --build= and --host=, mozilla uses --host instead
	# of --build, and --target intstead of --host.
	# Note, mozilla also has --build but it does not do what you think it does.
	# Set both --target and --host as mozilla uses python to guess values otherwise
	mozconfig_annotate '' --target="${CHOST}"
	mozconfig_annotate '' --host="${CBUILD:-${CHOST}}"
	if use system-libevent; then
		mozconfig_annotate '' --with-system-libevent="${SYSROOT}${EPREFIX}"/usr
	fi

	# skia has no support for big-endian platforms
	if [[ $(tc-endian) == "big" ]]; then
		mozconfig_annotate 'big endian target' --disable-skia
	else
		mozconfig_annotate '' --enable-skia
	fi

	# use the gtk3 toolkit (the only one supported at this point)
	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk3

	mozconfig_use_enable startup-notification
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_enable pulseaudio
	# force the deprecated alsa sound code if pulseaudio is disabled
	if use kernel_linux && ! use pulseaudio ; then
		mozconfig_annotate '-pulseaudio' --enable-alsa
	fi

	# Disable built-in ccache support to avoid sandbox violation, #665420
	# Use FEATURES=ccache instead!
	mozconfig_annotate '' --without-ccache
	sed -i -e 's/ccache_stats = None/return None/' \
		python/mozbuild/mozbuild/controller/building.py || \
		die "Failed to disable ccache stats call"

	mozconfig_use_enable dbus

	mozconfig_use_enable wifi necko-wifi

	mozconfig_use_enable geckodriver

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# Enable/Disable eme support
	use eme-free && mozconfig_annotate '+eme-free' --disable-eme

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	if use clang ; then
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1423822
		mozconfig_annotate 'elf-hack is broken when using Clang' --disable-elf-hack
	fi

	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	./mach configure || die
}

src_compile() {
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	./mach build --verbose || die
}

src_install() {
	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/xpcshell

	# Add our default prefs for firefox
	cp "${FILESDIR}"/gentoo-default-prefs.js-2 \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

	# set dictionary path, to use system hunspell
	echo "pref(\"spellchecker.dictionary_path\", \"${EPREFIX}/usr/share/myspell\");" \
		>>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" || die

	# force the graphite pref if system-harfbuzz is enabled, since the pref cant disable it
	if use system-harfbuzz ; then
		echo "sticky_pref(\"gfx.font_rendering.graphite.enabled\",true);" \
			>>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" || die
	fi

	# force cairo as the canvas renderer on platforms without skia support
	if [[ $(tc-endian) == "big" ]] ; then
		echo "sticky_pref(\"gfx.canvas.azure.backends\",\"cairo\");" \
			>>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" || die
		echo "sticky_pref(\"gfx.content.azure.backends\",\"cairo\");" \
			>>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" || die
	fi

	# Augment this with hwaccel prefs
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-1 >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die
	fi

	if ! use screenshot; then
		echo "pref(\"extensions.screenshots.disabled\", true);" >> \
			"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
			|| die
	fi

	echo "pref(\"extensions.autoDisableScopes\", 3);" >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

	local plugin
	use gmp-autoupdate || use eme-free || for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
		echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
			"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
			|| die
	done

	cd "${S}"
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	DESTDIR="${D}" ./mach install || die

	if use geckodriver ; then
		cp "${BUILD_OBJ_DIR}"/dist/bin/geckodriver "${ED%/}"${MOZILLA_FIVE_HOME} || die
		pax-mark m "${ED%/}"${MOZILLA_FIVE_HOME}/geckodriver

		dosym ${MOZILLA_FIVE_HOME}/geckodriver /usr/bin/geckodriver
	fi

	# Install language packs
	MOZ_INSTALL_L10N_XPIFILE="1" mozlinguas_src_install

	local size sizes icon_path icon name
	if use bindist; then
		sizes="16 32 48"
		icon_path="${S}/browser/branding/aurora"
		# Firefox's new rapid release cycle means no more codenames
		# Let's just stick with this one...
		icon="aurora"
		name="Aurora"

		# Override preferences to set the MOZ_DEV_EDITION defaults, since we
		# don't define MOZ_DEV_EDITION to avoid profile debaucles.
		# (source: browser/app/profile/firefox.js)
		cat >>"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" <<PROFILE_EOF
pref("app.feedback.baseURL", "https://input.mozilla.org/%LOCALE%/feedback/firefoxdev/%VERSION%/");
sticky_pref("lightweightThemes.selectedThemeID", "firefox-devedition@mozilla.org");
sticky_pref("browser.devedition.theme.enabled", true);
sticky_pref("devtools.theme", "dark");
PROFILE_EOF

	else
		sizes="16 22 24 32 48 64 128 256"
		icon_path="${S}/browser/branding/official"
		icon="${PN}"
		name="Mozilla Firefox"
	fi

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${icon}.png"
	done
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}/default48.png" "${icon}.png"
	newmenu "${FILESDIR}/icon/${PN}.desktop" "${PN}.desktop"
	sed -i -e "s:@NAME@:${name}:" -e "s:@ICON@:${icon}:" \
		"${ED}/usr/share/applications/${PN}.desktop" || die

	# Add StartupNotify=true bug 237317
	if use startup-notification ; then
		echo "StartupNotify=true"\
			 >> "${ED}/usr/share/applications/${PN}.desktop" \
			|| die
	fi

	# Don't install llvm-symbolizer from sys-devel/llvm package
	[[ -f "${ED%/}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] && \
		rm "${ED%/}${MOZILLA_FIVE_HOME}/llvm-symbolizer"

	# firefox and firefox-bin are identical
	rm "${ED%/}"${MOZILLA_FIVE_HOME}/firefox-bin || die
	dosym firefox ${MOZILLA_FIVE_HOME}/firefox-bin

	# Required in order to use plugins and even run firefox on hardened.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/{firefox,plugin-container}
}

pkg_preinst() {
	gnome2_icon_savelist

	# if the apulse libs are available in MOZILLA_FIVE_HOME then apulse
	# doesn't need to be forced into the LD_LIBRARY_PATH
	if use pulseaudio && has_version ">=media-sound/apulse-0.1.9" ; then
		einfo "APULSE found - Generating library symlinks for sound support"
		local lib
		pushd "${ED}"${MOZILLA_FIVE_HOME} &>/dev/null || die
		for lib in ../apulse/libpulse{.so{,.0},-simple.so{,.0}} ; do
			# a quickpkg rolled by hand will grab symlinks as part of the package,
			# so we need to avoid creating them if they already exist.
			if ! [ -L ${lib##*/} ]; then
				ln -s "${lib}" ${lib##*/} || die
			fi
		done
		popd &>/dev/null || die
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update

	if ! use gmp-autoupdate && ! use eme-free ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do elog "\t ${plugin}" ; done
		elog
	fi

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.9"; then
		elog "Apulse was detected at merge time on this system and so it will always be"
		elog "used for sound.  If you wish to use pulseaudio instead please unmerge"
		elog "media-sound/apulse."
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
