# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# Patch version
FIREFOX_PATCHSET="firefox-115esr-patches-13.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-115-patches-02.tar.xz"

LLVM_COMPAT=( 18 )

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="ncurses,ssl,xml(+)"

RUST_NEEDS_LLVM="1"

WANT_AUTOCONF="2.1"

inherit autotools check-reqs flag-o-matic llvm-r1 multiprocessing prefix python-any-r1 rust toolchain-funcs

MY_PN="mozjs"
MY_PV="${PV/_pre*}" # Handle Gentoo pre-releases

MY_MAJOR=$(ver_cut 1)

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
fi

MOZ_PN="firefox"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}"

DESCRIPTION="SpiderMonkey is Mozilla's JavaScript engine written in C and C++"
HOMEPAGE="https://spidermonkey.dev https://firefox-source-docs.mozilla.org/js/index.html "

KEYWORDS="amd64 ~arm ~arm64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"

SLOT="$(ver_cut 1)"
LICENSE="MPL-2.0"
IUSE="clang cpu_flags_arm_neon debug +jit lto test"

#RESTRICT="test"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	$(llvm_gen_dep '
		llvm-core/llvm:${LLVM_SLOT}
		clang? (
			llvm-core/clang:${LLVM_SLOT}
			llvm-core/lld:${LLVM_SLOT}
		)
	')
	test? (
		$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
	)"
DEPEND=">=dev-libs/icu-73.1:=
	dev-libs/nspr
	sys-libs/readline:0=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/firefox-${MY_PV}/js/src"

llvm_check_deps() {
	if ! has_version -b "llvm-core/llvm:${LLVM_SLOT}" ; then
		einfo "llvm-core/llvm:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang ; then
		if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
			einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! tc-ld-is-mold ; then
			if ! has_version -b "llvm-core/lld:${LLVM_SLOT}" ; then
				einfo "llvm-core/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

python_check_deps() {
	if use test ; then
		python_has_version "dev-python/six[${PYTHON_USEDEP}]"
	fi
}

# This is a straight copypaste from toolchain-funcs.eclass's 'tc-ld-is-lld', and is temporarily
# placed here until toolchain-funcs.eclass gets an official support for mold linker.
# Please see:
# https://github.com/gentoo/gentoo/pull/28366 ||
# https://github.com/gentoo/gentoo/pull/28355
tc-ld-is-mold() {
	local out

	# Ensure ld output is in English.
	local -x LC_ALL=C

	# First check the linker directly.
	out=$($(tc-getLD "$@") --version 2>&1)
	if [[ ${out} == *"mold"* ]] ; then
		return 0
	fi

	# Then see if they're selecting mold via compiler flags.
	# Note: We're assuming they're using LDFLAGS to hold the
	# options and not CFLAGS/CXXFLAGS.
	local base="${T}/test-tc-linker"
	cat <<-EOF > "${base}.c"
	int main() { return 0; }
	EOF
	out=$($(tc-getCC "$@") ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -Wl,--version "${base}.c" -o "${base}" 2>&1)
	rm -f "${base}"*
	if [[ ${out} == *"mold"* ]] ; then
		return 0
	fi

	# No mold here!
	return 1
}

pkg_pretend() {
	if use test ; then
		CHECKREQS_DISK_BUILD="4000M"
	else
		CHECKREQS_DISK_BUILD="3600M"
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use test ; then
			CHECKREQS_DISK_BUILD="4000M"
		else
			CHECKREQS_DISK_BUILD="3600M"
		fi

		check-reqs_pkg_setup

		llvm-r1_pkg_setup
		rust_pkg_setup

		if use clang && use lto && tc-ld-is-lld ; then
			local version_lld=$(ld.lld --version 2>/dev/null | awk '{ print $2 }')
			[[ -n ${version_lld} ]] && version_lld=$(ver_cut 1 "${version_lld}")
			[[ -z ${version_lld} ]] && die "Failed to read ld.lld version!"

			local version_llvm_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'LLVM version:' | awk '{ print $3 }')
			[[ -n ${version_llvm_rust} ]] && version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
			[[ -z ${version_llvm_rust} ]] && die "Failed to read used LLVM version from rustc!"

			if ver_test "${version_lld}" -ne "${version_llvm_rust}" ; then
				eerror "Rust is using LLVM version ${version_llvm_rust} but ld.lld version belongs to LLVM version ${version_lld}."
				eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the following options:"
				eerror "  - Manually switch rust version using 'eselect rust' to match used LLVM version"
				eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee matching version"
				eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
				eerror "  - Rebuild lld with llvm that was used to build rust (may need to rebuild the whole "
				eerror "    llvm/clang/lld/rust chain depending on your @world updates)"
				die "LLVM version used by Rust (${version_llvm_rust}) does not match with ld.lld version (${version_lld})!"
			fi
		fi

		python-any-r1_pkg_setup

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
			ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi
}

src_prepare() {
	pushd ../.. &>/dev/null || die

	use lto && rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch

	if ! use ppc64; then
		rm -v "${WORKDIR}"/firefox-patches/*ppc64*.patch || die
	fi

	# Workaround for bgo #915651,915651,929013 on musl
	if use elibc_glibc ; then
		rm -v "${WORKDIR}"/firefox-patches/*bgo-748849-RUST_TARGET_override.patch || die
	fi

	eapply "${WORKDIR}"/firefox-patches
	eapply "${WORKDIR}"/spidermonkey-patches

	default

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo #915651,915651,929013 on musl
	if ! use elibc_glibc ; then
		if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="i686-unknown-linux-musl"
		else
			die "Unknown musl chost, please post your rustc -vV along with emerge --info on Gentoo's bug #915651"
		fi
	fi

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		python/mozbuild/mozbuild/configure/check_debug_ranges.py \
		|| die "sed failed to set toolchain prefix"

	# use prefix shell in wrapper linker scripts, bug #789660
	hprefixify "${S}"/../../build/cargo-{,host-}linker

	einfo "Removing pre-built binaries ..."
	find third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	MOZJS_BUILDDIR="${WORKDIR}/build"
	mkdir "${MOZJS_BUILDDIR}" || die

	popd &>/dev/null || die
}

src_configure() {
	# Show flags set at the beginning
	einfo "Current CFLAGS:    ${CFLAGS}"
	einfo "Current CXXFLAGS:  ${CXXFLAGS}"
	einfo "Current LDFLAGS:   ${LDFLAGS}"
	einfo "Current RUSTFLAGS: ${RUSTFLAGS}"

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
	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB PKG_CONFIG

	cd "${MOZJS_BUILDDIR}" || die

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	local -a myeconfargs=(
		--host="${CBUILD:-${CHOST}}"
		--target="${CHOST}"

		--disable-ctype
		--disable-jemalloc
		--disable-smoosh
		--disable-strip

		--enable-project=js
		--enable-readline
		--enable-release
		--enable-shared-js

		--with-intl-api
		--with-system-icu
		--with-system-nspr
		--with-system-zlib
		--with-toolchain-prefix="${CHOST}-"

		$(use_enable debug)
		$(use_enable jit)
		$(use_enable test tests)
	)

	if use debug; then
		myeconfargs+=( --disable-optimize )
		myeconfargs+=( --enable-debug-symbols )
		myeconfargs+=( --enable-real-time-tracing )
	else
		myeconfargs+=( --enable-optimize )
		myeconfargs+=( --disable-debug-symbols )
		myeconfargs+=( --disable-real-time-tracing )
	fi

	# We always end up disabling this at some point due to newer rust versions. bgo#933372
	myeconfargs+=( --disable-rust-simd )

	# Modifications to better support ARM, bug 717344
	if use cpu_flags_arm_neon ; then
		myeconfargs+=( --with-fpu=neon )

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			myeconfargs+=( --with-thumb=yes )
			myeconfargs+=( --with-thumb-interwork=no )
		fi
	fi

	# Tell build system that we want to use LTO
	if use lto ; then
		if use clang ; then
			if tc-ld-is-mold ; then
				myeconfargs+=( --enable-linker=mold )
			else
				myeconfargs+=( --enable-linker=lld )
			fi
			myeconfargs+=( --enable-lto=cross )

		else
			myeconfargs+=( --enable-linker=bfd )
			myeconfargs+=( --enable-lto=full )
		fi
	fi

	# LTO flag was handled via configure
	filter-lto

	# Use system's Python environment
	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	# Show flags we will use
	einfo "Build CFLAGS:    ${CFLAGS}"
	einfo "Build CXXFLAGS:  ${CXXFLAGS}"
	einfo "Build LDFLAGS:   ${LDFLAGS}"
	einfo "Build RUSTFLAGS: ${RUSTFLAGS}"

	# Forcing system-icu allows us to skip patching bundled ICU for PPC
	# and other minor arches
	ECONF_SOURCE="${S}" \
		econf \
		${myeconfargs[@]} \
		XARGS="${EPREFIX}/usr/bin/xargs"
}

src_compile() {
	cd "${MOZJS_BUILDDIR}" || die
	default
}

src_test() {
	if "${MOZJS_BUILDDIR}/js/src/js" -e 'print("Hello world!")'; then
		einfo "Smoke-test successful, continuing with full test suite"
	else
		die "Smoke-test failed: did interpreter initialization fail?"
	fi

	cp "${FILESDIR}"/spidermonkey-${SLOT}-known-test-failures.txt "${T}"/known_failures.list || die

	if use sparc ; then
		echo "non262/Array/regress-157652.js" >> "${T}"/known_failures.list
		echo "non262/regress/regress-422348.js" >> "${T}"/known_failures.list
		echo "test262/built-ins/TypedArray/prototype/set/typedarray-arg-set-values-same-buffer-other-type.js" >> "${T}"/known_failures.list
	fi

	if use x86 ; then
		echo "non262/Date/timeclip.js" >> "${T}"/known_failures.list
		echo "test262/built-ins/Date/UTC/fp-evaluation-order.js" >> "${T}"/known_failures.list
		echo "test262/language/types/number/S8.5_A2.1.js" >> "${T}"/known_failures.list
		echo "test262/language/types/number/S8.5_A2.2.js" >> "${T}"/known_failures.list
	fi

	${EPYTHON} \
		"${S}"/tests/jstests.py -d -s -t 1800 --wpt=disabled --no-progress \
		--exclude-file="${T}"/known_failures.list \
		"${MOZJS_BUILDDIR}"/js/src/js \
		|| die

	if use jit ; then
		${EPYTHON} \
			"${S}"/tests/jstests.py -d -s -t 1800 --wpt=disabled --no-progress \
			--exclude-file="${T}"/known_failures.list \
			"${MOZJS_BUILDDIR}"/js/src/js basic \
			|| die
	fi
}

src_install() {
	cd "${MOZJS_BUILDDIR}" || die
	default

	# fix soname links
	pushd "${ED}"/usr/$(get_libdir) &>/dev/null || die
	mv lib${MY_PN}-${MY_MAJOR}.so lib${MY_PN}-${MY_MAJOR}.so.0.0.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0.0.0 lib${MY_PN}-${MY_MAJOR}.so.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0 lib${MY_PN}-${MY_MAJOR}.so || die
	popd &>/dev/null || die

	# remove unneeded files
	rm \
		"${ED}"/usr/bin/js${MY_MAJOR}-config \
		"${ED}"/usr/$(get_libdir)/libjs_static.ajs \
		|| die

	# fix permissions
	chmod -x \
		"${ED}"/usr/$(get_libdir)/pkgconfig/*.pc \
		"${ED}"/usr/include/mozjs-${MY_MAJOR}/js-config.h \
		|| die
}
