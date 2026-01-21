# Copyright 2009-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PACKAGING NOTES

# Upstream roll their bundled Clang every two weeks, and the bundled Rust
# is rolled regularly and depends on that. While we do our best to build
# with system Clang, we may eventually hit the point where we need to use
# the bundled Clang due to the use of prerelease features.

# USE=bundled-toolchain is intended for users who want to use the same toolchain
# as the upstream releases. It's also a good fallback in case we fall behind
# and need to get a release out quickly (less likely with `dev` in-tree).
# We can't rely on it as a default since the toolchain is only shipped for x86-64;
# other architectures will need to use system toolchain.

# Since m133 we are using CI-generated tarballs from
# https://github.com/chromium-linux-tarballs/chromium-tarballs/

# These are bit-for-bit identical to the official releases, but are built
# using an external CI system that we have some control over, in case
# issues pop up again with official tarball generation.

GN_MIN_VER=0.2235
# chromium-tools/get-chromium-toolchain-strings.py
TEST_FONT=a28b222b79851716f8358d2800157d9ffe117b3545031ae51f69b7e1e1b9a969
BUNDLED_CLANG_VER=llvmorg-22-init-14273-gea10026b-2
BUNDLED_RUST_VER=11339a0ef5ed586bb7ea4f85a9b7287880caac3a-1
RUST_SHORT_HASH=${BUNDLED_RUST_VER:0:10}-${BUNDLED_RUST_VER##*-}
NODE_VER=24.11.1

VIRTUALX_REQUIRED="pgo"

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

LLVM_COMPAT=( 21 )
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
RUST_MIN_VER=1.91.0
RUST_NEEDS_LLVM="yes please"
RUST_OPTIONAL="yes" # Not actually optional, but we don't need system Rust (or LLVM) with USE=bundled-toolchain

inherit check-reqs chromium-2 desktop flag-o-matic llvm-r1 multiprocessing ninja-utils pax-utils
inherit python-any-r1 readme.gentoo-r1 rust systemd toolchain-funcs virtualx xdg-utils

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://www.chromium.org/"
PPC64_HASH="a85b64f07b489b8c6fdb13ecf79c16c56c560fc6"
PATCH_V="${PV%%\.*}-1"
COPIUM_COMMIT="bd8cca0b09a9316960853a3150c26e18ed59afd9"
SRC_URI="https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/${PV}/chromium-${PV}-linux.tar.xz
	!bundled-toolchain? (
		https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_V}/chromium-patches-${PATCH_V}.tar.bz2
		https://codeberg.org/selfisekai/copium/archive/${COPIUM_COMMIT}.tar.gz
			-> chromium-patches-copium-${COPIUM_COMMIT:0:10}.tar.gz
	)
	bundled-toolchain? (
		https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/clang-${BUNDLED_CLANG_VER}.tar.xz
			-> chromium-clang-${BUNDLED_CLANG_VER}.tar.xz
		https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/rust-toolchain-${BUNDLED_RUST_VER}-${BUNDLED_CLANG_VER%-*}.tar.xz
			-> chromium-rust-toolchain-${RUST_SHORT_HASH}-${BUNDLED_CLANG_VER%-*}.tar.xz
	)
	ppc64? (
		https://gitlab.raptorengineering.com/raptor-engineering-public/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2 -> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	pgo? ( https://github.com/elkablo/chromium-profiler/releases/download/v0.2/chromium-profiler-0.2.tar )"

# https://gitweb.gentoo.org/proj/chromium-tools.git/tree/get-chromium-licences.py
LICENSE="BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD"
LICENSE+=" FFT2D FTL IJG ISC LGPL-2 LGPL-2.1 libpng libpng2 MIT MPL-1.1 MPL-2.0 Ms-PL openssl PSF-2"
LICENSE+=" SGI-B-2.0 SSLeay SunSoft Unicode-3.0 Unicode-DFS-2015 Unlicense UoI-NCSA X11-Lucent"
LICENSE+=" rar? ( unRAR )"

SLOT="0/stable"
# Dev exists mostly to give devs some breathing room for beta/stable releases;
# it shouldn't be keyworded but adventurous users can select it.
KEYWORDS="~amd64 ~arm64"

IUSE_SYSTEM_LIBS="+system-harfbuzz +system-icu +system-zstd"
IUSE="+X ${IUSE_SYSTEM_LIBS} bindist bundled-toolchain cups debug ffmpeg-chromium gtk4 +hangouts headless kerberos +official pax-kernel pgo"
IUSE+=" +proprietary-codecs pulseaudio qt6 +rar +screencast selinux test +vaapi +wayland +widevine cpu_flags_ppc_vsx3"
RESTRICT="
	!bindist? ( bindist )
	test" # Since M142 tests have been segfaulting on Gentoo systems; disabling for now.

REQUIRED_USE="
	!headless? ( || ( X wayland ) )
	pgo? ( X !wayland )
	screencast? ( wayland )
	ffmpeg-chromium? ( bindist proprietary-codecs )
"

COMMON_X_DEPEND="
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXtst:=
	x11-libs/libxshmfence:=
"

# sys-libs/zlib: https://bugs.gentoo.org/930365; -ng is not compatible.
COMMON_SNAPSHOT_DEPEND="
	system-icu? ( >=dev-libs/icu-73.0:= )
	>=dev-libs/libxml2-2.12.4:=[icu]
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	dev-libs/libxslt:=
	media-libs/fontconfig:=
	>=media-libs/freetype-2.11.0-r1:=
	system-harfbuzz? ( >=media-libs/harfbuzz-3:0=[icu(-)] )
	media-libs/libjpeg-turbo:=
	system-zstd? ( >=app-arch/zstd-1.5.5:= )
	>=media-libs/libwebp-0.4.0:=
	media-libs/mesa:=[gbm(+)]
	>=media-libs/openh264-1.6.0:=
	sys-libs/zlib:=
	!headless? (
		dev-libs/glib:2
		>=media-libs/alsa-lib-1.0.19:=
		pulseaudio? ( media-libs/libpulse:= )
		sys-apps/pciutils:=
		kerberos? ( virtual/krb5 )
		vaapi? ( >=media-libs/libva-2.7:=[X?,wayland?] )
		X? (
			x11-base/xorg-proto:=
			x11-libs/libX11:=
			x11-libs/libxcb:=
			x11-libs/libXext:=
		)
		x11-libs/libxkbcommon:=
		wayland? (
			dev-libs/libffi:=
			dev-libs/wayland:=
			screencast? ( media-video/pipewire:= )
		)
	)
"

COMMON_DEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	app-arch/bzip2:=
	dev-libs/expat:=
	net-misc/curl[ssl]
	sys-apps/dbus:=
	media-libs/flac:=
	sys-libs/zlib:=[minizip]
	!headless? (
		>=app-accessibility/at-spi2-core-2.46.0:2
		media-libs/mesa:=[X?,wayland?]
		virtual/udev
		x11-libs/cairo:=
		x11-libs/gdk-pixbuf:2
		x11-libs/pango:=
		cups? ( >=net-print/cups-1.3.11:= )
		qt6? ( dev-qt/qtbase:6[gui,widgets] )
		X? ( ${COMMON_X_DEPEND} )
	)
"
RDEPEND="${COMMON_DEPEND}
	!headless? (
		|| (
			x11-libs/gtk+:3[X?,wayland?]
			gui-libs/gtk:4[X?,wayland?]
		)
		qt6? ( dev-qt/qtbase:6[X?,wayland?] )
	)
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	bindist? (
		!ffmpeg-chromium? ( >=media-video/ffmpeg-6.1-r1:0/58.60.60[chromium] )
		ffmpeg-chromium? ( media-video/ffmpeg-chromium:${PV%%\.*} )
	)
"
DEPEND="${COMMON_DEPEND}
	!headless? (
		gtk4? ( gui-libs/gtk:4[X?,wayland?] )
		!gtk4? ( x11-libs/gtk+:3[X?,wayland?] )
	)
"

BDEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	>=app-arch/gzip-1.7
	!headless? (
		qt6? ( dev-qt/qtbase:6 )
	)
	!bundled-toolchain? ( $(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
		official? (
			!ppc64? ( llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi] )
		) ')
		${RUST_DEPEND}
	)
	pgo? (
		>=dev-python/selenium-3.141.0
		>=dev-util/web_page_replay_go-20220314
	)
	>=dev-util/bindgen-0.68.0
	>=dev-build/gn-${GN_MIN_VER}
	app-alternatives/ninja
	dev-lang/perl
	>=dev-util/gperf-3.2
	dev-vcs/git
	>=net-libs/nodejs-${NODE_VER}[inspector]
	sys-apps/hwdata
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.

To make password storage work with your desktop environment you may
have install one of the supported credentials management applications:
- app-crypt/libsecret (GNOME)
- kde-frameworks/kwallet (KDE)
If you have one of above packages installed, but don't want to use
them in Chromium, then add --password-store=basic to CHROMIUM_FLAGS
in /etc/chromium/default.
"

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pre_build_checks() {
	# Check build requirements: bugs #471810, #541816, #914220
	# We're going to start doing maths here on the size of an unpacked source tarball,
	# this should make updates easier as chromium continues to balloon in size.
	# xz -l /var/cache/distfiles/chromium-${PV}*.tar.xz
	local base_disk=9 # Round up
	use test && base_disk=$((base_disk + 5))
	local extra_disk=1 # Always include a little extra space
	local memory=4
	tc-is-cross-compiler && extra_disk=$((extra_disk * 2))
	if tc-is-lto || use pgo; then
		memory=$((memory * 2 + 1))
		tc-is-cross-compiler && extra_disk=$((extra_disk * 2)) # Double the requirements
		use pgo && extra_disk=$((extra_disk + 4))
	fi
	if is-flagq '-g?(gdb)?([1-9])'; then
		if use custom-cflags; then
			extra_disk=$((extra_disk + 5))
		fi
		memory=$((memory * 2))
	fi
	local CHECKREQS_MEMORY="${memory}G"
	local CHECKREQS_DISK_BUILD="$((base_disk + extra_disk))G"
	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks
	fi

	if use headless; then
		local headless_unused_flags=("cups" "kerberos" "pulseaudio" "qt6" "vaapi" "wayland")
		for myiuse in ${headless_unused_flags[@]}; do
			use ${myiuse} && ewarn "Ignoring USE=${myiuse}, USE=headless is set."
		done
	fi

	if ! use bindist && use ffmpeg-chromium; then
		ewarn "Ignoring USE=ffmpeg-chromium, USE=bindist is not set."
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks

		# The linux:unbundle toolchain in GN grabs CC, CXX, CPP (etc) from the environment
		# We'll set these to clang here then use llvm-utils functions to very explicitly set these
		# to a sane value.
		# This is effectively the 'force-clang' path if GCC support is re-added.
		# TODO: check if the user has already selected a specific impl via make.conf and respect that.
		use_lto="false"
		if tc-is-lto; then
			use_lto="true"
			# We can rely on GN to do this for us; anecdotally without this builds
			# take significantly longer with LTO enabled and it doesn't hurt anything.
			filter-lto
		fi

		if [ "$use_lto" = "false" ] && use official; then
			einfo "USE=official selected and LTO not detected."
			einfo "It is _highly_ recommended that LTO be enabled for performance reasons"
			einfo "and to be consistent with the upstream \"official\" build optimisations."
		fi

		if [ "$use_lto" = "false" ] && use test; then
			die "Tests require CFI which requires LTO"
		fi

		export use_lto

		# 936858
		if tc-ld-is-mold; then
			eerror "Your toolchain is using the mold linker."
			eerror "This is not supported by Chromium."
			die "Please switch to a different linker."
		fi

		if use !bundled-toolchain; then
			llvm-r1_pkg_setup
			rust_pkg_setup
		fi

		# Forcing clang; respect llvm_slot_x to enable selection of impl from LLVM_COMPAT
		AR=llvm-ar
		CPP="${CHOST}-clang++-${LLVM_SLOT} -E"
		NM=llvm-nm
		CC="${CHOST}-clang-${LLVM_SLOT}"
		CXX="${CHOST}-clang++-${LLVM_SLOT}"

		if tc-is-cross-compiler; then
			use pgo && die "The pgo USE flag cannot be used when cross-compiling"
			CPP="${CBUILD}-clang++-${LLVM_SLOT} -E"
		fi

		# I hate doing this but upstream Rust have yet to come up with a better solution for
		# us poor packagers. Required for Split LTO units, which are required for CFI.
		export RUSTC_BOOTSTRAP=1

		# Users should never hit this, it's purely a development convenience
		if ver_test $(gn --version || die) -lt ${GN_MIN_VER}; then
			die "dev-build/gn >= ${GN_MIN_VER} is required to build this Chromium"
		fi
	fi

	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack ${P}-linux.tar.xz
	# These should only be required when we're not using the official toolchain
	if use !bundled-toolchain; then
		unpack chromium-patches-${PATCH_V}.tar.bz2
		unpack chromium-patches-copium-${COPIUM_COMMIT:0:10}.tar.gz
	fi

	use pgo && unpack chromium-profiler-0.2.tar

	if use test; then
		# A new testdata tarball is available for each release; but testfonts tend to remain stable
		# for the duration of a release.
		# This unpacks directly into/over ${WORKDIR}/${P} so we can just use `unpack`.
		unpack ${P}-linux-testdata.tar.xz
		# This just contains a bunch of font files that need to be unpacked (or moved) to the correct location.
		local testfonts_dir="${WORKDIR}/${P}/third_party/test_fonts"
		local testfonts_tar="${DISTDIR}/chromium-testfonts-${TEST_FONT:0:10}.tar.gz"
		tar xf "${testfonts_tar}" -C "${testfonts_dir}" || die "Failed to unpack testfonts"
	fi

	# We need to manually unpack this since M126 else we'd unpack one toolchain over the other.
	# Since we're doing that anyway let's unpack to sensible locations to make symlink creation easier.
	if use bundled-toolchain; then
		einfo "Unpacking bundled Clang ..."
		mkdir -p "${WORKDIR}"/clang || die "Failed to create clang directory"
		tar xf "${DISTDIR}/chromium-clang-${BUNDLED_CLANG_VER}.tar.xz" -C "${WORKDIR}/clang" || die "Failed to unpack Clang"
		einfo "Unpacking bundled Rust ..."
		local rust_dir="${WORKDIR}/rust-toolchain"
		mkdir -p "${rust_dir}" || die "Failed to create rust toolchain directory"
		tar xf "${DISTDIR}/chromium-rust-toolchain-${RUST_SHORT_HASH}-${BUNDLED_CLANG_VER%-*}.tar.xz" -C "${rust_dir}" ||
			die "Failed to unpack Rust"
	fi

	if use ppc64; then
		unpack chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	fi
}

remove_compiler_builtins() {
	# We can't use the bundled compiler builtins with the system toolchain
	# We used to `grep` then `sed`, but it was indirect. Combining the two into a single
	# `awk` command is more efficient and lets us document the logic more clearly.

	local pattern='    configs += [ "//build/config/clang:compiler_builtins" ]'
	local target='build/config/compiler/BUILD.gn'

	local tmpfile
	tmpfile=$(mktemp) || die "Failed to create temporary file."

	if awk -v pat="${pattern}" '
	BEGIN {
		match_found = 0
	}

	# If the delete countdown is active, decrement it and skip to the next line.
	d > 0 { d--; next }

	# If the current line matches the pattern...
	$0 == pat {
		match_found = 1   # ...set our flag to true.
		d = 2             # Set delete counter for this line and the next two.
		prev = ""         # Clear the buffered previous line so it is not printed.
		next
	}

	# For any other line, print the buffered previous line.
	NR > 1 { print prev }

	# Buffer the current line to be printed on the next cycle.
	{ prev = $0 }

	END {
		# Print the last line if it was not part of a deleted block.
		if (d == 0) { print prev }

		# If the pattern was never found, exit with a failure code.
		if (match_found == 0) {
		exit 1
		}
	}
	' "${target}" > "${tmpfile}"; then
		# AWK SUCCEEDED (exit code 0): The pattern was found and edited.
		# This is to avoid gawk's `-i inplace` option which users complain about.
		mv "${tmpfile}" "${target}"
	else
		# AWK FAILED (exit code 1): The pattern was not found.
		rm -f "${tmpfile}"
		die "Awk patch failed: Pattern not found in ${target}."
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# To know which patches are safe to drop from files/ after tidying up old ebuilds:
	# comm -13 \
	# 	<(grep 'FILESDIR' *.ebuild | grep patch | grep -o '\${FILESDIR}/[^") ]*' \
	#		| sed 's|\${FILESDIR}/|files/|; s|\${PN}|chromium|' | sort -u) \
	# 	<(find files/ -name "*.patch" | sort)

	# The patches here should apply to both the bundled and system toolchain builds.
	# If it's something that we're doing to fix a build issue it's _probably_ not
	# something that impacts the upstream toolchain builds - test and confirm though.

	local PATCHES=(
		"${FILESDIR}/${PN}-109-system-zlib.patch"
		"${FILESDIR}/${PN}-131-unbundle-icu-target.patch"
		"${FILESDIR}/${PN}-135-oauth2-client-switches.patch"
		"${FILESDIR}/${PN}-138-nodejs-version-check.patch"
		"${FILESDIR}/${PN}-cross-compile.patch"
	)

	# https://issues.chromium.org/issues/442698344
	# Unreleased fontconfig changed magic numbers and google have rolled to this version
	if has_version "<=media-libs/fontconfig-2.17.1"; then
		PATCHES+=( "${FILESDIR}/chromium-142-work-with-old-fontconfig.patch" )
	fi

	if use bundled-toolchain; then
		# We need to symlink the toolchain into the expected location
		einfo "Symlinking Clang toolchain to expected location ..."
		mkdir -p third_party/llvm-build/ || die "Failed to create llvm-build directory"
		# the 'Chromium Linux Tarballs' seem to already have 'Release+Asserts/{lib,bin}'; not sure if this is an
		# upstream change - we're using the same scripts to build, theoretically. We'll still attempt to create
		# llvm-build, but we'll rm Release+Asserts and symlink directly.
		if [[ -d third_party/llvm-build/Release+Asserts ]]; then
			rm -r third_party/llvm-build/Release+Asserts || die "Failed to remove third_party/llvm-build/Release+Asserts"
		fi
		ln -s "${WORKDIR}"/clang third_party/llvm-build/Release+Asserts || die "Failed to bundle Clang"
		einfo "Symlinking Rust toolchain to expected location ..."
		# As above, so below
		if [[ -d third_party/rust-toolchain ]]; then
			rm -r third_party/rust-toolchain || die "Failed to remove third_party/rust-toolchain"
		fi
		ln -s "${WORKDIR}"/rust-toolchain third_party/rust-toolchain || die "Failed to bundle rust"
		cp "${WORKDIR}"/rust-toolchain/VERSION \
			"${WORKDIR}"/rust-toolchain/INSTALLED_VERSION || die "Failed to set rust version"
	else
		# We don't need our toolchain patches if we're using the official toolchain

		if use !bundled-toolchain; then
			PATCHES+=(
				"${WORKDIR}/copium/cr143-libsync-__BEGIN_DECLS.patch"
			)
		fi

		shopt -s globstar nullglob
		# 130: moved the PPC64 patches into the chromium-patches repo
		local patch
		for patch in "${WORKDIR}/chromium-patches-${PATCH_V}"/**/*.patch; do
			if [[ ${patch} == *"ppc64le"* ]]; then
				use ppc64 && PATCHES+=( "${patch}" )
			else
				PATCHES+=( "${patch}" )
			fi
		done

		shopt -u globstar nullglob

		remove_compiler_builtins

		# Strictly speaking this doesn't need to be gated (no bundled toolchain for ppc64); it keeps the logic together
		if use ppc64; then
			local patchset_dir="${WORKDIR}/openpower-patches-${PPC64_HASH}/patches"
			# patch causes build errors on 4K page systems (https://bugs.gentoo.org/show_bug.cgi?id=940304)
			local page_size_patch="ppc64le/third_party/use-sysconf-page-size-on-ppc64.patch"
			local isa_3_patch="ppc64le/core/baseline-isa-3-0.patch"
			# Apply the OpenPOWER patches (check for page size and isa 3.0)
			openpower_patches=( $(grep -E "^ppc64le|^upstream" "${patchset_dir}/series" | grep -v "${page_size_patch}" |
				grep -v "${isa_3_patch}" || die) )
			for patch in "${openpower_patches[@]}"; do
				PATCHES+=( "${patchset_dir}/${patch}" )
			done
			if [[ $(getconf PAGESIZE) == 65536 ]]; then
				PATCHES+=( "${patchset_dir}/${page_size_patch}" )
			fi
			# We use vsx3 as a proxy for 'want isa3.0' (POWER9)
			if use cpu_flags_ppc_vsx3 ; then
				PATCHES+=( "${patchset_dir}/${isa_3_patch}" )
			fi
		fi

		# Oxidised hacks, let's keep 'em all in one place
		# "Adler2" is part of the stdlib since Rust 1.86, but it's behind a nightly-only feature flag in GN.
		PATCHES+=( "${WORKDIR}/copium/cr144-rust-1.86-is-not-nightly--adler2.patch" )
	fi

	default

	# Not included in -lite tarballs, but we should check for it anyway.
	if [[ -f third_party/node/linux/node-linux-x64/bin/node ]]; then
		rm third_party/node/linux/node-linux-x64/bin/node || die
	else
		mkdir -p third_party/node/linux/node-linux-x64/bin || die
	fi
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die

	# Use the system copy of hwdata's usb.ids; upstream is woefully out of date (2015!)
	sed 's|//third_party/usb_ids/usb.ids|/usr/share/hwdata/usb.ids|g' \
		-i services/device/public/cpp/usb/BUILD.gn || die "Failed to set system usb.ids path"

	# remove_bundled_libraries.py walks the source tree and looks for paths containing the substring 'third_party'
	# whitelist matches use the right-most matching path component, so we need to whitelist from that point down.
	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		net/third_party/mozilla_security_manager
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/ceval
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/volk
		third_party/anonymous_tokens
		third_party/apple_apsl
		third_party/axe-core
		third_party/bidimapper
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4-4.9.3
		third_party/catapult/third_party/html5lib-1.1
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/compiler-rt # Since M137 atomic is required; we could probably unbundle this as a target of opportunity.
		third_party/content_analysis_sdk
		third_party/cpuinfo
		third_party/crabbyavif
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/d3
		third_party/dav1d
		third_party/dawn
		third_party/dawn/third_party/gn/webgpu-cts
		third_party/dawn/third_party/khronos
		third_party/dawn/third_party/webgpu-headers
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/csp_evaluator
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/json5
		third_party/devtools-frontend/src/front_end/third_party/legacy-javascript
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/parsel-js
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/source-map-scopes-codec
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/dom_distiller_js
		third_party/dragonbox
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fast_float
		third_party/fdlibm
		third_party/federated_compute/chromium/fcp/confidentialcompute
		third_party/federated_compute/src/fcp/base
		third_party/federated_compute/src/fcp/confidentialcompute
		third_party/federated_compute/src/fcp/protos/confidentialcompute
		third_party/federated_compute/src/fcp/protos/federatedcompute
		third_party/ffmpeg
		third_party/fft2d
		third_party/flatbuffers
		third_party/fp16
		third_party/freetype
		third_party/fusejs
		third_party/fxdiv
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/highway
		third_party/hunspell
		third_party/ink_stroke_modeler/src/ink_stroke_modeler
		third_party/ink_stroke_modeler/src/ink_stroke_modeler/internal
		third_party/ink/src/ink/brush
		third_party/ink/src/ink/color
		third_party/ink/src/ink/geometry
		third_party/ink/src/ink/rendering
		third_party/ink/src/ink/rendering/skia/common_internal
		third_party/ink/src/ink/rendering/skia/native
		third_party/ink/src/ink/rendering/skia/native/internal
		third_party/ink/src/ink/strokes
		third_party/ink/src/ink/types
		third_party/inspector_protocol
		third_party/ipcz
		third_party/jinja2
		third_party/jsoncpp
		third_party/khronos
		third_party/lens_server_proto
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/fastfeat
		third_party/libaom/source/libaom/third_party/SVT-AV1
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libc++
		third_party/libdrm
		third_party/libgav1
		third_party/libjingle
		third_party/libpfm4
		third_party/libphonenumber
		third_party/libpng
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libtess2/libtess2
		third_party/libtess2/src/Include
		third_party/libtess2/src/Source
		third_party/liburlpattern
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/libzip
		third_party/lit
		third_party/llvm-libc
		third_party/llvm-libc/src/shared/
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/metrics_proto
		third_party/minigbm
		third_party/ml_dtypes
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/oak/chromium/proto
		third_party/oak/chromium/proto/attestation
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/opus
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg
		third_party/pdfium/third_party/libtiff
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/perfetto/protos/third_party/pprof
		third_party/perfetto/protos/third_party/simpleperf
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private_membership
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/protobuf/third_party/utf8_range
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/rapidhash
		third_party/re2
		third_party/readability
		third_party/rnnoise
		third_party/rust
		third_party/ruy
		third_party/s2cellid
		third_party/search_engines_data
		third_party/securemessage
		third_party/selenium-atoms
		third_party/sentencepiece
		third_party/sentencepiece/src/third_party/darts_clone
		third_party/shell-encryption
		third_party/simdutf
		third_party/simplejson
		third_party/six
		third_party/skia
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/snappy
		third_party/spirv-headers
		third_party/spirv-tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv
		third_party/swiftshader/third_party/SPIRV-Tools
		third_party/swiftshader/third_party/subzero
		third_party/tensorflow_models
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/platform
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
		third_party/utf
		third_party/vulkan
		third_party/wayland
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/x11proto
		third_party/xcbproto
		third_party/xnnpack
		third_party/zlib/google
		third_party/zxcvbn-cpp
		url/third_party/mozilla
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/rapidhash-v8
		v8/third_party/siphash
		v8/third_party/utf8-decoder
		v8/third_party/v8
		v8/third_party/valgrind

		# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
	)

	if use rar; then
		keeplibs+=( third_party/unrar )
	fi

	if use test; then
		# tar tvf /var/cache/distfiles/${P}-testdata.tar.xz | grep '^d' | grep 'third_party' | awk '{print $NF}'
		keeplibs+=(
			third_party/breakpad/breakpad/src/processor
			third_party/fuzztest
			third_party/google_benchmark/src/include/benchmark
			third_party/google_benchmark/src/src
			third_party/test_fonts
			third_party/test_fonts/fontconfig
		)
	fi

	# USE=system-*
	if ! use system-harfbuzz; then
		keeplibs+=( third_party/harfbuzz-ng )
	fi

	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi

	if ! use system-zstd; then
		keeplibs+=( third_party/zstd )
	fi

	# Arch-specific
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		# requires git and clang, bug #832803
		# Revert https://chromium.googlesource.com/chromium/src/+/b463d0f40b08b4e896e7f458d89ae58ce2a27165%5E%21/third_party/libvpx/generate_gni.sh
		# and https://chromium.googlesource.com/chromium/src/+/71ebcbce867dd31da5f8b405a28fcb0de0657d91%5E%21/third_party/libvpx/generate_gni.sh
		# since we're not in a git repo
		sed -i -e "s|^update_readme||g; s|clang-format|${EPREFIX}/bin/true|g; /^git -C/d; /git cl/d; /cd \$BASE_DIR\/\$LIBVPX_SRC_DIR/ign format --in-place \$BASE_DIR\/BUILD.gn\ngn format --in-place \$BASE_DIR\/libvpx_srcs.gni" \
			generate_gni.sh || die
		./generate_gni.sh || die
		popd >/dev/null || die

		pushd third_party/ffmpeg >/dev/null || die
		cp libavcodec/ppc/h264dsp.c libavcodec/ppc/h264dsp_ppc.c || die
		cp libavcodec/ppc/h264qpel.c libavcodec/ppc/h264qpel_ppc.c || die
		popd >/dev/null || die
	fi

	# Sanity check keeplibs, on major version bumps it is often necessary to update this list
	# and this enables us to hit them all at once.
	# There are some entries that need to be whitelisted (TODO: Why? The file is understandable, the rest seem odd)
	whitelist_libs=(
		net/third_party/quic
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/libjingle
		third_party/mesa
		third_party/skia/third_party/vulkan
		third_party/vulkan
	)
	local not_found_libs=()
	for lib in "${keeplibs[@]}"; do
		if [[ ! -d "${lib}" ]] && ! has "${lib}" "${whitelist_libs[@]}"; then
			not_found_libs+=( "${lib}" )
		fi
	done

	if [[ ${#not_found_libs[@]} -gt 0 ]]; then
		eerror "The following \`keeplibs\` directories were not found in the source tree:"
		for lib in "${not_found_libs[@]}"; do
			eerror "  ${lib}"
		done
		die "Please update the ebuild."
	fi

	# Remove most bundled libraries. Some are still needed.
	einfo "Unbundling third-party libraries ..."
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die

	# Interferes with our bundled clang path; we don't want stripped binaries anyway.
	sed -i -e 's|${clang_base_path}/bin/llvm-strip|/bin/true|g' \
		-e 's|${clang_base_path}/bin/llvm-objcopy|/bin/true|g' \
		build/linux/strip_binary.gni || die
}

chromium_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libjpeg
		libwebp
		libxml
		libxslt
		openh264
		zlib
	)
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi

	if use system-zstd; then
		gn_system_libraries+=( zstd )
	fi

	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" ||
		die "Failed to replace GN files for system libraries"

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' ${freetype_gni} || die
	echo "  enable_freetype = true" >> ${freetype_gni} || die
	echo "}" >> ${freetype_gni} || die

	if use !custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags
		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		filter-flags "-g*"
	fi

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler; then # can you cross-compile with the bundled toolchain?
			export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
			export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	# Start building our GN options
	local myconf_gn=() # Tip: strings must be quoted, bools or numbers are fine

	if use !bundled-toolchain; then
		# We already forced the "correct" clang via pkg_setup

		if tc-is-cross-compiler; then
			CC="${CC} -target ${CHOST} --sysroot ${ESYSROOT}"
			CXX="${CXX} -target ${CHOST} --sysroot ${ESYSROOT}"
			BUILD_AR=${AR}
			BUILD_CC=${CC}
			BUILD_CXX=${CXX}
			BUILD_NM=${NM}
		fi

		# Make sure the build system will use the right tools, bug #340795.
		tc-export AR CC CXX NM

		strip-unsupported-flags
		append-ldflags -Wl,--undefined-version # https://bugs.gentoo.org/918897#c32

		myconf_gn+=(
			"is_clang=true"
			"clang_use_chrome_plugins=false"
			"use_clang_modules=false" # M141 enables this for the linux platform by default.
			"use_lld=true"
			'custom_toolchain="//build/toolchain/linux/unbundle:default"'
			# From M127 we need to provide a location for libclang.
			# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
			# rust_bindgen_root = directory with `bin/bindgen` beneath it.
			# We don't need to set 'clang_base_path' for anything in our build
			# and it defaults to the google toolchain location. Instead provide a location
			# to where system clang lives so that bindgen can find system headers (e.g. stddef.h)
			"bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""
			"clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""
			"rust_bindgen_root=\"${EPREFIX}/usr/\""
			"rust_sysroot_absolute=\"$(get_rust_prefix)\""
			"rustc_version=\"${RUST_SLOT}\""
		)

		if ! tc-is-cross-compiler; then
			myconf_gn+=( 'host_toolchain="//build/toolchain/linux/unbundle:default"' )
		else
			tc-export BUILD_{AR,CC,CXX,NM}
			myconf_gn+=(
				'host_toolchain="//build/toolchain/linux/unbundle:host"'
				'v8_snapshot_toolchain="//build/toolchain/linux/unbundle:host"'
				"host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""
				"pkg_config=\"$(tc-getPKG_CONFIG)\""
			)

			# setup cups-config, build system only uses --libs option
			if use cups; then
				mkdir "${T}/cups-config" || die
				cp "${ESYSROOT}/usr/bin/${CHOST}-cups-config" "${T}/cups-config/cups-config" || die
				export PATH="${PATH}:${T}/cups-config"
			fi

			# Don't inherit PKG_CONFIG_PATH from environment
			local -x PKG_CONFIG_PATH=
		fi

	fi # !bundled-toolchain

	local myarch
	myarch="$(tc-arch)"
	case ${myarch} in
		amd64)
			# Bug 530248, 544702, 546984, 853646.
			use !custom-cflags && filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 \
										-mno-avx -mno-avx2 -mno-fma -mno-fma4 -mno-xop -mno-sse4a
			myconf_gn+=( 'target_cpu="x64"' )
			;;
		arm64)
			myconf_gn+=( 'target_cpu="arm64"' )
			;;
		ppc64)
			myconf_gn+=( 'target_cpu="ppc64"' )
			;;
		*)
			die "Failed to determine target arch, got '${myarch}'."
			;;
	esac

	# Common options

	myconf_gn+=(
		# Disable code formating of generated files
		"blink_enable_generated_code_formatting=false"
		# enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
		# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
		"dcheck_always_on=$(usex debug true false)"
		"dcheck_is_configurable=$(usex debug true false)"
		# Chromium builds provided by Linux distros should disable the testing config
		"disable_fieldtrial_testing_config=true"
		# 131 began laying the groundwork for replacing freetype with
		# "Rust-based Fontations set of libraries plus Skia path rendering"
		# We now need to opt-in
		"enable_freetype=true"
		"enable_hangout_services_extension=$(usex hangouts true false)"
		# Don't need nocompile checks and GN crashes with our config (verify with modern GN)
		"enable_nocompile_tests=false"
		# pseudolocales are only used for testing
		"enable_pseudolocales=false"
		"enable_widevine=$(usex widevine true false)"
		# Disable fatal linker warnings, bug 506268.
		"fatal_linker_warnings=false"
		# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys
		# Note: these are for Gentoo use ONLY. For your own distribution,
		# please get your own set of keys. Feel free to contact chromium@gentoo.org for more info.
		# note: OAuth2 is patched in; check patchset for details.
		'google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"'
		# Component build isn't generally intended for use by end users. It's mostly useful
		# for development and debugging.
		"is_component_build=false"
		# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
		"is_debug=false"
		"is_official_build=$(usex official true false)"
		# Enable ozone wayland and/or headless support
		"ozone_auto_platforms=false"
		"ozone_platform_headless=true"
		# Enables building without non-free unRAR licence
		"safe_browsing_use_unrar=$(usex rar true false)"
		"thin_lto_enable_optimizations=${use_lto}"
		"treat_warnings_as_errors=false"
		# Use in-tree libc++ (buildtools/third_party/libc++ and buildtools/third_party/libc++abi)
		# instead of the system C++ library for C++ standard library support.
		# default: true, but let's be explicit (forced since 120 ; USE removed 127).
		"use_custom_libcxx=true"
		# Enable ozone wayland and/or headless support
		"use_ozone=true"
		# The sysroot is the oldest debian image that chromium supports, we don't need it
		"use_sysroot=false"
		# See dependency logic in third_party/BUILD.gn
		"use_system_harfbuzz=$(usex system-harfbuzz true false)"
		"use_thin_lto=${use_lto}"
		# Only enabled for clang, but gcc has endian macros too
		"v8_use_libm_trig_functions=true"
	)

	if use bindist ; then
		myconf_gn+=(
			# If this is set to false Chromium won't be able to load any proprietary codecs
			# even if provided with an ffmpeg capable of h264/aac decoding
			"proprietary_codecs=true"
			'ffmpeg_branding="Chrome"'
			# build ffmpeg as an external component (libffmpeg.so) that we can remove / substitute
			"is_component_ffmpeg=true"
		)
	else
		myconf_gn+=(
			"proprietary_codecs=$(usex proprietary-codecs true false)"
			"ffmpeg_branding=\"$(usex proprietary-codecs Chrome Chromium)\""
		)
	fi

	if use headless; then
		myconf_gn+=(
			"enable_print_preview=false"
			"enable_remoting=false"
			'ozone_platform="headless"'
			"rtc_use_pipewire=false"
			"use_alsa=false"
			"use_cups=false"
			"use_gio=false"
			"use_glib=false"
			"use_gtk=false"
			"use_kerberos=false"
			"use_libpci=false"
			"use_pangocairo=false"
			"use_pulseaudio=false"
			"use_qt5=false"
			"use_qt6=false"
			"use_udev=false"
			"use_vaapi=false"
			"use_xkbcommon=false"
		)
	else
		myconf_gn+=(
			"gtk_version=$(usex gtk4 4 3)"
			# link pulseaudio directly (DT_NEEDED) instead of using dlopen.
			# helps with automated detection of ABI mismatches and prevents silent errors.
			"link_pulseaudio=$(usex pulseaudio true false)"
			"ozone_platform_wayland=$(usex wayland true false)"
			"ozone_platform_x11=$(usex X true false)"
			"ozone_platform=\"$(usex wayland wayland x11)\""
			"rtc_use_pipewire=$(usex screencast true false)"
			"use_cups=$(usex cups true false)"
			"use_kerberos=$(usex kerberos true false)"
			"use_pulseaudio=$(usex pulseaudio true false)"
			"use_qt5=false"
			"use_system_libffi=$(usex wayland true false)"
			"use_system_minigbm=true"
			"use_vaapi=$(usex vaapi true false)"
			"use_xkbcommon=true"
		)
		if use qt6; then
			local cbuild_libdir
			cbuild_libdir="$(get_libdir)"
			if tc-is-cross-compiler; then
			# Hack to workaround get_libdir not being able to handle CBUILD, bug #794181
				cbuild_libdir="$($(tc-getBUILD_PKG_CONFIG) --keep-system-libs --libs-only-L libxslt)"
				cbuild_libdir="${cbuild_libdir:2}"
				cbuild_libdir="${cbuild_libdir/% }"
			fi
			myconf_gn+=(
				"use_qt6=true"
				"moc_qt6_path=\"${EPREFIX}/usr/${cbuild_libdir}/qt6/libexec\""
			)
		else
			myconf_gn+=( "use_qt6=false" )
		fi
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=( "icu_use_data_file=false" )
	fi

	if use official; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
		if use !ppc64; then
			myconf_gn+=( "is_cfi=${use_lto}" )
		else
			myconf_gn+=( "is_cfi=false" ) # requires llvm-runtimes/compiler-rt-sanitizers[cfi]
		fi
		# Don't add symbols to build
		myconf_gn+=( "symbol_level=0" )
	fi

	if use pgo; then
		myconf_gn+=( "chrome_pgo_phase=${1}" )
		if [[ "$1" == "2" ]]; then
			myconf_gn+=( "pgo_data_path=${2}" )
		fi
	else
		myconf_gn+=( "chrome_pgo_phase=0" )
	fi

	# Odds and ends

	# skipping typecheck is only supported on amd64, bug #876157
	if ! use amd64; then
		myconf_gn+=( "devtools_skip_typecheck=false" )
	fi

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler && use ppc64; then
		myconf_gn+=( "v8_enable_external_code_space=false" )
	fi

	einfo "Configuring Chromium ..."
	set -- gn gen --args="${myconf_gn[*]}${EXTRA_GN:+ ${EXTRA_GN}}" out/Release
	echo "$@"
	"$@" || die "Failed to configure Chromium"
}

src_configure() {
	chromium_configure $(usex pgo 1 0)
}

chromium_compile() {

	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Don't inherit PYTHONPATH from environment, bug #789021, #812689
	local -x PYTHONPATH=

	# Build mksnapshot and pax-mark it.
	if use pax-kernel; then
		local x
		for x in mksnapshot v8_context_snapshot_generator code_cache_generator; do
			if tc-is-cross-compiler; then
				eninja -C out/Release "host/${x}"
				pax-mark m "out/Release/host/${x}"
			else
				eninja -C out/Release "${x}"
				pax-mark m "out/Release/${x}"
			fi
		done
	fi

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release chrome chromedriver chrome_sandbox $(use test && echo "base_unittests")

	pax-mark m out/Release/chrome

	# This codepath does minimal patching, so we're at the mercy of upstream
	# CFLAGS. This is fine - we're not intending to force this on users
	# and we do a lot of flag 'management' anyway.
	if use bundled-toolchain; then
		QA_FLAGS_IGNORED="
			usr/lib64/chromium-browser/chrome
			usr/lib64/chromium-browser/chrome-sandbox
			usr/lib64/chromium-browser/chromedriver
			usr/lib64/chromium-browser/chrome_crashpad_handler
			usr/lib64/chromium-browser/libEGL.so
			usr/lib64/chromium-browser/libGLESv2.so
			usr/lib64/chromium-browser/libVkICD_mock_icd.so
			usr/lib64/chromium-browser/libVkLayer_khronos_validation.so
			usr/lib64/chromium-browser/libqt6_shim.so
			usr/lib64/chromium-browser/libvk_swiftshader.so
			usr/lib64/chromium-browser/libvulkan.so.1
		"
	fi
}

# This function is called from virtx, and must always return so that Xvfb
# session isn't left running. If we return 1, virtx will call die().
chromium_profile() {
	einfo "Profiling for PGO"

	pushd "${WORKDIR}/chromium-profiler-"* >/dev/null || return 1

	# Remove old profdata in case profiling was interrupted.
	rm -rf "${1}" || return 1

	if ! "${EPYTHON}" ./chromium_profiler.py \
		--chrome-executable "${S}/out/Release/chrome" \
		--chromedriver-executable "${S}/out/Release/chromedriver.unstripped" \
		--add-arg no-sandbox --add-arg disable-dev-shm-usage \
		--profile-output "${1}"; then
		eerror "Profiling failed"
		return 1
	fi

	popd >/dev/null || return 1
}

src_compile() {
	if use pgo; then
		local profdata

		profdata="${WORKDIR}/chromium.profdata"

		if [[ ! -e "${WORKDIR}/.pgo-profiled" ]]; then
			chromium_compile
			virtx chromium_profile "$profdata"

			touch "${WORKDIR}/.pgo-profiled" || die
		fi

		if [[ ! -e "${WORKDIR}/.pgo-phase-2-configured" ]]; then
			# Remove phase 1 output
			rm -r out/Release || die

			chromium_configure 2 "$profdata"

			touch "${WORKDIR}/.pgo-phase-2-configured" || die
		fi

		if [[ ! -e "${WORKDIR}/.pgo-phase-2-compiled" ]]; then
			chromium_compile
			touch "${WORKDIR}/.pgo-phase-2-compiled" || die
		fi
	else
		chromium_compile
	fi

	mv out/Release/chromedriver{.unstripped,} || die

	rm -f out/Release/locales/*.pak.info || die

	# Generate support files: #684550 #706786 #968958
	# Use upstream's python installer script to generate support files
	# This replaces fragile sed commands and handles @@include@@ directives.
	# It'll also verify that all substitution markers have been resolved, meaning that
	# future changes to templates that add new variables will be caught during the build.
	cat > "${T}/generate_support_files.py" <<-EOF || die
		import sys
		from pathlib import Path

		# Add upstream installer script to search path
		sys.path.insert(0, str(Path.cwd() / "chrome/installer/linux/common"))
		import installer

		# Configure contexts strictly for file generation
		# Common variables used across templates
		context = {
		    "BUGTRACKERURL": "https://bugs.gentoo.org/enter_bug.cgi?product=Gentoo Linux&component=Current packages",
		    "DEVELOPER_NAME": "The Chromium Authors",
		    "EXTRA_DESKTOP_ENTRIES": "",
		    "FULLDESC": "An open-source browser project that aims to build a safer, faster, and more stable way to experience the web.",
		    "HELPURL": "https://wiki.gentoo.org/wiki/Chromium",
		    "INSTALLDIR": "/usr/$(get_libdir)/chromium-browser",
		    "MAINTMAIL": "Gentoo Chromium Project <chromium@gentoo.org>",
		    "MENUNAME": "Chromium",
		    "PACKAGE": "chromium-browser",
		    "PRODUCTURL": "https://www.chromium.org/",
		    "PROGNAME": "chrome",
		    "PROJECT_LICENSE": "BSD, LGPL-2, LGPL-2.1, MPL-1.1, MPL-2.0, Apache-2.0, and others",
		    "SHORTDESC": "Open-source foundation of many web browsers including Google Chrome",
		    "URI_SCHEME": "x-scheme-handler/chromium",
		    "USR_BIN_SYMLINK_NAME": "chromium-browser",
		}

		# Generate Desktop file
		installer.process_template(
		    Path("chrome/installer/linux/common/desktop.template"),
		    Path("out/Release/chromium-browser-chromium.desktop"),
		    context
		)

		# Generate Manpage
		installer.process_template(
		    Path("chrome/app/resources/manpage.1.in"),
		    Path("out/Release/chromium-browser.1"),
		    context
		)

		# Generate AppData (AppStream)
		installer.process_template(
		    Path("chrome/installer/linux/common/appdata.xml.template"),
		    Path("out/Release/chromium-browser.appdata.xml"),
		    context
		)

		# Generate GNOME Default Apps entry
		installer.process_template(
		    Path("chrome/installer/linux/common/default-app.template"),
		    Path("out/Release/chromium-browser.xml"),
		    context
		)
	EOF

	"${EPYTHON}" "${T}/generate_support_files.py" || die "Failed to generate support files"

	# Build vk_swiftshader_icd.json; bug #827861
	sed -e 's|${ICD_LIBRARY_PATH}|./libvk_swiftshader.so|g' \
		third_party/swiftshader/src/Vulkan/vk_swiftshader_icd.json.tmpl > \
		out/Release/vk_swiftshader_icd.json || die
}

src_test() {
	# Initial list of tests to skip pulled from Alpine. Thanks Lauren!
	# https://issues.chromium.org/issues/40939315
	local skip_tests=(
		'MessagePumpLibeventTest.NestedNotification*'
		ClampTest.Death
		OptionalTest.DereferencingNoValueCrashes
		PlatformThreadTest.SetCurrentThreadTypeTest
		RawPtrTest.TrivialRelocability
		SafeNumerics.IntMaxOperations
		StackTraceTest.TraceStackFramePointersFromBuffer
		StringPieceTest.InvalidLengthDeath
		StringPieceTest.OutOfBoundsDeath
		ThreadPoolEnvironmentConfig.CanUseBackgroundPriorityForWorker
		ValuesUtilTest.FilePath
		# Gentoo-specific
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedAllocReturnNullDirect/3
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/0
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/1
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/2
		AlternateTestParams/PartitionAllocDeathTest.RepeatedReallocReturnNullDirect/3
		CharacterEncodingTest.GetCanonicalEncodingNameByAliasName
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGFPE
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGILL
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGV
		CheckExitCodeAfterSignalHandlerDeathTest.CheckSIGSEGVNonCanonicalAddress
		FilePathTest.FromUTF8Unsafe_And_AsUTF8Unsafe
		FileTest.GetInfoForCreationTime
		ICUStringConversionsTest.ConvertToUtf8AndNormalize
		NumberFormattingTest.FormatPercent
		PathServiceTest.CheckedGetFailure
		PlatformThreadTest.CanChangeThreadType
		RustLogIntegrationTest.CheckAllSeverity
		StackCanary.ChangingStackCanaryCrashesOnReturn
		StackTraceDeathTest.StackDumpSignalHandlerIsMallocFree
		SysStrings.SysNativeMBAndWide
		SysStrings.SysNativeMBToWide
		SysStrings.SysWideToNativeMB
		TestLauncherTools.TruncateSnippetFocusedMatchesFatalMessagesTest
		ToolsSanityTest.BadVirtualCallNull
		ToolsSanityTest.BadVirtualCallWrongType
		CancelableEventTest.BothCancelFailureAndSucceedOccurUnderContention #new m133: TODO investigate
		DriveInfoTest.GetFileDriveInfo # new m137: TODO investigate
		# Broken since M139 dev
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/RendererProcessIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/UtilityProcessIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/BrowserProcessIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/MainThreadIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/IOThreadIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/CompositorThreadIsCritical
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/ThreadPoolIsNotCritical
		# M140
		CriticalProcessAndThreadSpotChecks/HangWatcherAnyCriticalThreadTests.AnyCriticalThreadHung/GpuProcessIsCritical
		# M142 - needs investigation if they persist into beta
		AlternateTestParams/PartitionAllocTest.Realloc/2
		AlternateTestParams/PartitionAllocTest.Realloc/3
		AlternateTestParams/PartitionAllocTest.ReallocDirectMapAligned/2
		AlternateTestParams/PartitionAllocTest.ReallocDirectMapAligned/3
		# M142 - new beta failures
		'LazyThreadPoolTaskRunnerEnvironmentTest.*'
	)
	local test_filter="-$(IFS=:; printf '%s' "${skip_tests[*]}")"
	# test-launcher-bot-mode enables parallelism and plain output
	./out/Release/base_unittests --test-launcher-bot-mode \
		--test-launcher-jobs="$(makeopts_jobs)" \
		--gtest_filter="${test_filter}" || die "Tests failed!"
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	newexe out/Release/chrome_sandbox chrome-sandbox
	fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"

	doexe out/Release/chromedriver
	doexe out/Release/chrome_crashpad_handler

	ozone_auto_session () {
		use X && use wayland && ! use headless && echo true || echo false
	}
	local sedargs=( -e
			"s:/usr/lib/:/usr/$(get_libdir)/:g;
			s:@@OZONE_AUTO_SESSION@@:$(ozone_auto_session):g"
	)
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r7.sh" > chromium-launcher.sh || die
	doexe chromium-launcher.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver" /usr/bin/chromedriver

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default"

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak

	if use bindist; then
		# We built libffmpeg as a component library, but we can't distribute it
		# with proprietary codec support. Remove it and make a symlink to the requested
		# system library.
		rm -f out/Release/libffmpeg.so \
			|| die "Failed to remove bundled libffmpeg.so (with proprietary codecs)"
		# symlink the libffmpeg.so from either ffmpeg-chromium or ffmpeg[chromium].
		einfo "Creating symlink to libffmpeg.so from $(usex ffmpeg-chromium ffmpeg-chromium ffmpeg[chromium])..."
		dosym ../chromium/libffmpeg.so$(usex ffmpeg-chromium .${PV%%\.*} "") \
			/usr/$(get_libdir)/chromium-browser/libffmpeg.so
	fi

	(
		shopt -s nullglob
		local files=(out/Release/*.so out/Release/*.so.[0-9])
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

	# Install bundled xdg-utils, avoids installing X11 libraries with USE="-X wayland"
	doins out/Release/xdg-{settings,mime}

	if ! use system-icu && ! use headless; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/MEIPreload

	# Install vk_swiftshader_icd.json; bug #827861
	doins out/Release/vk_swiftshader_icd.json

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	# Install desktop entry
	domenu out/Release/chromium-browser-chromium.desktop

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	doins out/Release/chromium-browser.xml

	# Install AppStream metadata
	insinto /usr/share/appdata
	doins out/Release/chromium-browser.appdata.xml

	# Install manpage; bug #684550
	doman out/Release/chromium-browser.1
	dosym chromium-browser.1 /usr/share/man/man1/chromium.1

	readme.gentoo_create_doc
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	if ! use headless; then
		if use vaapi; then
			elog "Hardware-accelerated video decoding configuration:"
			elog
			elog "Chromium supports multiple backends for hardware acceleration. To enable one,"
			elog "   Add to CHROMIUM_FLAGS in /etc/chromium/default:"
			elog
			elog "1. VA-API with OpenGL (recommended for most users):"
			elog "   --enable-features=AcceleratedVideoDecodeLinuxGL"
			elog "   VaapiVideoDecoder may need to be added as well, but try without first."
			elog
			if use wayland; then
				elog "2. Enhanced Wayland/EGL performance:"
				elog "   --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
				elog
			fi
			if use X; then
				elog "$(usex wayland "3" "2"). VA-API with Vulkan:"
				elog "   --enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
				elog
				if use wayland; then
					elog "   NOTE: Vulkan acceleration requires X11 and will not work under Wayland sessions."
					elog "   Use OpenGL-based acceleration instead when running under Wayland."
					elog
				fi
			fi
			elog "Additional options:"
			elog "  To enable hardware-accelerated encoding (if supported)"
			elog "  add 'AcceleratedVideoEncoder' to your feature list"
			elog "  VaapiIgnoreDriverChecks bypasses driver compatibility checks"
			elog "  (may be needed for newer/unsupported hardware)"
			elog
		else
			elog "This Chromium build was compiled without VA-API support, which provides"
			elog "hardware-accelerated video decoding."
		fi
		if use screencast; then
			elog "Screencast is disabled by default at runtime. Either enable it"
			elog "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
			elog "inside Chromium or add --enable-features=WebRTCPipeWireCapturer"
			elog "to CHROMIUM_FLAGS in /etc/chromium/default."
		fi
		if use gtk4; then
			elog "Chromium prefers GTK3 over GTK4 at runtime. To override this"
			elog "behavior you need to pass --gtk-version=4, e.g. by adding it"
			elog "to CHROMIUM_FLAGS in /etc/chromium/default."
		fi
	fi

	if systemd_is_booted && ! [[ -f "/etc/machine-id" ]]; then
		ewarn "The lack of an '/etc/machine-id' file on this system booted with systemd"
		ewarn "indicates that the Gentoo handbook was not followed to completion."
		ewarn ""
		ewarn "Chromium is known to behave unpredictably with this system configuration;"
		ewarn "please complete the configuration of this system before logging any bugs."
	fi
}
