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
PATCHTB="thunderbird-60.0-patches-0"
PATCHFF="firefox-60.6-patches-07"

MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/releases"

# ESR releases have slightly version numbers
if [[ ${MOZ_ESR} == 1 ]]; then
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${PN}-${MOZ_PV}"

LLVM_MAX_SLOT=8

inherit check-reqs flag-o-matic toolchain-funcs gnome2-utils llvm mozcoreconf-v6 pax-utils xdg-utils autotools mozlinguas-v2 multiprocessing

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="https://www.mozilla.org/thunderbird"

KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="bindist clang dbus debug hardened jack lightning neon pulseaudio
	selinux startup-notification system-harfbuzz system-icu system-jpeg
	system-libevent system-libvpx system-sqlite wifi"
RESTRICT="!bindist? ( bindist )"

PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c,whissi}/mozilla/patchsets/{${PATCHTB},${PATCHFF}}.tar.xz )
SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/${MOZ_PV}/source/${MOZ_P}.source.tar.xz
	https://dev.gentoo.org/~axs/distfiles/lightning-${MOZ_LIGHTNING_VER}.tar.xz
	lightning? ( https://dev.gentoo.org/~axs/distfiles/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}.tar.xz )
	${PATCH_URIS[@]}"

ASM_DEPEND=">=dev-lang/yasm-1.1"

CDEPEND="
	>=dev-libs/nss-3.36.7
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
	dbus? (
		>=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72
	)
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
	system-harfbuzz? (
		>=media-libs/harfbuzz-1.4.2:0=
		>=media-gfx/graphite2-1.3.9-r1
	)
	system-icu? ( >=dev-libs/icu-59.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1:= )
	system-libevent? ( >=dev-libs/libevent-2.0:0=[threads] )
	system-libvpx? (
		>=media-libs/libvpx-1.5.0:0=[postproc]
		<media-libs/libvpx-1.8:0=[postproc]
	)
	system-sqlite? ( >=dev-db/sqlite-3.23.1:3[secure-delete,debug=] )
	wifi? (
		kernel_linux? (
			>=sys-apps/dbus-0.60
			>=dev-libs/dbus-glib-0.72
			net-misc/networkmanager
		)
	)
	jack? ( virtual/jack )"

DEPEND="${CDEPEND}
	app-arch/zip
	app-arch/unzip
	>=sys-devel/binutils-2.30
	sys-apps/findutils
	|| (
		(
			sys-devel/clang:8
			!clang? ( sys-devel/llvm:8 )
			clang? (
				=sys-devel/lld-8*
				sys-devel/llvm:8[gold]
			)
		)
		(
			sys-devel/clang:7
			!clang? ( sys-devel/llvm:7 )
			clang? (
				=sys-devel/lld-7*
				sys-devel/llvm:7[gold]
			)
		)
		(
			sys-devel/clang:6
			!clang? ( sys-devel/llvm:6 )
			clang? (
				=sys-devel/lld-6*
				sys-devel/llvm:6[gold]
			)
		)
	)
	pulseaudio? ( media-sound/pulseaudio )
	elibc_glibc? (
		virtual/rust
	)
	elibc_musl? (
		virtual/rust
	)
	amd64? (
		${ASM_DEPEND}
		virtual/opengl
	)
	x86? (
		${ASM_DEPEND}
		virtual/opengl
	)"

RDEPEND="${CDEPEND}
	pulseaudio? (
		|| (
			media-sound/pulseaudio
			>=media-sound/apulse-0.1.9
		)
	)
	selinux? (
		sec-policy/selinux-mozilla
		sec-policy/selinux-thunderbird
	)"

REQUIRED_USE="wifi? ( dbus )"

S="${WORKDIR}/${MOZ_P%b[0-9]*}"

BUILD_OBJ_DIR="${S}/tbird"

llvm_check_deps() {
	if ! has_version "sys-devel/clang:${LLVM_SLOT}" ; then
		ewarn "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
		return 1
	fi

	if use clang ; then
		if ! has_version "=sys-devel/lld-${LLVM_SLOT}*" ; then
			ewarn "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
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
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
		elog
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
	# Apply our patchset from firefox to thunderbird as well
	rm -f   "${WORKDIR}"/firefox/2007_fix_nvidia_latest.patch \
		"${WORKDIR}"/firefox/2005_ffmpeg4.patch \
		"${WORKDIR}"/firefox/2012_update-cc-to-honor-CC.patch \
		|| die
	eapply "${WORKDIR}/firefox"

	eapply "${FILESDIR}"/thunderbird-60-sqlite3-fts3-tokenizer.patch
	eapply "${FILESDIR}"/thunderbird-60.9.0-rust-1.38-compat.patch

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/toolkit/mozapps/installer/packager.mk || die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/comm/mail/installer/Makefile.in || die

	# Apply our Thunderbird patchset
	pushd "${S}"/comm &>/dev/null || die
	eapply "${WORKDIR}"/thunderbird

	# NOT TRIGGERED starting with 60.3, as script just maps ${PV} without any actual
	# check on lightning version or changes:
	#
	# Confirm the version of lightning being grabbed for langpacks is the same
	# as that used in thunderbird
	#local THIS_MOZ_LIGHTNING_VER=$(${PYTHON} calendar/lightning/build/makeversion.py ${PV})
	#if [[ ${MOZ_LIGHTNING_VER} != ${THIS_MOZ_LIGHTNING_VER} ]]; then
	#	eqawarn "The version of lightning used for localization differs from the version"
	#	eqawarn "in thunderbird.  Please update MOZ_LIGHTNING_VER in the ebuild from ${MOZ_LIGHTNING_VER}"
	#	eqawarn "to ${THIS_MOZ_LIGHTNING_VER}"
	#fi

	popd &>/dev/null || die

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	local n_jobs=$(makeopts_jobs)
	if [[ ${n_jobs} == 1 ]]; then
		einfo "Building with MAKEOPTS=-j1 is known to fail (bug #687028); Forcing MAKEOPTS=-j2 ..."
		export MAKEOPTS=-j2
	fi

	# Autotools configure is now called old-configure.in
	# This works because there is still a configure.in that happens to be for the
	# shell wrapper configure script
	eautoreconf old-configure.in

	# Must run autoconf in js/src
	cd "${S}"/js/src || die
	eautoconf old-configure.in
}

src_configure() {
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

	# Avoid auto-magic on linker
	if use clang ; then
		# This is upstream's default
		mozconfig_annotate "forcing ld=lld due to USE=clang" --enable-linker=lld
	elif tc-ld-is-gold ; then
		mozconfig_annotate "linker is set to gold" --enable-linker=gold
	else
		mozconfig_annotate "linker is set to bfd" --enable-linker=bfd
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
	mozconfig_annotate 'Gentoo default' --enable-system-hunspell
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

	mozconfig_use_enable dbus

	mozconfig_use_enable wifi necko-wifi

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# Other tb-specific settings
	mozconfig_annotate '' --with-user-appdir=.thunderbird
	mozconfig_annotate '' --enable-ldap
	mozconfig_annotate '' --enable-calendar

	# Disable built-in ccache support to avoid sandbox violation, #665420
	# Use FEATURES=ccache instead!
	mozconfig_annotate '' --without-ccache
	sed -i -e 's/ccache_stats = None/return None/' \
		python/mozbuild/mozbuild/controller/building.py || \
		die "Failed to disable ccache stats call"

	# Stylo is only broken on x86 builds
	use x86 && mozconfig_annotate 'Upstream bug 1341234' --disable-stylo

	# Stylo is horribly broken on arm, renders GUI unusable
	use arm && mozconfig_annotate 'breaks UI on arm' --disable-stylo

	if use clang ; then
		# libprldap60.so: terminate called after throwing an instance of 'std::runtime_error', bug 667186
		mozconfig_annotate 'elf-hack is broken when using clang' --disable-elf-hack
	elif use arm ; then
		mozconfig_annotate 'elf-hack is broken on arm' --disable-elf-hack
	fi

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	mozlinguas_mozconfig

	# Finalize and report settings
	mozconfig_final

	####################################
	#
	#  Configure and build
	#
	####################################

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	./mach configure || die
}

src_compile() {
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX}/bin/bash}" MOZ_NOSPAM=1 \
	./mach build --verbose || die
}

src_install() {
	declare emid
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

	cd "${S}" || die
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
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
