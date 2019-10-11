# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VIRTUALX_REQUIRED="pgo"
WANT_AUTOCONF="2.1"
MOZ_ESR=""
MOZ_LIGHTNING_VER="6.2.5"
MOZ_LIGHTNING_GDATA_VER="4.4.1"

PYTHON_COMPAT=( python3_{5,6,7} )
PYTHON_REQ_USE='ncurses,sqlite,ssl,threads(+)'

# This list can be updated using scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=(ar ast be bg br ca cs cy da de el en en-GB en-US es-AR
es-ES et eu fi fr fy-NL ga-IE gd gl he hr hsb hu hy-AM id is it
ja ko lt nb-NO nl nn-NO pl pt-BR pt-PT rm ro ru si sk sl sq sr
sv-SE tr uk vi zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_beta/b}"

# Patches
PATCHFF="firefox-68.0-patches-12"

MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/releases"

# ESR releases have slightly version numbers
if [[ ${MOZ_ESR} == 1 ]]; then
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${PN}-${MOZ_PV}"

LLVM_MAX_SLOT=9

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="https://www.mozilla.org/thunderbird"

KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="bindist clang cpu_flags_x86_avx2 dbus debug eme-free
	+gmp-autoupdate hardened jack lightning lto neon pgo pulseaudio
	 selinux startup-notification +system-av1 +system-harfbuzz +system-icu
	+system-jpeg +system-libevent +system-sqlite +system-libvpx
	+system-webp test wayland wifi"
RESTRICT="!bindist? ( bindist )
	!test? ( test )"

PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c,whissi}/mozilla/patchsets/${PATCHFF}.tar.xz )
SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/${MOZ_PV}/source/${MOZ_P}.source.tar.xz
	https://dev.gentoo.org/~axs/distfiles/lightning-${MOZ_LIGHTNING_VER}.tar.xz
	lightning? ( https://dev.gentoo.org/~axs/distfiles/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}.tar.xz )
	${PATCH_URIS[@]}"

inherit check-reqs eapi7-ver flag-o-matic toolchain-funcs eutils \
		gnome2-utils llvm mozcoreconf-v6 pax-utils xdg-utils \
		autotools mozlinguas-v2 virtualx multiprocessing

CDEPEND="
	>=dev-libs/nss-3.44.1
	>=dev-libs/nspr-4.21
	dev-libs/atk
	dev-libs/expat
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3[X]
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.35:0=[apng]
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
	system-av1? (
		>=media-libs/dav1d-0.3.0:=
		>=media-libs/libaom-1.0.0:=
	)
	system-harfbuzz? ( >=media-libs/harfbuzz-2.4.0:0= >=media-gfx/graphite2-1.3.13 )
	system-icu? ( >=dev-libs/icu-63.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0=[threads] )
	system-libvpx? ( =media-libs/libvpx-1.7*:0=[postproc] )
	system-sqlite? ( >=dev-db/sqlite-3.28.0:3[secure-delete,debug=] )
	system-webp? ( >=media-libs/libwebp-1.0.2:0= )
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
	>=dev-util/cbindgen-0.8.7
	>=net-libs/nodejs-8.11.0
	>=sys-devel/binutils-2.30
	sys-apps/findutils
	|| (
		(
			sys-devel/clang:9
			!clang? ( sys-devel/llvm:9 )
			clang? (
				=sys-devel/lld-9*
				sys-devel/llvm:9[gold]
				pgo? ( =sys-libs/compiler-rt-sanitizers-9*[profile] )
			)
		)
		(
			sys-devel/clang:8
			!clang? ( sys-devel/llvm:8 )
			clang? (
				=sys-devel/lld-8*
				sys-devel/llvm:8[gold]
				pgo? ( =sys-libs/compiler-rt-sanitizers-8*[profile] )
			)
		)
		(
			sys-devel/clang:7
			!clang? ( sys-devel/llvm:7 )
			clang? (
				=sys-devel/lld-7*
				sys-devel/llvm:7[gold]
				pgo? ( =sys-libs/compiler-rt-sanitizers-7*[profile] )
			)
		)
		(
			sys-devel/clang:6
			!clang? ( sys-devel/llvm:6 )
			clang? (
				=sys-devel/lld-6*
				sys-devel/llvm:6[gold]
				pgo? ( =sys-libs/compiler-rt-sanitizers-6*[profile] )
			)
		)
	)
	pulseaudio? ( media-sound/pulseaudio )
	>=virtual/rust-1.34.0
	wayland? ( >=x11-libs/gtk+-3.11:3[wayland] )
	amd64? ( >=dev-lang/yasm-1.1 virtual/opengl )
	x86? ( >=dev-lang/yasm-1.1 virtual/opengl )
	!system-av1? (
		amd64? ( >=dev-lang/nasm-2.13 )
		x86? ( >=dev-lang/nasm-2.13 )
	)"

REQUIRED_USE="wifi? ( dbus )
	pgo? ( lto )"

S="${WORKDIR}/${MOZ_P%b[0-9]*}"

BUILD_OBJ_DIR="${S}/tbird"

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z $GMP_PLUGIN_LIST ]] ; then
	GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

llvm_check_deps() {
	if ! has_version --host-root "sys-devel/clang:${LLVM_SLOT}" ; then
		ewarn "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
		return 1
	fi

	if use pgo ; then
		if ! has usersandbox $FEATURES ; then
			eerror "You must enable usersandbox as X server can not run as root!"
		fi
	fi

	if use clang ; then
		if ! has_version --host-root "=sys-devel/lld-${LLVM_SLOT}*" ; then
			ewarn "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		if use pgo ; then
			if ! has_version --host-root "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*" ; then
				ewarn "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
				return 1
			fi
		fi
	fi

	einfo "Will use LLVM slot ${LLVM_SLOT}!"
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

	if ! use bindist ; then
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
	if use pgo || use lto || use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi

	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
}

src_prepare() {
	# Apply firefox patchset then apply thunderbird patches
	rm "${WORKDIR}"/firefox/2013_avoid_noinline_on_GCC_with_skcms.patch || die
	eapply "${WORKDIR}/firefox"
	pushd "${S}"/comm &>/dev/null || die
	eapply "${FILESDIR}/1000_fix_gentoo_preferences.patch"
	popd &>/dev/null || die

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	local n_jobs=$(makeopts_jobs)
	if [[ ${n_jobs} == 1 ]]; then
		einfo "Building with MAKEOPTS=-j1 is known to fail (bug #687028); Forcing MAKEOPTS=-j2 ..."
		export MAKEOPTS=-j2
	fi

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

	# Fix sandbox violations during make clean, bug 372817
	sed -e "s:\(/no-such-file\):${T}\1:g" \
		-i "${S}"/config/rules.mk \
		-i "${S}"/nsprpub/configure{.in,} \
		|| die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/comm/mail/installer/Makefile.in || die

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/toolkit/mozapps/installer/packager.mk || die

	# Keep codebase the same even if not using official branding
	sed '/^MOZ_DEV_EDITION=1/d' \
		-i "${S}"/browser/branding/aurora/configure.sh || die

	# rustfmt, a tool to format Rust code, is optional and not required to build Firefox.
	# However, when available, an unsupported version can cause problems, bug #669548
	sed -i -e "s@check_prog('RUSTFMT', add_rustup_path('rustfmt')@check_prog('RUSTFMT', add_rustup_path('rustfmt_do_not_use')@" \
		"${S}"/build/moz.configure/rust.configure || die

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

	if use pgo ; then
		if ! has userpriv $FEATURES ; then
			eerror "Building firefox with USE=pgo and FEATURES=-userpriv is not supported!"
		fi
	fi

	# Don't let user's LTO flags clash with upstream's flags
	filter-flags -flto*

	if use lto ; then
		local show_old_compiler_warning=

		if use clang ; then
			# At this stage CC is adjusted and the following check will
			# will work
			if [[ $(clang-major-version) -lt 7 ]] ; then
				show_old_compiler_warning=1
			fi

			# Upstream only supports lld when using clang
			mozconfig_annotate "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld
		else
			if [[ $(gcc-major-version) -lt 8 ]] ; then
				show_old_compiler_warning=1
			fi

			# Bug 689358
			append-cxxflags -flto

			if ! use cpu_flags_x86_avx2 ; then
				local _gcc_version_with_ipa_cdtor_fix="8.3"
				local _current_gcc_version="$(gcc-major-version).$(gcc-minor-version)"

				if ver_test "${_current_gcc_version}" -lt "${_gcc_version_with_ipa_cdtor_fix}" ; then
					# due to a GCC bug, GCC will produce AVX2 instructions
					# even if the CPU doesn't support AVX2, https://gcc.gnu.org/ml/gcc-patches/2018-12/msg01142.html
					einfo "Disable IPA cdtor due to bug in GCC and missing AVX2 support -- triggered by USE=lto"
					append-ldflags -fdisable-ipa-cdtor
				else
					einfo "No GCC workaround required, GCC version is already patched!"
				fi
			else
				einfo "No GCC workaround required, system supports AVX2"
			fi

			# Linking only works when using ld.gold when LTO is enabled
			mozconfig_annotate "forcing ld=gold due to USE=lto" --enable-linker=gold
		fi

		if [[ -n "${show_old_compiler_warning}" ]] ; then
			# Checking compiler's major version uses CC variable. Because we allow
			# user to control used compiler via USE=clang flag, we cannot use
			# initial value. So this is the earliest stage where we can do this check
			# because pkg_pretend is not called in the main phase function sequence
			# environment saving is not guaranteed so we don't know if we will have
			# correct compiler until now.
			ewarn ""
			ewarn "USE=lto requires up-to-date compiler (>=gcc-8 or >=clang-7)."
			ewarn "You are on your own -- expect build failures. Don't file bugs using that unsupported configuration!"
			ewarn ""
			sleep 5
		fi

		mozconfig_annotate '+lto' --enable-lto=thin

		if use pgo ; then
			mozconfig_annotate '+pgo' MOZ_PGO=1
		fi
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
	if use hardened ; then
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

	mozconfig_use_enable !bindist official-branding

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
	if use system-libevent ; then
		mozconfig_annotate '' --with-system-libevent="${SYSROOT}${EPREFIX}"/usr
	fi

	if ! use x86 && [[ ${CHOST} != armv*h* ]] ; then
		mozconfig_annotate '' --enable-rust-simd
	fi

	# use the gtk3 toolkit (the only one supported at this point)
	# TODO: Will this result in automagic dependency on x11-libs/gtk+[wayland]?
	if use wayland ; then
		mozconfig_annotate '' --enable-default-toolkit=cairo-gtk3-wayland
	else
		mozconfig_annotate '' --enable-default-toolkit=cairo-gtk3
	fi

	mozconfig_use_enable startup-notification
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-av1
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-webp
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

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# Other tb-specific settings
	mozconfig_annotate '' --with-user-appdir=.thunderbird
	mozconfig_annotate '' --enable-ldap
	mozconfig_annotate '' --enable-calendar

	# Enable/Disable eme support
	use eme-free && mozconfig_annotate '+eme-free' --disable-eme

	# Setup api key for location services and safebrowsing, https://bugzilla.mozilla.org/show_bug.cgi?id=1531176#c34
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-location-service-api-keyfile="${S}/google-api-key"
	mozconfig_annotate '' --with-google-safebrowsing-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	# allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	if use clang ; then
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1483822
		mozconfig_annotate 'elf-hack is broken when using Clang' --disable-elf-hack
	fi

	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	mkdir -p "${S}"/third_party/rust/libloading/.deps

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	./mach configure || die
}

src_compile() {
	local _virtx=
	if use pgo ; then
		_virtx=virtx

		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root
		addpredict /etc/gconf
	fi

	GDK_BACKEND=x11 \
		MOZ_MAKE_FLAGS="${MAKEOPTS} -O" \
		SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
		MOZ_NOSPAM=1 \
		${_virtx} \
		./mach build --verbose \
		|| die
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/xpcshell

	# Copy our preference before omnijar is created.
	cp "${FILESDIR}"/thunderbird-gentoo-default-prefs.js-2 \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	# set dictionary path, to use system hunspell
	echo "pref(\"spellchecker.dictionary_path\", \"${EPREFIX}/usr/share/myspell\");" \
		>>"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" || die

	# force the graphite pref if system-harfbuzz is enabled, since the pref cant disable it
	if use system-harfbuzz ; then
		echo "sticky_pref(\"gfx.font_rendering.graphite.enabled\",true);" \
			>>"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" || die
	fi

	# force cairo as the canvas renderer on platforms without skia support
	if [[ $(tc-endian) == "big" ]] ; then
		echo "sticky_pref(\"gfx.canvas.azure.backends\",\"cairo\");" \
			>>"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" || die
		echo "sticky_pref(\"gfx.content.azure.backends\",\"cairo\");" \
			>>"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" || die
	fi

	echo "pref(\"extensions.autoDisableScopes\", 3);" >> \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	local plugin
	use gmp-autoupdate || use eme-free || for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
		echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
			"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
			|| die
	done

	cd "${S}"
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	DESTDIR="${D}" ./mach install || die

	# Install language packs
	MOZ_INSTALL_L10N_XPIFILE="1" mozlinguas_src_install

	local size sizes icon_path icon
	if ! use bindist; then
		icon_path="${S}/comm/mail/branding/thunderbird"
		icon="${PN}-icon"

		domenu "${FILESDIR}"/icon/${PN}.desktop
	else
		icon_path="${S}/comm/mail/branding/nightly"
		icon="${PN}-icon-unbranded"

		newmenu "${FILESDIR}"/icon/${PN}-unbranded.desktop \
			${PN}.desktop

		sed -i -e "s:Mozilla\ Thunderbird:EarlyBird:g" \
			"${ED}"/usr/share/applications/${PN}.desktop
	fi

	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}"/default48.png "${icon}".png
	# Install icons for menu entry
	sizes="16 22 24 32 48 256"
	for size in ${sizes}; do
		newicon -s ${size} "${icon_path}/default${size}.png" "${icon}.png"
	done

	# Disable built-in auto-update because we update firefox through package manager
	insinto ${MOZILLA_FIVE_HOME}/distribution/
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Add StartupNotify=true bug 237317
	if use startup-notification ; then
		echo "StartupNotify=true"\
			 >> "${ED}/usr/share/applications/${PN}.desktop" \
			|| die
	fi

	# Don't install llvm-symbolizer from sys-devel/llvm package
	[[ -f "${ED%/}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] && \
		rm "${ED%/}${MOZILLA_FIVE_HOME}/llvm-symbolizer"

	local emid
	# stage extra locales for lightning and install over existing
	emid='{e2fda1a4-762b-4020-b5ad-a41df1933103}'
	rm -f "${ED}"/${MOZILLA_FIVE_HOME}/distribution/extensions/${emid}.xpi || die
	mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/bin/distribution/extensions/${emid} \
		"${WORKDIR}"/lightning-${MOZ_LIGHTNING_VER} lightning calendar

	mkdir -p "${T}/${emid}" || die
	cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/bin/distribution/extensions/${emid}/* || die
	insinto ${MOZILLA_FIVE_HOME}/distribution/extensions
	doins -r "${T}/${emid}"

	if use lightning; then
		# move lightning out of distribution/extensions and into extensions for app-global install
		mkdir -p "${ED}"/${MOZILLA_FIVE_HOME}/extensions
		mv "${ED}"/${MOZILLA_FIVE_HOME}/{distribution,}/extensions/${emid} || die

		# stage extra locales for gdata-provider and install app-global
		mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/xpi-stage/gdata-provider \
			"${WORKDIR}"/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}
		emid='{a62ef8ec-5fdc-40c2-873c-223b8a6925cc}'
		mkdir -p "${T}/${emid}" || die
		cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/xpi-stage/gdata-provider/* || die

		# manifest.json does not allow the addon to load, put install.rdf in place
		# note, version number needs to be set properly
		cp -RLp -t "${T}/${emid}" "${WORKDIR}"/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}/install.rdf
		sed -i -e '/em:version/ s/>[^<]*</>4.1</' "${T}/${emid}"/install.rdf

		insinto ${MOZILLA_FIVE_HOME}/extensions
		doins -r "${T}/${emid}"
	fi

	# thunderbird and thunderbird-bin are identical
	rm "${ED%/}"${MOZILLA_FIVE_HOME}/thunderbird-bin || die
	dosym thunderbird ${MOZILLA_FIVE_HOME}/thunderbird-bin

	# Required in order to use plugins and even run thunderbird on hardened.
	pax-mark pm "${ED%/}"${MOZILLA_FIVE_HOME}/{thunderbird,plugin-container}
}

pkg_preinst() {
	# if the apulse libs are available in MOZILLA_FIVE_HOME then apulse
	# doesn't need to be forced into the LD_LIBRARY_PATH
	if use pulseaudio && has_version ">=media-sound/apulse-0.1.9" ; then
		einfo "APULSE found - Generating library symlinks for sound support"
		local lib
		pushd "${ED}"${MOZILLA_FIVE_HOME} &>/dev/null || die
		for lib in ../apulse/libpulse{.so{,.0},-simple.so{,.0}} ; do
			# a quickpkg rolled by hand will grab symlinks as part of the package,
			# so we need to avoid creating them if they already exist.
			if [[ ! -L ${lib##*/} ]] ; then
				ln -s "${lib}" ${lib##*/} || die
			fi
		done
		popd &>/dev/null || die
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	if ! use gmp-autoupdate && ! use eme-free ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do elog "\t ${plugin}" ; done
		elog
	fi

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.9" ; then
		elog "Apulse was detected at merge time on this system and so it will always be"
		elog "used for sound.  If you wish to use pulseaudio instead please unmerge"
		elog "media-sound/apulse."
		elog
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
