# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 17 )
PYTHON_COMPAT=( python3_{11..12} )

RUST_PATCH_VER=${PVR}

RUST_MAX_VER=${PV}
RUST_MIN_VER="$(ver_cut 1).$(($(ver_cut 2) - 1)).0"
RUST_OPTIONAL=1

MRUSTC_VERSION="0.11.2"
MRUSTC_RUST_VERSION="1.74.0"

inherit check-reqs cmake edo estack flag-o-matic llvm-r1 multiprocessing multilib multilib-build \
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
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
fi

DESCRIPTION="Language empowering everyone to build reliable and efficient software"
HOMEPAGE="https://www.rust-lang.org/"

# keep in sync with llvm ebuild of the same version as bundled one.
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARC ARM AVR BPF CSKY DirectX Hexagon Lanai
	LoongArch M68k Mips MSP430 NVPTX PowerPC RISCV Sparc SPIRV SystemZ VE
	WebAssembly X86 XCore Xtensa )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}

# https://github.com/rust-lang/llvm-project/blob/rustc-1.74.1/llvm/CMakeLists.txt
_ALL_RUST_EXPERIMENTAL_TARGETS=( ARC CSKY DirectX M68k SPIRV Xtensa )
declare -A ALL_RUST_EXPERIMENTAL_TARGETS
for _x in "${_ALL_RUST_EXPERIMENTAL_TARGETS[@]}"; do
	ALL_RUST_EXPERIMENTAL_TARGETS["llvm_targets_${_x}"]=0
done

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"
SLOT="${PV}"

IUSE="big-endian clippy cpu_flags_x86_sse2 debug dist doc llvm-libunwind lto miri mrustc-bootstrap nightly parallel-compiler rustfmt rust-analyzer rust-src +system-llvm test wasm ${ALL_LLVM_TARGETS[*]}"

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
	mrustc-bootstrap? (
		~dev-lang/mrustc-${MRUSTC_VERSION}
		dev-build/cmake
		sys-devel/gcc:*
	)
	!mrustc-bootstrap? ( ${RUST_DEPEND} )
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
	if use mrustc-bootstrap; then
		M=$(( 2 * ${M} ))
	fi
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
	if [[ ${MERGE_TYPE} != binary ]]; then
		pre_build_checks
		python-any-r1_pkg_setup

		export LIBGIT2_NO_PKG_CONFIG=1 #749381
		if tc-is-cross-compiler; then
			use system-llvm && die "USE=system-llvm not allowed when cross-compiling"
			local cross_llvm_target="$(llvm_tuple_to_target "${CBUILD}")"
			use "llvm_targets_${cross_llvm_target}" || \
				die "Must enable LLVM_TARGETS=${cross_llvm_target} matching CBUILD=${CBUILD} when cross-compiling"
		fi

		if use mrustc-bootstrap; then
			if ! tc-is-gcc; then
				die "USE=mrustc-bootstrap reqires that the build environment use GCC"
			fi
		else
			rust_pkg_setup
		fi

		if use system-llvm; then
			llvm-r1_pkg_setup

			local llvm_config="$(get_llvm_prefix)/bin/llvm-config"
			export LLVM_LINK_SHARED=1
			export RUSTFLAGS="${RUSTFLAGS} -Lnative=$("${llvm_config}" --libdir)"
		fi
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
	# Commit patches to the appropriate branch in proj/rust-patches.git
	# then cut a new tag / tarball. Don't add patches to ${FILESDIR}
	PATCHES=(
		"${WORKDIR}/rust-patches-${RUST_PATCH_VER}/"
	)
	default
	# We'll need to revert this after the bootstrap.
	if use mrustc-bootstrap; then
		pushd "${S}" 2>/dev/null || die
		patch -p0 < "${BROOT}"/usr/share/mrustc-${MRUSTC_VERSION}/patches/rustc-${MRUSTC_RUST_VERSION}-src.patch ||
			die "Failed to patch sources to enable bootstrap with mrustc"
		popd 2>/dev/null || die
	fi
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
			sed -i '/linker:/ s/rust-lld/wasm-ld/' compiler/rustc_target/src/spec/wasm_base.rs || die
		fi
	fi
	rust_targets="${rust_targets#,}"

	# cargo and rustdoc are mandatory and should always be included
	local tools='"cargo","rustdoc", "rust-demangler"'
	use clippy && tools+=',"clippy"'
	use miri && tools+=',"miri"'
	use rustfmt && tools+=',"rustfmt"'
	use rust-analyzer && tools+=',"rust-analyzer"'
	use rust-src && tools+=',"src"'

	if use mrustc-bootstrap; then
		local rust_stage0_root="${WORKDIR}/bootstrap/rust-${PV}"
	else
		local rust_stage0_root="$(${RUSTC} --print sysroot || die "Can't determine rust's sysroot")"
		# in case of prefix it will be already prefixed, as --print sysroot returns full path
		[[ -d ${rust_stage0_root} ]] || die "${rust_stage0_root} is not a directory"
	fi

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
		changelog-seen = 2
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
		lto = "$(usex lto fat off)"
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
			_EOF_
		fi
	done
	if use wasm; then
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

# Build a very minimal llvm that we can use for bootstrap rustc codegen
llvm_bootstrap() {
	# Reference ${P}/src/bootstrap/native.rs for these values
	local llvm_cmake_opts=(
		"-G Ninja"
		"-DLLVM_TARGET_ARCH=${CFG_COMPILER_HOST_TRIPLE%%-*}"
		"-DLLVM_DEFAULT_TARGET_TRIPLE=${CFG_COMPILER_HOST_TRIPLE}"
		#;Mips;PowerPC;SystemZ;JSBackend;MSP430;Sparc;NVPTX
		"-DLLVM_TARGETS_TO_BUILD=${BOOTSTRAP_LLVM_TARGETS:=X86;ARM;AArch64}"
		"-DLLVM_ENABLE_ASSERTIONS=OFF"
		"-DLLVM_INCLUDE_EXAMPLES=OFF"
		"-DLLVM_INCLUDE_TESTS=OFF"
		"-DLLVM_INCLUDE_DOCS=OFF"
		"-DLLVM_INCLUDE_BENCHMARKS=OFF"
		"-DLLVM_ENABLE_ZLIB=OFF"
		"-DLLVM_ENABLE_TERMINFO=OFF"
		"-DLLVM_ENABLE_LIBEDIT=OFF"
		"-DCMAKE_CXX_COMPILER=$(tc-getCXX)"
		"-DCMAKE_C_COMPILER=$(tc-getCC)"
		"-DCMAKE_BUILD_TYPE=Release"
	)

	if [[ -z "${LLVM_CMAKE_OPTS_EXTRA}" ]]; then
		llvm_cmake_opts+=( "${LLVM_CMAKE_OPTS_EXTRA}")
	fi

	elog "Building bootstrap llvm ..."

	mkdir -p "${WORKDIR}/bootstrap/llvm" || die
	pushd "${WORKDIR}/bootstrap/llvm" 2>/dev/null || die
		edo cmake ${llvm_cmake_opts[*]} "${S}/src/llvm-project/llvm"
		eninja || die "Failed to build bootstrap llvm"
	popd 2>/dev/null || die
}

# High level steps:
# Our system mrustc package has built stdlib for our current platform.
# - Step 1: Use system-installed mrustc, (m)rust(c) stdlib, and minicargo to
#	bootstrap a `cargo` and `rustc` (mrustc-stage0)
# - Step 2: Use minicargo and the built `rustc` to build a working `sysroot`
#			(includes `std`, `panic_unwind``, `test`, etc.) (mrustc-stage0)
# - Step 3: Build build libs again (this time using `cargo` and `rustc`) (mrustc-stage1)
# - Step 4: Build a `rustc` using those libs (mrustc-stage1)
#  - Done so there's an optimised rustc arollvm_cmake_optsund (mrustc is bad at codegen)
# - Step 5: Build `libstd` with this `rustc` (mrustc-stage2)
#  - Needed to match ABIs
# Stages:
# - mrustc-stage0: mrustc-built cargo and rustc
# - mrustc-stage1: rustc and sysroot built with mrustc-stage0
# - mrustc-stage2: rustc from stage1 with sysroot built with stage0
# See:
# - https://github.com/thepowersgang/mrustc/blob/master/run_rustc/Makefile
# - https://github.com/thepowersgang/mrustc/blob/master/TestRustcBootstrap.sh
# - Upstream Windows .cmd files are also a good reference for early bootstrap
mrustc_bootstrap() {
	export RUSTC_BOOTSTRAP=1 # Possibly the only intended use of this variable in ::gentoo
	# export these variables now and unset them at the end of the function so they don't leak
	# into the rest of the build.
	export CFG_COMPILER_HOST_TRIPLE="$(rust_abi)"
	export CFG_RELEASE="${MRUSTC_RUST_VERSION}"	# Let's pretend we're 1.74.0
	export CFG_RELEASE_CHANNEL="stable"
	export CFG_VERSION="${MRUSTC_RUST_VERSION}-stable-mrustc"
	export CFG_PREFIX="mrustc"
	export CFG_LIBDIR_RELATIVE="lib"
	export RUSTC_INSTALL_BINDIR="bin"
	export REAL_LIBRARY_PATH_VAR="LD_LIBRARY_PATH"

	# These flags are used in every invocation of our bootstrap `cargo`.
	local cargo_flags="--target ${CFG_COMPILER_HOST_TRIPLE} -j $(makeopts_jobs) --release --verbose"

	if use system-llvm; then
		export LLVM_CONFIG="$(get_llvm_prefix)/bin/llvm-config"
	else
		llvm_bootstrap
		export LLVM_CONFIG="${WORKDIR}/bootstrap/llvm/bin/llvm-config"
	fi

	# define the mrustc sysroot and common minicargo arguments.
	local mrustc_sysroot="${BROOT}/usr/lib/rust/mrustc-${MRUSTC_VERSION}/lib/rustlib/${CFG_COMPILER_HOST_TRIPLE}/lib"
	local minicargo_common_args=(
		"-L" "${mrustc_sysroot}"
		"-j" "$(makeopts_jobs)"
		"--vendor-dir" "${S}/vendor"
		"--manifest-overrides"
		"${BROOT}/usr/share/mrustc-${MRUSTC_VERSION}/patches/rustc-${MRUSTC_RUST_VERSION}-overrides.toml"
	)
	# There's a very good chance that minicargo and mrustc are not in the PATH.
	if ! command -v minicargo &> /dev/null; then
		export PATH="${BROOT}/usr/lib/rust/mrustc-${MRUSTC_VERSION}/bin:${PATH}"
	fi
	# Sanity check our bootstrap compiler & stdlib.
	elog "Sanity checking mrustc and stdlib ..."
	edo mrustc "${S}/tests/ui/hello_world/main.rs" -L "${mrustc_sysroot}" -o "${T}"/hello -g
	"${T}"/hello || die "Failed to run hello_world"
	# Seems fine, let's build some tools!

	# Step 1: Build a `cargo` and `rustc` using system-installed mrustc
	# Anything we produce is going to be terribly unoptimised; mrustc does not do fantastic codegen.
	# It's good enough to bootstrap the "real" rustc though.
	elog "Building bootstrap cargo and rustc using mrustc and minicargo (mrustc-stage0) ..."
	local stage0="${WORKDIR}/bootstrap/mrustc-stage0"
	mkdir -p "${stage0}" || die
	edo minicargo "${S}"/src/tools/cargo --output-dir "${stage0}"/cargo-build ${minicargo_common_args[*]}
	"${stage0}"/cargo-build/cargo --version || die "Bootstrap cargo failed basic sanity check"
	edo minicargo "${S}"/compiler/rustc --output-dir "${stage0}"/rustc-build ${minicargo_common_args[*]} \
		--features llvm
	"${stage0}"/rustc-build/rustc_main --version || die "Bootstrap rustc failed basic sanity check"
	# minicargo has special-casing for `rustc` so we need to rename it.
	mv "${stage0}"/rustc-build/rustc_main "${stage0}"/rustc-build/rustc || die "Failed to rename rustc_main to rustc"
	# rustc wants these here
	mkdir -p "${stage0}"/codegen-backends || die
	mv "${stage0}"/rustc-build/librustc_codegen_llvm.* "${stage0}"/codegen-backends || die

	# Step 2: use the bootstrapped rustc to build sysroot; we need to use `minicargo` for this -
	# mrustc does not accept all of the arguments that rustc does, even with the rustc_proxy wrapper.
	# `--script-overrides`:  If the overrides are available, build scripts (and build-deps) are not built
	# which is good since we don't have a working compiler yet, and can't build them.

	local stage0_sysroot_lib="${stage0}/lib/rustlib/${CFG_COMPILER_HOST_TRIPLE}/lib"
	# minicargo <= 0.11.2 doesn't create this directory and silently fails, besides it's better to be explicit, right?
	mkdir -p "${stage0_sysroot_lib}" || die "Failed to create stage0 directory"

	elog "Building 'sysroot' using bootstrap rustc (mrustc-stage0) ..."
	edo env MRUSTC_PATH="${stage0}/rustc-build/rustc" minicargo -j $(makeopts_jobs) --vendor-dir "${S}"/vendor \
		--script-overrides  "${BROOT}/usr/share/mrustc-0.11.2/script-overrides/stable-${MRUSTC_RUST_VERSION}-linux/" \
		--output-dir "${stage0_sysroot_lib}" "${S}"/library/sysroot ||
			die "Failed to build sysroot with bootstrap rust (mrustc-stage0)"

	elog "Sanity checking sysroot and rustc ..."
	mkdir -p "${T}"/stage0-hello || die
	edo "${stage0}"/rustc-build/rustc -L "${stage0_sysroot_lib}" -g "${S}/tests/ui/hello_world/main.rs" \
		-o "${T}"/stage0-hello/hello
	"${T}"/stage0-hello/hello || die "Failed to run hello_world built with bootstrap rust stage0"

	elog "mrustc bootstrap stage0 complete!"

	# Step 3: Build a "proper" libstd, including dynamic libs using our bootstrap cargo and rustc.
	elog "Building 'sysroot' with the stage0 rustc (mrustc-stage1) ..."
	local stage1="${WORKDIR}/bootstrap/mrustc-stage1"
	local stage1_sysroot_lib="${stage1}/lib/rustlib/${CFG_COMPILER_HOST_TRIPLE}/lib"
	mkdir -p "${stage1_sysroot_lib}" || die "Failed to create stage1 directory"
	mkdir -p "${stage1}/bin" || die

	# Simplified to avoid calling rustc_proxy; We don't need stage1 rustc until after this is built...
	edo env RUSTFLAGS="-Z force-unstable-if-unmarked" CARGO_TARGET_DIR="${stage1}/sysroot-build" \
		RUSTC="${stage0}/rustc-build/rustc" "${stage0}"/cargo-build/cargo build ${cargo_flags} \
		--manifest-path "${S}/library/sysroot/Cargo.toml" --features panic-unwind

	# Move the built libs into the sysroot libdir.
	mv "${stage1}/sysroot-build/${CFG_COMPILER_HOST_TRIPLE}/release/deps"/*.{rlib,rmeta,so} \
		"${stage1_sysroot_lib}" || die "Failed to move stage1 libs to stage1 sysroot"

	# We need to copy the stage0 rustc to the stage1 sysroot; this "updates" the sysroot location and enables
	# resolution of stage1 libs. (run `rustc --print sysroot` on stage0 and stage1 rustc to verify)
	cp "${stage0}/rustc-build/rustc" "${stage1}/bin/rustc" || die "Failed to copy rustc to stage1 sysroot"

	# Step 4: Build `rustc` with itself, so we have a rustc with the right ABI.
	# This will be our final `rustc` for the bootstrap process.
	elog "Building rustc with stage1 libs (mrustc-stage1) ..."
	mkdir -p "${stage1}/rustc-build" || die
	edo env RUSTFLAGS="-Z force-unstable-if-unmarked -C link_args=-Wl,-rpath,\$ORIGIN/../lib" \
		LD_LIBRARY_PATH="${stage2_sysroot_lib}" CARGO_TARGET_DIR="${stage1}/rustc-build" \
		RUSTC="${stage1}/bin/rustc" TMPDIR="${T}" "${stage0}"/cargo-build/cargo build ${cargo_flags} \
		--manifest-path "${S}/compiler/rustc/Cargo.toml"  --features llvm

	# Step 5: Build `sysroot` with this `rustc` - Needed to match ABI
	# We need to use the previous sysroot; we could reuse that dir but it's easier to just copy it.
	elog "Building final 'sysroot' with the final rustc (mrustc-stage2) ..."
	local stage2="${WORKDIR}/bootstrap/mrustc-stage2"
	local stage2_sysroot_lib="${stage2}/lib/rustlib/${CFG_COMPILER_HOST_TRIPLE}/lib"
	mkdir -p "${stage2_sysroot_lib}" || die "Failed to create stage2 directory"
	mkdir -p "${stage2}/bin" || die

	# Copy required files from stage1 to stage2 sysroot
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/rustc-main "${stage2}/bin/rustc_binary" ||
		die "Failed to copy final rustc to stage2 sysroot"
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/librustc_driver.so "${stage2}/lib" ||
		die "Failed to copy librustc_driver to sysroot"
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/deps/*.{rlib,so} "${stage2_sysroot_lib}" ||
		die "Failed to copy final rustc libs to stage2 sysroot"
	cp "${stage1_sysroot_lib}"/* "${stage2_sysroot_lib}" || die "Failed to copy stage1 so files to stage2 sysroot"

	# There's a magic script used in place of rustc so that libs can be found
	cat <<- EOF > "${stage2}/bin/rustc" || die "Failed to create rustc wrapper"
		#!/bin/sh
		LD_LIBRARY_PATH="${stage2}/lib:${stage2_sysroot_lib}" ${stage2}/bin/rustc_binary "\$@"
	EOF
	chmod +x "${stage2}/bin/rustc" || die "Failed to make rustc wrapper executable"

	# Use rustc to build 'sysroot'; this is the final step in the bootstrap process.
	# rpath probably isn't needed here, but it doesn't hurt.
	edo env RUSTFLAGS="-Z force-unstable-if-unmarked -C link_args=-Wl,-rpath,\$ORIGIN/../lib" \
		CARGO_TARGET_DIR="${stage2}/stdlib-build" RUSTC="${stage2}/bin/rustc" \
		"${stage0}"/cargo-build/cargo build ${cargo_flags} --manifest-path "${S}/library/sysroot/Cargo.toml" \
		--features panic-unwind

	# Build our final output sysroot
	local output="${WORKDIR}/bootstrap/rust-${PV}"
	local output_sysroot_lib="${output}/lib/rustlib/${CFG_COMPILER_HOST_TRIPLE}/lib"
	mkdir -p "${output_sysroot_lib}" || die "Failed to create output directory"
	mkdir -p "${output}/bin" || die "Failed to create output directory"

	# Copy our various output files into the output sysroot
	# rustc
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/rustc-main "${output}/bin/rustc_binary" ||
		die "Failed to copy final rustc to output"
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/librustc_driver.so "${output}/lib" ||
		die "Failed to copy librustc_driver to output"
	cp "${stage1}/rustc-build/${CFG_COMPILER_HOST_TRIPLE}"/release/deps/*.{rlib,so} "${output_sysroot_lib}" ||
		die "Failed to copy final rustc libs to output"
	# cargo; no need to build an optimised cargo if we're using this to build a complelety new Rust.
	cp "${stage0}/cargo-build/cargo" "${output}/bin/cargo" || die "Failed to copy cargo to output"
	# libs
	mv "${stage2}/stdlib-build/${CFG_COMPILER_HOST_TRIPLE}/release/deps"/*.{rlib,rmeta,so} "${output_sysroot_lib}" ||
		die "Failed to copy stage2 libs to output"
	# Our trusty rustc wrapper
	cat <<- EOF > "${output}/bin/rustc" || die "Failed to create rustc wrapper"
		#!/bin/sh
		LD_LIBRARY_PATH="${output}/lib:${output_sysroot_lib}" ${output}/bin/rustc_binary "\$@"
	EOF
	chmod +x "${output}/bin/rustc" || die "Failed to make rustc wrapper executable"

	# Perform a sanity check on the final Rust.
	mkdir -p "${T}"/output-hello || die
	edo "${output}/bin/rustc" -L "${output_sysroot_lib}" -g "${S}/tests/ui/hello_world/main.rs" \
		-o "${T}"/output-hello/hello
	"${T}"/output-hello/hello || die "Failed to run hello_world built with bootstrapped Rust"

	elog "Successfully bootstrapped Rust using mrustc!"

	# Note: The Rust sysroot that we've produced is pretty close to what we'd expect from a normal Rust build.
	# If someone was so inclined they could build an optimised cargo using the stage2 rustc and sysroot,
	# and install the output directly. This is untested, as I'm sure there's more to it than that.
	# I'm satisfied with being able to build Rust normally at this point.

	# Tidy up the Rust sources; revert mrustc changes so Rust can be built normally.
	pushd "${S}" 2>/dev/null || die
		patch -R -p0 < "${BROOT}"/usr/share/mrustc-${MRUSTC_VERSION}/patches/rustc-${MRUSTC_RUST_VERSION}-src.patch ||
			die "Failed to revert mrustc patches"
	popd 2>/dev/null || die

	# Tidy up any environment variables we've set in the bootstrap process.
	unset CFG_COMPILER_HOST_TRIPLE CFG_RELEASE CFG_RELEASE_CHANNEL CFG_PREFIX CFG_VERSION
	unset CFG_LIBDIR_RELATIVE LLVM_CONFIG REAL_LIBRARY_PATH_VAR RUSTFLAGS RUSTC_BOOTSTRAP RUSTC_INSTALL_BINDIR
}

src_compile() {
	use mrustc-bootstrap && mrustc_bootstrap
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
