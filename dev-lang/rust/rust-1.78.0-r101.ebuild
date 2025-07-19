# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
PYTHON_COMPAT=( python3_{11..13} )

RUST_PATCH_VER=${PVR}

RUST_MAX_VER=${PV}
RUST_MIN_VER="$(ver_cut 1).$(($(ver_cut 2) - 1)).0"

inherit check-reqs estack flag-o-matic llvm-r1 multiprocessing multilib multilib-build \
	optfeature python-any-r1 rust rust-toolchain toolchain-funcs verify-sig

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/rust.git"
	EGIT_SUBMODULES=(
		"*"
		"-src/gcc"
	)
elif [[ ${PV} == *beta* ]]; then
	# Identify the snapshot date of the beta release:
	# curl -Ls static.rust-lang.org/dist/channel-rust-beta.toml | grep beta-src.tar.xz
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SRC_URI="https://static.rust-lang.org/dist/${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz
		https://gitweb.gentoo.org/proj/rust-patches.git/snapshot/rust-patches-${RUST_PATCH_VER}.tar.bz2
		verify-sig? ( https://static.rust-lang.org/dist/${BETA_SNAPSHOT}/rustc-beta-src.tar.xz.asc
			-> rustc-${PV}-src.tar.xz.asc )
	"
	S="${WORKDIR}/${MY_P}-src"
else
	MY_P="rustc-${PV}"
	SRC_URI="https://static.rust-lang.org/dist/${MY_P}-src.tar.xz
		https://gitweb.gentoo.org/proj/rust-patches.git/snapshot/rust-patches-${RUST_PATCH_VER}.tar.bz2
		verify-sig? ( https://static.rust-lang.org/dist/${MY_P}-src.tar.xz.asc )
	"
	S="${WORKDIR}/${MY_P}-src"
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
fi

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

# keep in sync with llvm ebuild of the same version as bundled one.
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARC ARM AVR BPF CSKY DirectX Hexagon Lanai
	LoongArch M68k Mips MSP430 NVPTX PowerPC RISCV Sparc SPIRV SystemZ VE
	WebAssembly X86 XCore Xtensa )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}

# https://github.com/rust-lang/llvm-project/blob/rustc-1.78.0/llvm/CMakeLists.txt
_ALL_RUST_EXPERIMENTAL_TARGETS=( ARC CSKY DirectX M68k SPIRV Xtensa )
declare -A ALL_RUST_EXPERIMENTAL_TARGETS
for _x in "${_ALL_RUST_EXPERIMENTAL_TARGETS[@]}"; do
	ALL_RUST_EXPERIMENTAL_TARGETS["llvm_targets_${_x}"]=0
done

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"
SLOT="${PV}"

IUSE="big-endian clippy cpu_flags_x86_sse2 debug dist doc llvm-libunwind lto miri nightly parallel-compiler rustfmt rust-analyzer rust-src system-llvm test wasm ${ALL_LLVM_TARGETS[*]}"

LLVM_DEPEND=()
# splitting usedeps needed to avoid CI/pkgcheck's UncheckableDep limitation
for _x in "${ALL_LLVM_TARGETS[@]}"; do
	LLVM_DEPEND+=( "	${_x}? ( $(llvm_gen_dep "llvm-core/llvm:\${LLVM_SLOT}[${_x}=]") )" )
	if [[ -v ALL_RUST_EXPERIMENTAL_TARGETS["${_x}"] ]] ; then
		ALL_RUST_EXPERIMENTAL_TARGETS["${_x}"]=1
	fi
done
LLVM_DEPEND+=( "	wasm? ( $(llvm_gen_dep 'llvm-core/lld:${LLVM_SLOT}') )" )
LLVM_DEPEND+=( "	$(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}')" )

BDEPEND="${PYTHON_DEPS}
	app-eselect/eselect-rust
	|| (
		>=sys-devel/gcc-4.7[cxx]
		>=llvm-core/clang-3.5
	)
	!system-llvm? (
		>=dev-build/cmake-3.13.4
		app-alternatives/ninja
	)
	test? ( dev-debug/gdb )
	verify-sig? ( sec-keys/openpgp-keys-rust )
"

DEPEND="
	>=app-arch/xz-utils-5.2
	net-misc/curl:=[http2,ssl]
	sys-libs/zlib:=
	dev-libs/openssl:0=
	system-llvm? (
		${LLVM_DEPEND[*]}
		llvm-libunwind? ( llvm-runtimes/libunwind:= )
	)
	!system-llvm? (
		!llvm-libunwind? (
			elibc_musl? ( sys-libs/libunwind:= )
		)
	)
"

RDEPEND="${DEPEND}
	app-eselect/eselect-rust
	dev-lang/rust-common
	sys-apps/lsb-release
	!dev-lang/rust:stable
	!dev-lang/rust-bin:stable
"

REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )
	miri? ( nightly )
	parallel-compiler? ( nightly )
	rust-analyzer? ( rust-src )
	test? ( ${ALL_LLVM_TARGETS[*]} )
	wasm? ( llvm_targets_WebAssembly )
	x86? ( cpu_flags_x86_sse2 )
"

# we don't use cmake.eclass, but can get a warning
CMAKE_WARN_UNUSED_CLI=no

QA_FLAGS_IGNORED="
	usr/lib/${PN}/${PV}/bin/.*
	usr/lib/${PN}/${PV}/libexec/.*
	usr/lib/${PN}/${PV}/lib/lib.*.so
	usr/lib/${PN}/${PV}/lib/rustlib/.*/bin/.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

QA_SONAME="
	usr/lib/${PN}/${PV}/lib/lib.*.so.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

QA_PRESTRIPPED="
	usr/lib/${PN}/${PV}/lib/rustlib/.*/bin/rust-llvm-dwp
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/self-contained/crtn.o
"

# An rmeta file is custom binary format that contains the metadata for the crate.
# rmeta files do not support linking, since they do not contain compiled object files.
# so we can safely silence the warning for this QA check.
QA_EXECSTACK="usr/lib/${PN}/${PV}/lib/rustlib/*/lib*.rlib:lib.rmeta"

# causes double bootstrap
RESTRICT="test"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/rust.asc

clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' "vendor/${1}/.cargo-checksum.json" || die
}

toml_usex() {
	usex "${1}" true false
}

pre_build_checks() {
	local M=9216
	# multiply requirements by 1.3 if we are doing x86-multilib
	if use amd64; then
		M=$(( $(usex abi_x86_32 13 10) * ${M} / 10 ))
	fi
	M=$(( $(usex clippy 128 0) + ${M} ))
	M=$(( $(usex miri 128 0) + ${M} ))
	M=$(( $(usex rustfmt 256 0) + ${M} ))
	# add 2G if we compile llvm and 256M per llvm_target
	if ! use system-llvm; then
		M=$(( 2048 + ${M} ))
		local ltarget
		for ltarget in ${ALL_LLVM_TARGETS[@]}; do
			M=$(( $(usex ${ltarget} 256 0) + ${M} ))
		done
	fi
	M=$(( $(usex wasm 256 0) + ${M} ))
	M=$(( $(usex debug 2 1) * ${M} ))
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		M=$(( 15 * ${M} / 10 ))
	fi
	eshopts_pop
	M=$(( $(usex doc 256 0) + ${M} ))
	CHECKREQS_DISK_BUILD=${M}M check-reqs_pkg_${EBUILD_PHASE}
}

llvm_check_deps() {
	has_version -r "llvm-core/llvm:${LLVM_SLOT}[${LLVM_TARGET_USEDEPS// /,}]"
}

# Is LLVM being linked against libc++?
is_libcxx_linked() {
	local code='#include <ciso646>
#if defined(_LIBCPP_VERSION)
	HAVE_LIBCXX
#endif
'
	local out=$($(tc-getCXX) ${CXXFLAGS} ${CPPFLAGS} -x c++ -E -P - <<<"${code}") || return 1
	[[ ${out} == *HAVE_LIBCXX* ]]
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
	python-any-r1_pkg_setup

	export LIBGIT2_NO_PKG_CONFIG=1 #749381
	if tc-is-cross-compiler; then
		use system-llvm && die "USE=system-llvm not allowed when cross-compiling"
		local cross_llvm_target="$(llvm_tuple_to_target "${CBUILD}")"
		use "llvm_targets_${cross_llvm_target}" || \
			die "Must enable LLVM_TARGETS=${cross_llvm_target} matching CBUILD=${CBUILD} when cross-compiling"
	fi

	rust_pkg_setup

	if use system-llvm; then
		llvm-r1_pkg_setup

		local llvm_config="$(get_llvm_prefix)/bin/llvm-config"
		export LLVM_LINK_SHARED=1
		export RUSTFLAGS="${RUSTFLAGS} -Lnative=$("${llvm_config}" --libdir)"
	fi
}

src_unpack() {
	if use verify-sig ; then
		# Patch tarballs are not signed (but we trust Gentoo infra)
		verify-sig_verify_detached "${DISTDIR}"/rustc-${PV}-src.tar.xz{,.asc}
		default
	else
		default
	fi
}

src_prepare() {
	PATCHES=(
		"${WORKDIR}/rust-patches-${RUST_PATCH_VER}/"
	)
	default
}

src_configure() {
	if tc-is-cross-compiler; then
		export PKG_CONFIG_ALLOW_CROSS=1
		export PKG_CONFIG_PATH="${ESYSROOT}/usr/$(get_libdir)/pkgconfig"
		export OPENSSL_INCLUDE_DIR="${ESYSROOT}/usr/include"
		export OPENSSL_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)"
	fi

	filter-lto # https://bugs.gentoo.org/862109 https://bugs.gentoo.org/866231

	local rust_target="" rust_targets="" arch_cflags

	# Collect rust target names to compile standard libs for all ABIs.
	for v in $(multilib_get_enabled_abi_pairs); do
		rust_targets+=",\"$(rust_abi $(get_abi_CHOST ${v##*.}))\""
	done
	if use wasm; then
		rust_targets+=",\"wasm32-unknown-unknown\""
		if use system-llvm; then
			# un-hardcode rust-lld linker for this target
			# https://bugs.gentoo.org/715348
			sed -i '/linker:/ s/rust-lld/wasm-ld/' compiler/rustc_target/src/spec/base/wasm.rs || die
		fi
	fi
	rust_targets="${rust_targets#,}"

	# cargo and rustdoc are mandatory and should always be included
	local tools='"cargo","rustdoc", "rust-demangler"'
	use clippy && tools+=',"clippy"'
	use miri && tools+=',"miri"'
	use rustfmt && tools+=',"rustfmt"'
	use rust-analyzer && tools+=',"rust-analyzer","rust-analyzer-proc-macro-srv"'
	use rust-src && tools+=',"src"'

	local rust_stage0_root="$(${RUSTC} --print sysroot || die "Can't determine rust's sysroot")"
	# in case of prefix it will be already prefixed, as --print sysroot returns full path
	[[ -d ${rust_stage0_root} ]] || die "${rust_stage0_root} is not a directory"

	rust_target="$(rust_abi)"
	rust_build="$(rust_abi "${CBUILD}")"
	rust_host="$(rust_abi "${CHOST}")"

	RUST_EXPERIMENTAL_TARGETS=()
	for _x in "${!ALL_RUST_EXPERIMENTAL_TARGETS[@]}"; do
		if [[ ${ALL_RUST_EXPERIMENTAL_TARGETS[${_x}]} == 1 ]] && use ${_x} ; then
			RUST_EXPERIMENTAL_TARGETS+=( ${_x#llvm_targets_} )
		fi
	done
	RUST_EXPERIMENTAL_TARGETS=${RUST_EXPERIMENTAL_TARGETS[@]}

	local cm_btype="$(usex debug DEBUG RELEASE)"
	cat <<- _EOF_ > "${S}"/config.toml
		[llvm]
		download-ci-llvm = false
		optimize = $(toml_usex !debug)
		release-debuginfo = $(toml_usex debug)
		assertions = $(toml_usex debug)
		ninja = true
		targets = "${LLVM_TARGETS// /;}"
		experimental-targets = "${RUST_EXPERIMENTAL_TARGETS// /;}"
		link-shared = $(toml_usex system-llvm)
		$(if is_libcxx_linked; then
			# https://bugs.gentoo.org/732632
			echo "use-libcxx = true"
			echo "static-libstdcpp = false"
		fi)
		$(case "${rust_target}" in
			i586-*-linux-*)
				# https://github.com/rust-lang/rust/issues/93059
				echo 'cflags = "-fcf-protection=none"'
				echo 'cxxflags = "-fcf-protection=none"'
				echo 'ldflags = "-fcf-protection=none"'
				;;
			*)
				;;
		esac)
		enable-warnings = false
		[llvm.build-config]
		CMAKE_VERBOSE_MAKEFILE = "ON"
		$(if ! tc-is-cross-compiler; then
			# When cross-compiling, LLVM is compiled twice, once for host and
			# once for target.  Unfortunately, this build configuration applies
			# to both, which means any flags applicable to one target but not
			# the other will break.  Conditionally disable respecting user
			# flags when cross-compiling.
			echo "CMAKE_C_FLAGS_${cm_btype} = \"${CFLAGS}\""
			echo "CMAKE_CXX_FLAGS_${cm_btype} = \"${CXXFLAGS}\""
			echo "CMAKE_EXE_LINKER_FLAGS_${cm_btype} = \"${LDFLAGS}\""
			echo "CMAKE_MODULE_LINKER_FLAGS_${cm_btype} = \"${LDFLAGS}\""
			echo "CMAKE_SHARED_LINKER_FLAGS_${cm_btype} = \"${LDFLAGS}\""
			echo "CMAKE_STATIC_LINKER_FLAGS_${cm_btype} = \"${ARFLAGS}\""
		fi)
		[build]
		build-stage = 2
		test-stage = 2
		build = "${rust_build}"
		host = ["${rust_host}"]
		target = [${rust_targets}]
		cargo = "${rust_stage0_root}/bin/cargo"
		rustc = "${rust_stage0_root}/bin/rustc"
		rustfmt = "${rust_stage0_root}/bin/rustfmt"
		docs = $(toml_usex doc)
		compiler-docs = false
		submodules = false
		python = "${EPYTHON}"
		locked-deps = true
		vendor = true
		extended = true
		tools = [${tools}]
		verbose = 2
		sanitizers = false
		profiler = true
		cargo-native-static = false
		[install]
		prefix = "${EPREFIX}/usr/lib/${PN}/${PV}"
		sysconfdir = "etc"
		docdir = "share/doc/rust"
		bindir = "bin"
		libdir = "lib"
		mandir = "share/man"
		[rust]
		# https://github.com/rust-lang/rust/issues/54872
		codegen-units-std = 1
		optimize = true
		debug = $(toml_usex debug)
		debug-assertions = $(toml_usex debug)
		debug-assertions-std = $(toml_usex debug)
		debuginfo-level = $(usex debug 2 0)
		debuginfo-level-rustc = $(usex debug 2 0)
		debuginfo-level-std = $(usex debug 2 0)
		debuginfo-level-tools = $(usex debug 2 0)
		debuginfo-level-tests = 0
		backtrace = true
		incremental = false
		$(if ! tc-is-cross-compiler; then
			echo "default-linker = \"${CHOST}-cc\""
		fi)
		parallel-compiler = $(toml_usex parallel-compiler)
		channel = "$(usex nightly nightly stable)"
		description = "gentoo"
		rpath = true
		verbose-tests = true
		optimize-tests = $(toml_usex !debug)
		codegen-tests = true
		dist-src = false
		remap-debuginfo = true
		lld = $(usex system-llvm false $(toml_usex wasm))
		# only deny warnings if doc+wasm are NOT requested, documenting stage0 wasm std fails without it
		# https://github.com/rust-lang/rust/issues/74976
		# https://github.com/rust-lang/rust/issues/76526
		deny-warnings = $(usex wasm $(usex doc false true) true)
		backtrace-on-ice = true
		jemalloc = false
		# See https://github.com/rust-lang/rust/issues/121124
		lto = "$(usex lto thin off)"
		[dist]
		src-tarball = false
		compression-formats = ["xz"]
		compression-profile = "balanced"
	_EOF_

	for v in $(multilib_get_enabled_abi_pairs); do
		rust_target=$(rust_abi $(get_abi_CHOST ${v##*.}))
		arch_cflags="$(get_abi_CFLAGS ${v##*.})"

		export CFLAGS_${rust_target//-/_}="${arch_cflags}"

		cat <<- _EOF_ >> "${S}"/config.toml
			[target.${rust_target}]
			ar = "$(tc-getAR)"
			cc = "$(tc-getCC)"
			cxx = "$(tc-getCXX)"
			linker = "$(tc-getCC)"
			ranlib = "$(tc-getRANLIB)"
			llvm-libunwind = "$(usex llvm-libunwind $(usex system-llvm system in-tree) no)"
		_EOF_
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix)/bin/llvm-config"
			_EOF_
		fi
		# by default librustc_target/spec/linux_musl_base.rs sets base.crt_static_default = true;
		# but we patch it and set to false here as well
		if use elibc_musl; then
			cat <<- _EOF_ >> "${S}"/config.toml
				crt-static = false
				musl-root = "$($(tc-getCC) -print-sysroot)/usr"
			_EOF_
		fi
	done
	if use wasm; then
		wasm_target="wasm32-unknown-unknown"
		export CFLAGS_${wasm_target//-/_}="$(filter-flags '-mcpu*' '-march*' '-mtune*'; echo "$CFLAGS")"
		cat <<- _EOF_ >> "${S}"/config.toml
			[target.wasm32-unknown-unknown]
			linker = "$(usex system-llvm lld rust-lld)"
			# wasm target does not have profiler_builtins https://bugs.gentoo.org/848483
			profiler = false
		_EOF_
	fi

	if [[ -n ${I_KNOW_WHAT_I_AM_DOING_CROSS} ]]; then # whitespace intentionally shifted below
	# experimental cross support
	# discussion: https://bugs.gentoo.org/679878
	# TODO: c*flags, clang, system-llvm, cargo.eclass target support
	# it would be much better if we could split out stdlib
	# complilation to separate ebuild and abuse CATEGORY to
	# just install to /usr/lib/rustlib/<target>

	# extra targets defined as a bash array
	# spec format:  <LLVM target>:<rust-target>:<CTARGET>
	# best place would be /etc/portage/env/dev-lang/rust
	# Example:
	# RUST_CROSS_TARGETS=(
	#	"AArch64:aarch64-unknown-linux-gnu:aarch64-unknown-linux-gnu"
	# )
	# no extra hand holding is done, no target transformations, all
	# values are passed as-is with just basic checks, so it's up to user to supply correct values
	# valid rust targets can be obtained with
	# 	rustc --print target-list
	# matching cross toolchain has to be installed
	# matching LLVM_TARGET has to be enabled for both rust and llvm (if using system one)
	# only gcc toolchains installed with crossdev are checked for now.

	# BUG: we can't pass host flags to cross compiler, so just filter for now
	# BUG: this should be more fine-grained.
	filter-flags '-mcpu=*' '-march=*' '-mtune=*'

	local cross_target_spec
	for cross_target_spec in "${RUST_CROSS_TARGETS[@]}";do
		# extracts first element form <LLVM target>:<rust-target>:<CTARGET>
		local cross_llvm_target="${cross_target_spec%%:*}"
		# extracts toolchain triples, <rust-target>:<CTARGET>
		local cross_triples="${cross_target_spec#*:}"
		# extracts first element after before : separator
		local cross_rust_target="${cross_triples%%:*}"
		# extracts last element after : separator
		local cross_toolchain="${cross_triples##*:}"
		use llvm_targets_${cross_llvm_target} || die "need llvm_targets_${cross_llvm_target} target enabled"
		command -v ${cross_toolchain}-gcc > /dev/null 2>&1 || die "need ${cross_toolchain} cross toolchain"

		cat <<- _EOF_ >> "${S}"/config.toml
			[target.${cross_rust_target}]
			ar = "${cross_toolchain}-ar"
			cc = "${cross_toolchain}-gcc"
			cxx = "${cross_toolchain}-g++"
			linker = "${cross_toolchain}-gcc"
			ranlib = "${cross_toolchain}-ranlib"
		_EOF_
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix)/bin/llvm-config"
			_EOF_
		fi
		if [[ "${cross_toolchain}" == *-musl* ]]; then
			cat <<- _EOF_ >> "${S}"/config.toml
				musl-root = "$(${cross_toolchain}-gcc -print-sysroot)/usr"
			_EOF_
		fi

		# append cross target to "normal" target list
		# example 'target = ["powerpc64le-unknown-linux-gnu"]'
		# becomes 'target = ["powerpc64le-unknown-linux-gnu","aarch64-unknown-linux-gnu"]'

		rust_targets="${rust_targets},\"${cross_rust_target}\""
		sed -i "/^target = \[/ s#\[.*\]#\[${rust_targets}\]#" config.toml || die

		ewarn
		ewarn "Enabled ${cross_rust_target} rust target"
		ewarn "Using ${cross_toolchain} cross toolchain"
		ewarn
		if ! has_version -b 'sys-devel/binutils[multitarget]' ; then
			ewarn "'sys-devel/binutils[multitarget]' is not installed"
			ewarn "'strip' will be unable to strip cross libraries"
			ewarn "cross targets will be installed with full debug information"
			ewarn "enable 'multitarget' USE flag for binutils to be able to strip object files"
			ewarn
			ewarn "Alternatively llvm-strip can be used, it supports stripping any target"
			ewarn "define STRIP=\"llvm-strip\" to use it (experimental)"
			ewarn
		fi
	done
	fi # I_KNOW_WHAT_I_AM_DOING_CROSS

	einfo "Rust configured with the following flags:"
	echo
	echo RUSTFLAGS="\"${RUSTFLAGS}\""
	echo RUSTFLAGS_BOOTSTRAP="\"${RUSTFLAGS_BOOTSTRAP}\""
	echo RUSTFLAGS_NOT_BOOTSTRAP="\"${RUSTFLAGS_NOT_BOOTSTRAP}\""
	echo MAGIC_EXTRA_RUSTFLAGS="\"${MAGIC_EXTRA_RUSTFLAGS}\""
	env | grep "CARGO_TARGET_.*_RUSTFLAGS="
	env | grep "CFLAGS_.*"
	echo
	einfo "config.toml contents:"
	cat "${S}"/config.toml || die
	echo
}

src_compile() {
	RUST_BACKTRACE=1 "${EPYTHON}" ./x.py build -v --config="${S}"/config.toml -j$(makeopts_jobs) || die
}

src_test() {
	# https://rustc-dev-guide.rust-lang.org/tests/intro.html

	# those are basic and codegen tests.
	local tests=(
		codegen
		codegen-units
		compile-fail
		incremental
		mir-opt
		pretty
		run-make
	)

	# fails if llvm is not built with ALL targets.
	# and known to fail with system llvm sometimes.
	use system-llvm || tests+=( assembly )

	# fragile/expensive/less important tests
	# or tests that require extra builds
	# TODO: instead of skipping, just make some nonfatal.
	if [[ ${ERUST_RUN_EXTRA_TESTS:-no} != no ]]; then
		tests+=(
			rustdoc
			rustdoc-js
			rustdoc-js-std
			rustdoc-ui
			run-make-fulldeps
			ui
			ui-fulldeps
		)
	fi

	local i failed=()
	einfo "rust_src_test: enabled tests ${tests[@]/#/src/test/}"
	for i in "${tests[@]}"; do
		local t="src/test/${i}"
		einfo "rust_src_test: running ${t}"
		if ! RUST_BACKTRACE=1 "${EPYTHON}" ./x.py test -vv --config="${S}"/config.toml \
				-j$(makeopts_jobs) --no-doc --no-fail-fast "${t}"
		then
				failed+=( "${t}" )
				eerror "rust_src_test: ${t} failed"
		fi
	done

	if [[ ${#failed[@]} -ne 0 ]]; then
		eerror "rust_src_test: failure summary: ${failed[@]}"
		die "aborting due to test failures"
	fi
}

src_install() {
	DESTDIR="${D}" "${EPYTHON}" ./x.py install -v --config="${S}"/config.toml -j$(makeopts_jobs) || die

	# bug #689562, #689160
	rm -v "${ED}/usr/lib/${PN}/${PV}/etc/bash_completion.d/cargo" || die
	rmdir -v "${ED}/usr/lib/${PN}/${PV}"/etc{/bash_completion.d,} || die

	local symlinks=(
		cargo
		rustc
		rustdoc
		rust-gdb
		rust-gdbgui
		rust-lldb
		rust-demangler
	)

	use clippy && symlinks+=( clippy-driver cargo-clippy )
	use miri && symlinks+=( miri cargo-miri )
	use rustfmt && symlinks+=( rustfmt cargo-fmt )
	use rust-analyzer && symlinks+=( rust-analyzer )

	einfo "installing eselect-rust symlinks and paths: ${symlinks[@]}"
	local i
	for i in "${symlinks[@]}"; do
		# we need realpath on /usr/bin/* symlink return version-appended binary path.
		# so /usr/bin/rustc should point to /usr/lib/rust/<ver>/bin/rustc-<ver>
		# need to fix eselect-rust to remove this hack.
		local ver_i="${i}-${PV}"
		if [[ -f "${ED}/usr/lib/${PN}/${PV}/bin/${i}" ]]; then
			einfo "Installing ${i} symlink"
			ln -v "${ED}/usr/lib/${PN}/${PV}/bin/${i}" "${ED}/usr/lib/${PN}/${PV}/bin/${ver_i}" || die
		else
			ewarn "${i} symlink requested, but source file not found"
			ewarn "please report this"
		fi
		dosym "../lib/${PN}/${PV}/bin/${ver_i}" "/usr/bin/${ver_i}"
	done

	# symlinks to switch components to active rust in eselect
	dosym "${PV}/lib" "/usr/lib/${PN}/lib-${PV}"
	use rust-analyzer && dosym "${PV}/libexec" "/usr/lib/${PN}/libexec-${PV}"
	dosym "${PV}/share/man" "/usr/lib/${PN}/man-${PV}"
	dosym "rust/${PV}/lib/rustlib" "/usr/lib/rustlib-${PV}"
	dosym "../../lib/${PN}/${PV}/share/doc/rust" "/usr/share/doc/${P}"

	newenvd - "50${P}" <<-_EOF_
		MANPATH="${EPREFIX}/usr/lib/rust/man-${PV}"
	_EOF_

	rm -rf "${ED}/usr/lib/${PN}/${PV}"/*.old || die
	rm -rf "${ED}/usr/lib/${PN}/${PV}/bin"/*.old || die
	rm -rf "${ED}/usr/lib/${PN}/${PV}/doc"/*.old || die

	# note: eselect-rust adds EROOT to all paths below
	cat <<-_EOF_ > "${T}/provider-${P}"
		/usr/bin/cargo
		/usr/bin/rustdoc
		/usr/bin/rust-demangler
		/usr/bin/rust-gdb
		/usr/bin/rust-gdbgui
		/usr/bin/rust-lldb
		/usr/lib/rustlib
		/usr/lib/rust/lib
		/usr/lib/rust/man
		/usr/share/doc/rust
	_EOF_

	if use clippy; then
		echo /usr/bin/clippy-driver >> "${T}/provider-${P}"
		echo /usr/bin/cargo-clippy >> "${T}/provider-${P}"
	fi
	if use miri; then
		echo /usr/bin/miri >> "${T}/provider-${P}"
		echo /usr/bin/cargo-miri >> "${T}/provider-${P}"
	fi
	if use rustfmt; then
		echo /usr/bin/rustfmt >> "${T}/provider-${P}"
		echo /usr/bin/cargo-fmt >> "${T}/provider-${P}"
	fi
	if use rust-analyzer; then
		echo /usr/lib/rust/libexec >> "${T}/provider-${P}"
		echo /usr/bin/rust-analyzer >> "${T}/provider-${P}"
	fi
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"

	if use dist; then
		"${EPYTHON}" ./x.py dist -v --config="${S}"/config.toml -j$(makeopts_jobs) || die
		insinto "/usr/lib/${PN}/${PV}/dist"
		doins -r "${S}/build/dist/."
	fi
}

pkg_preinst() {
	# 943308 and friends; basically --keep-going can forget to unmerge old rust
	# but the soft blocker allows us to install conflicting files.
	# This results in duplicated .{rlib,so} files which confuses rustc and results in
	# the need for manual intervention.
	if has_version -b "dev-lang/rust:stable/$(ver_cut 1-2)"; then
		# we need to find all .{rlib,so} files in the old rust lib directory
		# and store them in an array for later use
		readarray -d '' old_rust_libs < <(
			find "${EROOT}/usr/lib/rust/${PV}/lib/rustlib" \
			-type f \( -name '*.rlib' -o -name '*.so' \) -print0)
		export old_rust_libs
		if [[ ${#old_rust_libs[@]} -gt 0 ]]; then
			einfo "Found old .rlib and .so files in the old rust lib directory"
		else
			die "Found no old .rlib and .so files but old rust version is installed. Bailing!"
		fi
	fi
}

pkg_postinst() {

	local old_rust="dev-lang/rust:stable/$(ver_cut 1-2)"
	if has_version -b ${old_rust}; then
		# Be _extra_ careful here as we're removing files from the live filesystem
		local f
		local only_one_file=()
		einfo "Tidying up libraries files from non-slotted \`${old_rust}\`."
		for f in "${old_rust_libs[@]}"; do
			[[ -f ${f} ]] || die "old_rust_libs array contains non-existent file"
			local base_name="${f%-*}"
			local ext="${f##*.}"
			local matching_files=("${base_name}"-*.${ext})
			case ${#matching_files[@]} in
				2)
					einfo "Removing old .${ext}: ${f}"
					rm "${f}" || die
					;;
				1)
					# Turns out fingerprints are not as unique as we'd thought, _sometimes_ they collide,
					# so we may have already installed over the old file.
					# We'll warn about this just in case, but it's probably fine.
					only_one_file+=( "${matching_files[0]}" )
					;;
				*)
					die "Expected one or two files matching ${base_name}-\*.rlib, but found ${#matching_files[@]}"
					;;
			esac
		done
		if [[ ${#only_one_file} -gt 0 ]]; then
			einfo "While tidying up non-slotted rust libraries for \`${old_rust}\`,"
			einfo "the following file(s) did not have a duplicate where one was expected:"
			for f in "${only_one_file[@]}"; do
				einfo "	* ${f}"
			done
			einfo ""
			einfo "This is unlikely to cause problems; the fingerprint for the library ended up being the same."
			einfo "However, if you encounter any issues please report them to the Gentoo Rust Team."
		fi
	fi

	eselect rust update

	if has_version dev-debug/gdb || has_version llvm-core/lldb; then
		elog "Rust installs helper scripts for calling GDB and LLDB,"
		elog "for convenience they are installed under /usr/bin/rust-{gdb,lldb}-${PV}."
	fi

	optfeature "Emacs support" "app-emacs/rust-mode"
	optfeature "Vim support" "app-vim/rust-vim"
}

pkg_postrm() {
	eselect rust cleanup
}
