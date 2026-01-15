# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FIREFOX_PATCHSET="firefox-140esr-patches-05.tar.xz"
FIREFOX_LOONG_PATCHSET="firefox-139-loong-patches-02.tar.xz"

LLVM_COMPAT=( 19 20 21 )

# This will also filter rust versions that don't match LLVM_COMPAT in the non-clang path; this is fine.
RUST_NEEDS_LLVM=1

# If not building with clang we need at least rust 1.76
RUST_MIN_VER=1.82.0

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="ncurses,sqlite,ssl"

VIRTUALX_REQUIRED="manual"

# Information about the bundled wasi toolchain from
# https://github.com/WebAssembly/wasi-sdk/
WASI_SDK_VER=28.0
WASI_SDK_LLVM_VER=21

MOZ_ESR=yes

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
	HOMEPAGE="https://www.firefox.com https://www.firefox.com/enterprise/"
	SLOT="esr"
else
	HOMEPAGE="https://www.firefox.com"
	SLOT="rapid"
fi

MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

inherit check-reqs desktop flag-o-matic gnome2-utils linux-info llvm-r1 multiprocessing \
	optfeature pax-utils python-any-r1 readme.gentoo-r1 rust toolchain-funcs virtualx xdg

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
)

DESCRIPTION="Firefox Web Browser"
SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}
	loong? (
		https://dev.gentoo.org/~xen0n/distfiles/www-client/${MOZ_PN}/${FIREFOX_LOONG_PATCHSET}
	)
	wasm-sandbox? (
		amd64? ( https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VER/.*/}/wasi-sdk-${WASI_SDK_VER}-x86_64-linux.tar.gz )
		arm64? ( https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VER/.*/}/wasi-sdk-${WASI_SDK_VER}-arm64-linux.tar.gz )
	)"

S="${WORKDIR}/${PN}-${PV%_*}"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="+clang dbus debug eme-free hardened hwaccel jack libproxy pgo pulseaudio selinux sndio"
IUSE+=" +system-av1 +system-harfbuzz +system-icu +system-jpeg +system-libevent +system-libvpx"
IUSE+=" system-pipewire system-png +system-webp test wayland wifi +X"

# Firefox-only IUSE
IUSE+=" +gmp-autoupdate gnome-shell +jumbo-build openh264 +telemetry wasm-sandbox"

REQUIRED_USE="|| ( X wayland )
	debug? ( !system-av1 )
	pgo? ( jumbo-build )
	wayland? ( dbus )
	wifi? ( dbus )
"

RESTRICT="!test? ( test )"

FF_ONLY_DEPEND="!www-client/firefox:0
	selinux? ( sec-policy/selinux-mozilla )"
BDEPEND="${PYTHON_DEPS}
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
		clang? (
			llvm-core/lld:${LLVM_SLOT}
			pgo? ( llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[profile] )
		)
		wasm-sandbox? ( llvm-core/lld:${LLVM_SLOT} )
	')
	app-alternatives/awk
	app-arch/unzip
	app-arch/zip
	>=dev-util/cbindgen-0.27.0
	net-libs/nodejs
	virtual/pkgconfig
	amd64? ( >=dev-lang/nasm-2.14 )
	x86? ( >=dev-lang/nasm-2.14 )
	pgo? (
		X? (
			sys-devel/gettext
			x11-base/xorg-server[xvfb]
			x11-apps/xhost
		)
		!X? (
			gui-wm/tinywl
			x11-misc/xkeyboard-config
		)
	)"
COMMON_DEPEND="${FF_ONLY_DEPEND}
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/glib:2
	dev-libs/libffi:=
	>=dev-libs/nss-3.112.2
	>=dev-libs/nspr-4.36
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa
	media-video/ffmpeg
	virtual/zlib:=
	virtual/freedesktop-icon-theme
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libdrm
	x11-libs/pango
	x11-libs/pixman
	dbus? (
		sys-apps/dbus
	)
	jack? ( virtual/jack )
	pulseaudio? (
		|| (
			media-libs/libpulse
			>=media-sound/apulse-0.1.12-r4[sdk]
		)
	)
	libproxy? ( net-libs/libproxy )
	selinux? ( sec-policy/selinux-mozilla )
	sndio? ( >=media-sound/sndio-1.8.0-r1 )
	system-av1? (
		>=media-libs/dav1d-1.0.0:=
		>=media-libs/libaom-3.10.0:=
	)
	system-harfbuzz? (
		>=media-libs/harfbuzz-2.8.1:0=
		!wasm-sandbox? ( >=media-gfx/graphite2-1.3.13 )
	)
	system-icu? ( >=dev-libs/icu-76.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1:= )
	system-libevent? ( >=dev-libs/libevent-2.1.12:0=[threads(+)] )
	system-libvpx? ( >=media-libs/libvpx-1.8.2:0=[postproc] )
	system-pipewire? ( >=media-video/pipewire-1.4.7-r2:= )
	system-png? ( >=media-libs/libpng-1.6.45:0=[apng] )
	system-webp? ( >=media-libs/libwebp-1.1.0:0= )
	wayland? (
		>=media-libs/libepoxy-1.5.10-r1
		x11-libs/gtk+:3[wayland]
	)
	wifi? (
		kernel_linux? (
			|| (
				net-misc/networkmanager
				net-misc/connman[networkmanager]
			)
			sys-apps/dbus
		)
	)
	X? (
		virtual/opengl
		x11-libs/cairo[X]
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrandr
		x11-libs/libxcb:=
	)"
RDEPEND="${COMMON_DEPEND}
	hwaccel? (
		media-video/libva-utils
		sys-apps/pciutils
	)
	jack? ( virtual/jack )
	openh264? ( media-libs/openh264:*[plugin] )"
DEPEND="${COMMON_DEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libICE
		x11-libs/libSM
	)"

# ESR and rapid dependencies.
if [[ -n ${MOZ_ESR} ]] ; then
	RDEPEND+=" !www-client/firefox:rapid"
else
	RDEPEND+=" !www-client/firefox:esr"
fi

# Allow MOZ_GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z "${MOZ_GMP_PLUGIN_LIST+set}" ]] ; then
	MOZ_GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

llvm_check_deps() {
	if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
		einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang && ! tc-ld-is-mold ; then
		if ! has_version -b "llvm-core/lld:${LLVM_SLOT}" ; then
			einfo "llvm-core/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi
	fi

	if use pgo ; then
		if ! has_version -b "=llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}*[profile]" ; then
			einfo "=llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}*[profile] is missing!" >&2
			einfo "Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

MOZ_LANGS=(
	af ar ast be bg br ca cak cs cy da de dsb
	el en-CA en-GB en-US es-AR es-ES et eu
	fi fr fy-NL ga-IE gd gl he hr hsb hu
	id is it ja ka kab kk ko lt lv ms nb-NO nl nn-NO
	pa-IN pl pt-BR pt-PT rm ro ru
	sk sl sq sr sv-SE th tr uk uz vi zh-CN zh-TW
)

# Firefox-only LANGS
MOZ_LANGS+=( ach )
MOZ_LANGS+=( an )
MOZ_LANGS+=( az )
MOZ_LANGS+=( bn )
MOZ_LANGS+=( bs )
MOZ_LANGS+=( ca-valencia )
MOZ_LANGS+=( eo )
MOZ_LANGS+=( es-CL )
MOZ_LANGS+=( es-MX )
MOZ_LANGS+=( fa )
MOZ_LANGS+=( ff )
MOZ_LANGS+=( fur )
MOZ_LANGS+=( gn )
MOZ_LANGS+=( gu-IN )
MOZ_LANGS+=( hi-IN )
MOZ_LANGS+=( hy-AM )
MOZ_LANGS+=( ia )
MOZ_LANGS+=( km )
MOZ_LANGS+=( kn )
MOZ_LANGS+=( lij )
MOZ_LANGS+=( mk )
MOZ_LANGS+=( mr )
MOZ_LANGS+=( my )
MOZ_LANGS+=( ne-NP )
MOZ_LANGS+=( oc )
MOZ_LANGS+=( sc )
MOZ_LANGS+=( sco )
MOZ_LANGS+=( si )
MOZ_LANGS+=( skr )
MOZ_LANGS+=( son )
MOZ_LANGS+=( szl )
MOZ_LANGS+=( ta )
MOZ_LANGS+=( te )
MOZ_LANGS+=( tl )
MOZ_LANGS+=( trs )
MOZ_LANGS+=( ur )
MOZ_LANGS+=( xh )

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO ne-NP nn-NO pa-IN sv-SE
	)

	local lang xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${lang} == en ]] || [[ ${lang} == en-US ]] ; then
			continue
		fi

		# strip region subtag if $lang is in the list
		if has ${lang} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${lang%%-*}
		else
			xflag=${lang}
		fi

		SRC_URI+=" l10n_${xflag/[_@]/-}? ("
		SRC_URI+=" ${MOZ_SRC_BASE_URI}/linux-x86_64/xpi/${lang}.xpi -> ${MOZ_P_DISTFILES}-${lang}.xpi"
		SRC_URI+=" )"
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
}
mozilla_set_globals

moz_clear_vendor_checksums() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -ne 1 ]] ; then
		die "${FUNCNAME} requires exact one argument"
	fi

	einfo "Clearing cargo checksums for ${1} ..."

	sed -i \
		-e 's/\("files":{\)[^}]*/\1/' \
		"${S}"/third_party/rust/${1}/.cargo-checksum.json || die
}

moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")

		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die

		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
		fi

		einfo "Installing ${emid}.xpi into ${ED}${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}

mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

mozconfig_use_with() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"
	[[ -n $XDG_RUNTIME_DIR ]] || die "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
	tinywl -h >/dev/null || die 'tinywl -h failed'

	local VIRTWL VIRTWL_PID
	coproc VIRTWL { WLR_BACKENDS=headless exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; }
	local -x WAYLAND_DISPLAY
	read WAYLAND_DISPLAY <&${VIRTWL[0]}

	debug-print "${FUNCNAME}: $@"
	"$@"
	local r=$?

	[[ -n $VIRTWL_PID ]] || die "tinywl exited unexpectedly"
	exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
	return $r
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		# Ensure we have enough disk space to compile
		if use pgo || use debug ; then
			CHECKREQS_DISK_BUILD="14300M"
		elif tc-is-lto ; then
			CHECKREQS_DISK_BUILD="10600M"
		else
			CHECKREQS_DISK_BUILD="7400M"
		fi

		check-reqs_pkg_pretend
	fi
}

pkg_setup() {

	# Get LTO from environment; export after this phase for use in src_configure (etc)
	use_lto=no

	if [[ ${MERGE_TYPE} != binary ]] ; then

		if tc-is-lto; then
			use_lto=yes
			# LTO is handled via configure
			filter-lto
		fi

		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
				eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

		if [[ ${use_lto} = yes ]]; then
			# -Werror=lto-type-mismatch -Werror=odr are going to fail with GCC,
			# bmo#1516758, bgo#942288
			filter-flags -Werror=lto-type-mismatch -Werror=odr
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use debug ; then
			CHECKREQS_DISK_BUILD="14300M"
		elif [[ ${use_lto} == "yes" ]] ; then
			CHECKREQS_DISK_BUILD="10600M"
		else
			CHECKREQS_DISK_BUILD="7400M"
		fi

		check-reqs_pkg_setup
		llvm-r1_pkg_setup
		rust_pkg_setup
		python-any-r1_pkg_setup

		# Avoid PGO profiling problems due to enviroment leakage
		# These should *always* be cleaned up anyway
		unset \
			DBUS_SESSION_BUS_ADDRESS \
			DISPLAY \
			ORBIT_SOCKETDIR \
			SESSION_MANAGER \
			XAUTHORITY \
			XDG_CACHE_HOME \
			XDG_SESSION_COOKIE

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if use pgo ; then
			# Update 105.0: "/proc/self/oom_score_adj" isn't enough anymore with pgo, but not sure
			# whether that's due to better OOM handling by Firefox (bmo#1771712), or portage
			# (PORTAGE_SCHEDULING_POLICY) update...
			addpredict /proc

			# Clear tons of conditions, since PGO is hardware-dependant.
			addpredict /dev
		fi

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
			ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
		# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
		# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_GOOGLE+set}" ]] ; then
			MOZ_API_KEY_GOOGLE="AIzaSyDEAOvatFogGaPi0eTgsV_ZlEzx0ObmepsMzfAc"
		fi

		if [[ -z "${MOZ_API_KEY_LOCATION+set}" ]] ; then
			MOZ_API_KEY_LOCATION="AIzaSyB2h2OuRgGaPicUgy5N-5hsZqiPW6sH3n_rptiQ"
		fi

		# Mozilla API keys (see https://location.services.mozilla.com/api)
		# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
		# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_MOZILLA+set}" ]] ; then
			MOZ_API_KEY_MOZILLA="edb3d487-3a84-46m0ap1e3-9dfd-92b5efaaa005"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	export use_lto

	CONFIG_CHECK="~SECCOMP"
	WARNING_SECCOMP="CONFIG_SECCOMP not set! This system will be unable to play DRM-protected content."
	linux-info_pkg_setup
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			unpack ${_src_file}
		fi
	done
}

src_prepare() {
	if [[ ${use_lto} == "yes" ]]; then
		rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch || die
	fi

	# Workaround for bgo#915651 on musl
	if use elibc_glibc ; then
		rm -v "${WORKDIR}"/firefox-patches/*bgo-748849-RUST_TARGET_override.patch || die
	fi

	eapply "${WORKDIR}/firefox-patches"
	use loong && eapply "${WORKDIR}/firefox-loong-patches"

	# ICU's subslot change should trigger rebuild on Firefox if it is updated 77->78.
	if use system-icu && has_version ">=dev-libs/icu-78.1" ; then
		eapply "${FILESDIR}/firefox-146.0.1-icu78.patch" # bgo#967261
	fi

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo#915651
	if ! use elibc_glibc ; then
		if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="i686-unknown-linux-musl"
		elif use arm64 ; then
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif use loong; then
			# Only the LP64D ABI of LoongArch64 is actively supported among
			# the wider Linux ecosystem, so the assumption is safe.
			export RUST_TARGET="loongarch64-unknown-linux-musl"
		elif use ppc64 ; then
			export RUST_TARGET="powerpc64le-unknown-linux-musl"
		elif use riscv ; then
			# We can pretty safely rule out any 32-bit riscvs, but 64-bit riscvs also have tons of
			# different ABIs available. riscv64gc-unknown-linux-musl seems to be the best working
			# guess right now though.
			elog "riscv detected, forcing a riscv64 target for now."
			export RUST_TARGET="riscv64gc-unknown-linux-musl"
		else
			die "Unknown musl chost, please post a new bug with your rustc -vV along with emerge --info"
		fi
	fi

	# Pre-built wasm-sandbox path manipulation.
	if use wasm-sandbox ; then
		if use amd64 ; then
			export wasi_arch="x86_64"
		elif use arm64 ; then
			export wasi_arch="arm64"
		else
			die "wasm-sandbox enabled on unknown/unsupported arch!"
		fi

		sed -i \
			-e "s:%%PORTAGE_WORKDIR%%:${WORKDIR}:" \
			-e "s:%%WASI_ARCH%%:${wasi_arch}:" \
			-e "s:%%WASI_SDK_VER%%:${WASI_SDK_VER}:" \
			-e "s:%%WASI_SDK_LLVM_VER%%:${WASI_SDK_LLVM_VER}:" \
			toolkit/moz.configure || die "Failed to update wasi-related paths."
	fi

	# Make LTO respect MAKEOPTS
	sed -i -e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/build/moz.configure/lto-pgo.configure || die "Failed sedding multiprocessing.cpu_count"

	sed -i -e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/third_party/chromium/build/toolchain/get_cpu_count.py || die "Failed sedding multiprocessing.cpu_count"

	sed -i -e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/third_party/python/gyp/pylib/gyp/input.py || die "Failed sedding multiprocessing.cpu_count"

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		"${S}"/python/mozbuild/mozbuild/configure/check_debug_ranges.py || die "sed failed to set toolchain prefix"

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}"/python/mozbuild/mozbuild/controller/building.py || die "sed failed to disable ccache stats call"

	einfo "Removing pre-built binaries ..."

	find "${S}"/third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	# Clear checksums from cargo crates we've manually patched.
	# moz_clear_vendor_checksums xyz

	# Respect choice for "jumbo-build"
	# Changing the value for FILES_PER_UNIFIED_FILE may not work, see #905431
	if [[ -n ${FILES_PER_UNIFIED_FILE} ]] && use jumbo-build; then
		local my_files_per_unified_file=${FILES_PER_UNIFIED_FILE:=16}
		elog ""
		elog "jumbo-build defaults modified to ${my_files_per_unified_file}."
		elog "if you get a build failure, try undefining FILES_PER_UNIFIED_FILE,"
		elog "if that fails try -jumbo-build before opening a bug report."
		elog ""

		sed -i -e "s/\"FILES_PER_UNIFIED_FILE\", 16/\"FILES_PER_UNIFIED_FILE\", "${my_files_per_unified_file}"/" \
			python/mozbuild/mozbuild/frontend/data.py ||
				die "Failed to adjust FILES_PER_UNIFIED_FILE in python/mozbuild/mozbuild/frontend/data.py"
		sed -i -e "s/FILES_PER_UNIFIED_FILE = 6/FILES_PER_UNIFIED_FILE = "${my_files_per_unified_file}"/" \
			js/src/moz.build ||
				die "Failed to adjust FILES_PER_UNIFIED_FILE in js/src/moz.build"
	fi

	# Create build dir
	BUILD_DIR="${WORKDIR}/${PN}_build"
	mkdir -p "${BUILD_DIR}" || die

	# Write API keys to disk
	echo -n "${MOZ_API_KEY_GOOGLE//gGaPi/}" > "${S}"/api-google.key || die
	echo -n "${MOZ_API_KEY_LOCATION//gGaPi/}" > "${S}"/api-location.key || die
	echo -n "${MOZ_API_KEY_MOZILLA//m0ap1/}" > "${S}"/api-mozilla.key || die

	xdg_environment_reset
}

src_configure() {
	# Show flags set at the beginning
	einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	local have_switched_compiler=
	if use clang; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."

		local version_clang=$(clang --version 2>/dev/null | grep -F -- 'clang version' | awk '{ print $3 }')
		[[ -n ${version_clang} ]] && version_clang=$(ver_cut 1 "${version_clang}")
		[[ -z ${version_clang} ]] && die "Failed to read clang version!"

		if tc-is-gcc; then
			have_switched_compiler=yes
		fi

		AR=llvm-ar
		CC=${CHOST}-clang-${version_clang}
		CXX=${CHOST}-clang++-${version_clang}
		NM=llvm-nm
		RANLIB=llvm-ranlib
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# Ensure we use correct toolchain,
	# AS is used in a non-standard way by upstream, #bmo1654031
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	export AS="$(tc-getCC) -c"

	# Configuration tests expect llvm-readelf output, bug 913130
	READELF="llvm-readelf"

	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB READELF PKG_CONFIG

	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="${SYSROOT:+--sysroot=${ESYSROOT}} --target=${CHOST} ${BINDGEN_CFLAGS-}"
	fi

	# Set MOZILLA_FIVE_HOME
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Set state path
	export MOZBUILD_STATE_PATH="${BUILD_DIR}"

	# Set MOZCONFIG
	export MOZCONFIG="${S}/.mozconfig"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-application=browser
	mozconfig_add_options_ac '' --enable-project=browser

	# Set Gentoo defaults
	if use telemetry; then
		export MOZILLA_OFFICIAL=1
	fi

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-disk-remnant-avoidance \
		--disable-geckodriver \
		--disable-install-strip \
		--disable-legacy-profile-creation \
		--disable-parental-controls \
		--disable-strip \
		--disable-updater \
		--disable-wmf \
		--enable-negotiateauth \
		--enable-new-pass-manager \
		--enable-official-branding \
		--enable-packed-relative-relocs \
		--enable-release \
		--enable-system-policies \
		--host="${CBUILD:-${CHOST}}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${CHOST}" \
		--without-ccache \
		--with-intl-api \
		--with-libclang-path="$(llvm-config --libdir)" \
		--with-system-ffi \
		--with-system-gbm \
		--with-system-libdrm \
		--with-system-nspr \
		--with-system-nss \
		--with-system-pixman \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-" \
		--with-unsigned-addon-scopes=app,system

	# Set update channel
	local update_channel=release
	[[ -n ${MOZ_ESR} ]] && update_channel=esr
	mozconfig_add_options_ac '' --enable-update-channel=${update_channel}

	# Whitelist to allow unkeyworded arches to build with "--disable-rust-simd" by default.
	if use amd64 || use arm64 || use ppc64 || use loong || use riscv ; then
		mozconfig_add_options_ac '' --enable-rust-simd
	fi

	# For future keywording: This is currently (97.0) only supported on:
	# amd64, arm, arm64 & x86.
	# Might want to flip the logic around if Firefox is to support more arches.
	# bug 833001, bug 903411#c8
	if use loong || use ppc64 || use riscv; then
		mozconfig_add_options_ac '' --disable-sandbox
	else
		mozconfig_add_options_ac '' --enable-sandbox
	fi

	# riscv-related options, bgo#947337, bgo#947338
	if use riscv ; then
		mozconfig_add_options_ac 'Disable JIT for RISC-V 64' --disable-jit
		mozconfig_add_options_ac 'Disable webrtc for RISC-V' --disable-webrtc
	fi

	if [[ -s "${S}/api-google.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${S}/api-google.key" | md5sum | awk '{ print $1 }') != 709560c02f94b41f9ad2c49207be6c54 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-google-safebrowsing-api-keyfile="${S}/api-google.key"
	else
		einfo "Building without Google API key ..."
	fi

	if [[ -s "${S}/api-location.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${S}/api-location.key" | md5sum | awk '{ print $1 }') != ffb7895e35dedf832eb1c5d420ac7420 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-google-location-service-api-keyfile="${S}/api-location.key"
	else
		einfo "Building without Location API key ..."
	fi

	if [[ -s "${S}/api-mozilla.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${S}/api-mozilla.key" | md5sum | awk '{ print $1 }') != 3927726e9442a8e8fa0e46ccc39caa27 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-mozilla-api-keyfile="${S}/api-mozilla.key"
	else
		einfo "Building without Mozilla API key ..."
	fi

	mozconfig_use_with system-av1
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libevent
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-pipewire
	mozconfig_use_with system-png
	mozconfig_use_with system-webp

	mozconfig_use_enable dbus
	mozconfig_use_enable libproxy

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now"

		# Increase the FORTIFY_SOURCE value, #910071.
		sed -i -e '/-D_FORTIFY_SOURCE=/s:2:3:' "${S}"/build/moz.configure/toolchain.configure || die
	fi

	local myaudiobackends=""
	use jack && myaudiobackends+="jack,"
	use sndio && myaudiobackends+="sndio,"
	use pulseaudio && myaudiobackends+="pulseaudio,"
	! use pulseaudio && myaudiobackends+="alsa,"

	mozconfig_add_options_ac '--enable-audio-backends' --enable-audio-backends="${myaudiobackends::-1}"

	mozconfig_use_enable wifi necko-wifi

	! use jumbo-build && mozconfig_add_options_ac '--disable-unified-build' --disable-unified-build

	if use X && use wayland ; then
		mozconfig_add_options_ac '+x11+wayland' --enable-default-toolkit=cairo-gtk3-x11-wayland
	elif ! use X && use wayland ; then
		mozconfig_add_options_ac '+wayland' --enable-default-toolkit=cairo-gtk3-wayland-only
	else
		mozconfig_add_options_ac '+x11' --enable-default-toolkit=cairo-gtk3-x11-only
	fi

	# wasm-sandbox
	# Since graphite2 is one of the sandboxed libraries, system-graphite2 obviously can't work with +wasm-sandbox.
	if use wasm-sandbox ; then
		mozconfig_add_options_ac '+wasm-sandbox' --with-wasi-sysroot="${WORKDIR}/wasi-sdk-${WASI_SDK_VER}-${wasi_arch}-linux/share/wasi-sysroot/"
	else
		mozconfig_add_options_ac 'no wasm-sandbox' --without-wasm-sandboxed-libraries
		mozconfig_use_with system-harfbuzz system-graphite2
	fi

	if [[ ${use_lto} == "yes" ]] ; then
		if use clang ; then
			# Upstream only supports lld or mold when using clang.
			if tc-ld-is-mold ; then
				# mold expects the -flto line from *FLAGS configuration, bgo#923119
				append-ldflags "-flto=thin"
				mozconfig_add_options_ac "using ld=mold due to system selection" --enable-linker=mold
			else
				mozconfig_add_options_ac "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld
			fi

			mozconfig_add_options_ac '+lto' --enable-lto=cross

		else
			# ThinLTO is currently broken, see bmo#1644409.
			# mold does not support gcc+lto combination.
			mozconfig_add_options_ac '+lto' --enable-lto=full
			mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
		fi

	else
		# Avoid auto-magic on linker
		if use clang ; then
			# lld is upstream's default
			if tc-ld-is-mold ; then
				mozconfig_add_options_ac "using ld=mold due to system selection" --enable-linker=mold
			else
				mozconfig_add_options_ac "forcing ld=lld due to USE=clang" --enable-linker=lld
			fi

		else
			if tc-ld-is-mold ; then
				mozconfig_add_options_ac "using ld=mold due to system selection" --enable-linker=mold
			else
				mozconfig_add_options_ac "linker is set to bfd due to USE=-clang" --enable-linker=bfd
			fi
		fi
	fi

	# PGO was moved outside lto block to allow building pgo without lto.
	if use pgo ; then
		mozconfig_add_options_ac '+pgo' MOZ_PGO=1

		# Avoid compressing just-built instrumented Firefox with
		# high levels of compression. Just use tar as a container
		# to save >=10 minutes.
		export MOZ_PKG_FORMAT=tar

		if use clang ; then
			# Used in build/pgo/profileserver.py
			export LLVM_PROFDATA="llvm-profdata"
		fi
	fi

	mozconfig_use_enable debug
	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
		mozconfig_add_options_ac '+debug' --enable-jemalloc
		mozconfig_add_options_ac '+debug' --enable-real-time-tracing
	else
		mozconfig_add_options_ac 'Gentoo defaults' --disable-real-time-tracing

		if is-flag '-g*' ; then
			if use clang ; then
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols=$(get-flag '-g*')
			else
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols
			fi
		else
			mozconfig_add_options_ac 'Gentoo default' --disable-debug-symbols
		fi

		if is-flag '-O0' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O0
		elif is-flag '-O4' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O4
		elif is-flag '-O3' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O3
		elif is-flag '-O1' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O1
		elif is-flag '-Os' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_add_options_ac "Gentoo default" --enable-optimize=-O2
		fi
	fi

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	# elf-hack
	# Filter "-z,pack-relative-relocs" and let the build system handle it instead.
	if use amd64 || use x86 ; then
		filter-flags "-z,pack-relative-relocs"

		if tc-ld-is-mold ; then
			# relr-elf-hack is currently broken with mold, bgo#916259
			mozconfig_add_options_ac 'disable elf-hack with mold linker' --disable-elf-hack
		else
			mozconfig_add_options_ac 'relr elf-hack' --enable-elf-hack=relr
		fi
	elif use loong || use ppc64 || use riscv ; then
		# '--disable-elf-hack' is not recognized on loong/ppc64/riscv,
		# see bgo #917049, #930046
		:;
	else
		mozconfig_add_options_ac 'disable elf-hack on non-supported arches' --disable-elf-hack
	fi

	if ! use elibc_glibc; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	fi

	# System-av1 fix
	use system-av1 && append-ldflags "-Wl,--undefined-version"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"

	if ! use telemetry; then
		mozconfig_add_options_mk '-telemetry setting' "MOZ_CRASHREPORTER=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_DATA_REPORTING=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_SERVICES_HEALTHREPORT=0"
		mozconfig_add_options_mk '-telemetry setting' "MOZ_TELEMETRY_REPORTING=0"
	fi

	mozconfig_use_enable test tests

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_DIR}"

	# Show flags we will use
	einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Build RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	# Handle EXTRA_CONF and show summary
	local ac opt hash reason

	# Apply EXTRA_ECONF entries to $MOZCONFIG
	if [[ -n ${EXTRA_ECONF} ]] ; then
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig_add_options_ac "EXTRA_ECONF" --${opt#--}
		done
	fi

	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options "${MOZCONFIG}" | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	./mach configure || die
}

src_compile() {
	local virtx_cmd=

	if [[ ${use_lto} == "yes" ]] && tc-ld-is-mold ; then
		# increase ulimit with mold+lto, bugs #892641, #907485
		if ! ulimit -n 16384 1>/dev/null 2>&1 ; then
			ewarn "Unable to modify ulimits - building with mold+lto might fail due to low ulimit -n resources."
			ewarn "Please see bugs #892641 & #907485."
		else
			ulimit -n 16384
		fi
	fi

	if use pgo; then
		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root

		if ! use X; then
			virtx_cmd=virtwl
		else
			virtx_cmd=virtx
		fi
	fi

	if ! use X; then
		local -x GDK_BACKEND=wayland
	else
		local -x GDK_BACKEND=x11
	fi

	${virtx_cmd} ./mach build --verbose || die
}

src_test() {
	# https://firefox-source-docs.mozilla.org/testing/automated-testing/index.html
	local -a failures=()

	# Some tests respect this
	local -x MOZ_HEADLESS=1

	# Check testing/mach_commands.py
	einfo "Testing with cppunittest ..."
	./mach cppunittest
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		eerror "Test suite cppunittest failed with error code ${ret}"
		failures+=( cppunittest )
	fi

	if [[ ${#failures} -eq 0 ]]; then
		einfo "Test suites succeeded"
	else
		die "Test suites failed: ${failures[@]}"
	fi
}

src_install() {
	# xpcshell is getting called during install
	pax-mark m \
		"${BUILD_DIR}"/dist/bin/xpcshell \
		"${BUILD_DIR}"/dist/bin/${PN} \
		"${BUILD_DIR}"/dist/bin/plugin-container

	DESTDIR="${D}" ./mach install || die

	# Upstream cannot ship symlink but we can (bmo#658850)
	rm "${ED}${MOZILLA_FIVE_HOME}/${PN}-bin" || die
	dosym ${PN} ${MOZILLA_FIVE_HOME}/${PN}-bin

	# Don't install llvm-symbolizer from llvm-core/llvm package
	if [[ -f "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] ; then
		rm -v "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" || die
	fi

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}"/distribution.ini distribution.ini
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs.js gentoo-prefs.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	# Set dictionary path to use system hunspell
	cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set spellchecker.dictionary_path pref"
	pref("spellchecker.dictionary_path", "${EPREFIX}/usr/share/myspell");
	EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-r2 \
		>>"${GENTOO_PREFS}" \
		|| die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"

		if use wayland; then
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel wayland prefs"
			pref("gfx.x11-egl.force-enabled", false);
			EOF
		else
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel x11 prefs"
			pref("gfx.x11-egl.force-enabled", true);
			EOF
		fi

		# Install the vaapitest binary on supported arches (122.0 supports all platforms, bmo#1865969)
		exeinto "${MOZILLA_FIVE_HOME}"
		doexe "${BUILD_DIR}"/dist/bin/vaapitest

		# Install the v4l2test on supported arches (+ arm, + riscv64 when keyworded)
		if use arm64 ; then
			exeinto "${MOZILLA_FIVE_HOME}"
			doexe "${BUILD_DIR}"/dist/bin/v4l2test
		fi
	fi

	if ! use gmp-autoupdate ; then
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			einfo "Disabling auto-update for ${plugin} plugin ..."
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to disable autoupdate for ${plugin} media plugin"
			pref("media.${plugin}.autoupdate", false);
			EOF
		done
	fi

	# Force the graphite pref if USE=system-harfbuzz is enabled, since the pref cannot disable it
	if use system-harfbuzz ; then
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set gfx.font_rendering.graphite.enabled pref"
		sticky_pref("gfx.font_rendering.graphite.enabled", true);
		EOF
	fi

	# Add telemetry config prefs, just in case something happens in future and telemetry build
	# options stop working.
	if ! use telemetry ; then
		cat "${FILESDIR}"/gentoo-telemetry-prefs.js >>"${GENTOO_PREFS}" || die "failed to set telemetry prefs"
	fi

	# Install language packs
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi "${MOZILLA_FIVE_HOME}/distribution/extensions" "${langpacks[@]}"
	fi

	# Install icons
	local icon_srcdir="${S}/browser/branding/official"

	# Prefer the upstream svg file they use when packaging flatpak so it's always up-to-date.
	insinto /usr/share/icons/hicolor/symbolic/apps
	newins "${S}"/browser/installer/linux/app/flatpak/files/share/icons/hicolor/symbolic/apps/org.mozilla.firefox-symbolic.svg firefox-symbolic.svg
	dosym -r /usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg /usr/share/icons/hicolor/symbolic/apps/org.mozilla.firefox-symbolic.svg

	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
	done

	# Install menu
	local app_name="Mozilla ${MOZ_PN^}"
	local desktop_file="${FILESDIR}/icon/${PN}-r3.desktop"
	local exec_command="${PN}"
	local icon="${PN}"
	local use_wayland="false"

	if [[ -n ${MOZ_ESR} ]] ; then
		local desktop_filename="${PN}-esr.desktop"
	else
		local desktop_filename="${PN}.desktop"
	fi

	if use wayland ; then
		use_wayland="true"
	fi

	cp "${desktop_file}" "${WORKDIR}/${PN}.desktop-template" || die

	sed -i \
		-e "s:@NAME@:${app_name}:" \
		-e "s:@EXEC@:${exec_command}:" \
		-e "s:@ICON@:${icon}:" \
		"${WORKDIR}/${PN}.desktop-template" || die

	newmenu "${WORKDIR}/${PN}.desktop-template" "${desktop_filename}"

	rm "${WORKDIR}/${PN}.desktop-template" || die

	if use gnome-shell ; then
		# Install search provider for Gnome
		insinto /usr/share/gnome-shell/search-providers/
		doins browser/components/shell/search-provider-files/org.mozilla.firefox.search-provider.ini

		insinto /usr/share/dbus-1/services/
		doins browser/components/shell/search-provider-files/org.mozilla.firefox.SearchProvider.service

		# Toggle between rapid and esr desktop file names
		if [[ -n ${MOZ_ESR} ]] ; then
			sed -e "s/firefox.desktop/${desktop_filename}/g" \
				-i "${ED}/usr/share/gnome-shell/search-providers/org.mozilla.firefox.search-provider.ini" ||
					die "Failed to sed org.mozilla.firefox.search-provider.ini file."
		fi

		# Make the dbus service aware of a previous session, bgo#939196
		sed -e \
			"s/Exec=\/usr\/bin\/firefox/Exec=\/usr\/$(get_libdir)\/firefox\/firefox --dbus-service \/usr\/bin\/firefox/g" \
			-i "${ED}/usr/share/dbus-1/services/org.mozilla.firefox.SearchProvider.service" ||
				die "Failed to sed org.mozilla.firefox.SearchProvider.service dbus file"

		# Update prefs to enable Gnome search provider
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to enable gnome-search-provider via prefs"
		pref("browser.gnome-search-provider.enabled", true);
		EOF
	fi

	# Install wrapper script
	[[ -f "${ED}/usr/bin/${PN}" ]] && rm "${ED}/usr/bin/${PN}"
	newbin "${FILESDIR}/${PN}-r1.sh" ${PN}

	# Update wrapper
	sed -i \
		-e "s:@PREFIX@:${EPREFIX}/usr:" \
		-e "s:@DEFAULT_WAYLAND@:${use_wayland}:" \
		"${ED}/usr/bin/${PN}" || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use gmp-autoupdate ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			elog "\t ${plugin}"
		done
		elog
	fi

	# bug 835078
	if use hwaccel && has_version "x11-drivers/xf86-video-nouveau"; then
		ewarn "You have nouveau drivers installed in your system and 'hwaccel' "
		ewarn "enabled for Firefox. Nouveau / your GPU might not support the "
		ewarn "required EGL, so either disable 'hwaccel' or try the workaround "
		ewarn "explained in https://bugs.gentoo.org/835078#c5 if Firefox crashes."
	fi

	readme.gentoo_print_elog

	optfeature_header "Optional programs for extra features:"
	optfeature "desktop notifications" x11-libs/libnotify
	optfeature "fallback mouse cursor theme e.g. on WMs" gnome-base/gsettings-desktop-schemas
	optfeature "screencasting with pipewire" sys-apps/xdg-desktop-portal
	if use hwaccel && has_version "x11-drivers/nvidia-drivers"; then
		optfeature "hardware acceleration with NVIDIA cards" media-libs/nvidia-vaapi-driver
	fi

	if ! has_version "sys-libs/glibc"; then
		elog
		elog "glibc not found! You won't be able to play DRM content."
		elog "See Gentoo bug #910309 or upstream bug #1843683."
		elog
	fi
}
