# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.93.1"
CRATES="
	aho-corasick@1.1.3
	bindgen@0.71.1
	bitflags@2.9.0
	cc@1.2.22
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	either@1.15.0
	glob@0.3.2
	itertools@0.13.0
	libc@0.2.175
	libloading@0.8.6
	log@0.4.27
	memchr@2.7.4
	minimal-lexical@0.2.1
	nom@7.1.3
	prettyplease@0.2.32
	proc-macro2@1.0.95
	quote@1.0.40
	regex@1.11.1
	regex-automata@0.4.9
	regex-syntax@0.8.5
	rustc-hash@2.1.1
	shlex@1.3.0
	syn@2.0.101
	unicode-ident@1.0.18
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

LLVM_COMPAT=( {19..22} )
LLVM_OPTIONAL=1

inherit llvm-r2 cargo optfeature rust-toolchain toolchain-funcs

MY_PN="Reckless"

DESCRIPTION="Competitive UCI chess engine written in Rust, using NNUE evaluation"
HOMEPAGE="https://github.com/codedeliveryservice/Reckless"

NNUE_NET="v54-5478683c.nnue"
NNUE_NET_URI="https://github.com/codedeliveryservice/RecklessNetworks/releases/download/networks/${NNUE_NET}"

SRC_URI="
	https://github.com/codedeliveryservice/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${NNUE_NET_URI} -> ${PN}-${NNUE_NET}
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="AGPL-3 Apache-2.0 BSD ISC MIT Unicode-3.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE+="
	syzygy +numa pgo
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512vl
	cpu_flags_x86_avx512vbmi
	cpu_flags_x86_avx512_vbmi2
	cpu_flags_x86_avx512_vnni
	cpu_flags_x86_avx512_bitalg
"

REQUIRED_USE="
	pgo? ( !debug )
	syzygy? ( ${LLVM_REQUIRED_USE} )
	cpu_flags_x86_avx2? ( amd64 )
	cpu_flags_x86_avx512f? ( amd64 )
	cpu_flags_x86_avx512bw? ( amd64 )
	cpu_flags_x86_avx512vl? ( amd64 )
	cpu_flags_x86_avx512vbmi? ( amd64 )
	cpu_flags_x86_avx512_vbmi2? ( amd64 )
	cpu_flags_x86_avx512_vnni? ( amd64 )
	cpu_flags_x86_avx512_bitalg? ( amd64 )
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512_vbmi2
		cpu_flags_x86_avx512_vnni
		cpu_flags_x86_avx512_bitalg
	)
"

BDEPEND="
	syzygy? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}
		')
	)
	pgo? (
		>=dev-lang/rust-${RUST_MIN_VER}[system-llvm]
	)
"
RDEPEND="numa? ( sys-process/numactl )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-no-git-sha.patch"
)

pkg_setup() {
	use syzygy && llvm-r2_pkg_setup
	rust_pkg_setup

	if [[ ${MERGE_TYPE} != binary ]] && use pgo; then
		[[ -n ${RUST_SLOT} && -n ${RUST_TYPE} ]] ||
			die "RUST_SLOT/RUST_TYPE not set after rust_pkg_setup"

		[[ ${RUST_TYPE} == source ]] ||
			die "USE=pgo requires the active Rust provider to be" \
				"dev-lang/rust built with USE=system-llvm, not" \
				"dev-lang/rust-bin (selected RUST_TYPE=${RUST_TYPE});" \
				"check ERUST_TYPE_OVERRIDE/ERUST_SLOT_OVERRIDE if this is unexpected"

		has_version -b "dev-lang/rust:${RUST_SLOT}[system-llvm]" ||
			die "USE=pgo requires dev-lang/rust:${RUST_SLOT}" \
				"(the Rust slot selected by rust_pkg_setup) to have" \
				"USE=system-llvm enabled -- check" \
				"ERUST_TYPE_OVERRIDE/ERUST_SLOT_OVERRIDE if this is unexpected"

		RECKLESS_LLVM_PROFDATA=$(_reckless_find_llvm_profdata)
		export RECKLESS_LLVM_PROFDATA
	fi
}

pkg_pretend() {
	if use pgo; then
		tc-is-cross-compiler &&
			die "USE=pgo requires running the instrumented binary natively" \
				"(via its own 'bench' command) and is not supported when" \
				"cross-compiling (CHOST != CBUILD)"

		elog "USE=pgo builds Reckless twice: once instrumented, once"
		elog "optimized against a profile from its own 'bench' command."
		elog "This roughly doubles build time and is not reproducible"
		elog "bit-for-bit between machines, since the training run"
		elog "reflects this host's actual branch/cache behavior."
	fi

	use amd64 || return

	if use cpu_flags_x86_avx512f; then
		ewarn "This merge will build the AVX-512 tier (x86-64-v4) with"
		ewarn "additional instructions: GFNI, AVX512VBMI, AVX512VBMI2,"
		ewarn "AVX512VNNI, AVX512BITALG."
		ewarn ""
		ewarn "This requires an Intel Ice Lake, AMD Zen 4, or newer CPU."
		ewarn "Older AVX-512 CPUs that only implement the x86-64-v4 baseline"
		ewarn "(e.g. Intel Skylake-X / Cascade Lake-X) lack these extensions"
		ewarn "and will crash with SIGILL."
		ewarn ""
		ewarn "If you're not sure your CPU actually supports these, check first:"
		ewarn "  emerge -1 app-portage/cpuid2cpuflags"
		ewarn "  cpuid2cpuflags"
	fi
}

src_prepare() {
	default

	# Strip hardcoded target-cpu=native rustflags for several triples
	# in .cargo/config.toml so they can't leak in via cargo_env().
	rm .cargo/config.toml || die

	# rerun-if-changed on .git/HEAD is meaningless for our build.
	sed -i '/cargo:rerun-if-changed=\.git\// d' build/build.rs || die

	# Strip hardcoded clang selection; llvm-core/clang is only needed
	# for libclang.so (bindgen), not to compile the C sources.
	if use syzygy; then
		sed -i '/\.compiler("clang")/d' build/build.rs || die
	fi

	# Stage NNUE net where build expects it, bypassing the network sandbox.
	mkdir -p networks || die
	cp "${DISTDIR}/${PN}-${NNUE_NET}" "networks/${NNUE_NET}" || die
}

# @FUNCTION: _reckless_strip_rustflags
# @USAGE: <out_flags_var> <out_stripped_var> <rustflags>
# @INTERNAL
# @DESCRIPTION:
# Strips -C/--codegen target-cpu=/target-feature= tokens from
# <rustflags>, in any form rustc accepts:
#   -Ctarget-cpu=x86-64-v3
#   -C target-cpu=x86-64-v3
#   --codegen target-feature=+avx2
#   --codegen=target-feature=+avx2
#
# Remaining flags go into the variable named by <out_flags_var>;
# removed tokens are appended to the array named by <out_stripped_var>.
#
# Needed so make.conf/package.env can't override the cpu_flags_x86_*
# tiering in src_configure. No flag-o-matic equivalent for RUSTFLAGS,
# hence hand-rolled.
_reckless_strip_rustflags() {
	debug-print-function "${FUNCNAME}" "$@"

	local -n _out_flags="${1}"
	local -n _out_stripped="${2}"
	local _rustflags_in="${3}"

	local -a _flags_in=() _flags_out=()
	local _old_ifs="${IFS}"
	IFS=$' \t\n'
	set -f
	_flags_in=( ${_rustflags_in} )
	set +f

	local _i=0 _tok
	while (( _i < ${#_flags_in[@]} )); do
		_tok="${_flags_in[_i]}"
		case "${_tok}" in
			-C|--codegen)
				case "${_flags_in[_i+1]:-}" in
					target-cpu=*|target-feature=*)
						_out_stripped+=( "${_tok} ${_flags_in[_i+1]}" )
						(( _i += 2 ))
						continue
						;;
				esac
				;;
			-Ctarget-cpu=*|-Ctarget-feature=*|--codegen=target-cpu=*|--codegen=target-feature=*)
				_out_stripped+=( "${_tok}" )
				(( _i += 1 ))
				continue
				;;
		esac
		_flags_out+=( "${_tok}" )
		(( _i += 1 ))
	done
	IFS="${_old_ifs}"

	_out_flags="${_flags_out[*]}"
}

src_configure() {
	local args=()
	use syzygy || args+=( --no-default-features )
	use numa && args+=( --features numa )

	if use syzygy; then
		# bindgen/clang-sys need libclang.so from the selected slot;
		# it's not on a default linker path.
		export LIBCLANG_PATH="$(get_llvm_prefix -b)/$(get_libdir)"

		# Hardcoded clang selection was stripped above; use the
		# user's actual C toolchain instead.
		tc-export CC
	fi

	if use amd64; then
		local myflags
		local -a stripped_rustflags=()

		_reckless_strip_rustflags myflags stripped_rustflags "${RUSTFLAGS}"

		if (( ${#stripped_rustflags[@]} )); then
			ewarn "Stripped from RUSTFLAGS -- cpu_flags_x86_* controls the CPU tier:"
			ewarn ""
			local _tok
			for _tok in "${stripped_rustflags[@]}"; do
				ewarn "  ${_tok}"
			done
			ewarn ""
			ewarn "Non-tiering target-feature= (e.g. -crt-static) gets stripped too,"
			ewarn "can't tell it apart from the tiering flags."
		fi

		# avx512bw/avx512vl already implied by target-cpu=x86-64-v4
		# since rustc 1.89; relying on upstream rustc for this.
		if use cpu_flags_x86_avx512f; then
			RUSTFLAGS="${myflags} -C target-cpu=x86-64-v4"
			RUSTFLAGS+=" -C target-feature=+gfni,+avx512bw,+avx512vl"
			RUSTFLAGS+=",+avx512vbmi,+avx512vbmi2,+avx512vnni,+avx512bitalg"
		elif use cpu_flags_x86_avx2; then
			RUSTFLAGS="${myflags} -C target-cpu=x86-64-v3"
		else
			RUSTFLAGS="${myflags} -C target-cpu=x86-64"
		fi
	fi

	# No tiering on non-amd64
	: "${RUSTFLAGS:=}"
	export RUSTFLAGS

	cargo_src_configure "${args[@]}"
}

# @FUNCTION: _reckless_find_llvm_profdata
# @INTERNAL
# @DESCRIPTION:
# Locate llvm-profdata matching rustc's own LLVM backend. Independent
# of ${LLVM_SLOT} (that's for bindgen/clang-sys) -- no eclass ties
# dev-lang/rust's LLVM slot to a BDEPEND atom, so resolve it at
# build time via `rustc -vV`.
#
# RUST_SLOT/RUST_TYPE/USE=system-llvm were already validated in
# pkg_setup, before any compilation began.
_reckless_find_llvm_profdata() {
	debug-print-function "${FUNCNAME}" "$@"

	local rustc_llvm
	rustc_llvm=$("${RUSTC}" -vV | sed -n 's/^LLVM version: \([0-9]*\).*/\1/p')
	[[ -n ${rustc_llvm} ]] ||
		die "Could not determine rustc's LLVM version"

	local candidate
	candidate="${BROOT}/usr/lib/llvm/${rustc_llvm}/bin/llvm-profdata"
	if [[ ! -x ${candidate} ]]; then
		eerror "llvm-profdata not found at ${candidate}"
		eerror "emerge llvm-core/llvm:${rustc_llvm} — the slot rustc was"
		eerror "actually built against, per 'rustc -vV' above"
		die "missing llvm-profdata for USE=pgo"
	fi

	echo "${candidate}"
}

# @FUNCTION: _reckless_pgo_profile
# @USAGE: <profdata> <profdir> <target_dir> <base_rustflags>
# @INTERNAL
# @DESCRIPTION:
# Builds an instrumented binary, trains it via the engine's own 'bench'
# command, and merges the resulting .profraw files into
# <profdir>/merged.profdata using the given llvm-profdata binary
# (see _reckless_find_llvm_profdata).
#
# --target is required even without cross-compiling: without it,
# cargo doesn't separate host tools (build scripts, proc-macros) from
# the target artifact, so -Cprofile-generate leaks into every build.rs
# in the tree. Their .profraw is useless (hashes never match the real
# binary) but harmless -- llvm-profdata discards it on merge. cargo-pgo
# does the same for this reason.
#
# Deliberately triggers the host/target split _cargo_needs_target()
# avoids elsewhere -- exactly the separation we want here.
_reckless_pgo_profile() {
	debug-print-function "${FUNCNAME}" "$@"

	local profdata="${1}" profdir="${2}" target_dir="${3}" base_rustflags="${4}"

	einfo "PGO pass 1/2: instrumented build"
	RUSTFLAGS="${base_rustflags} -Cprofile-generate=${profdir}"
	export RUSTFLAGS

	cargo_src_compile --target "$(rust_abi)"

	einfo "PGO training run: '${target_dir}/reckless bench'"
	[[ -x "${target_dir}/reckless" ]] ||
		die "instrumented binary not found at ${target_dir}/reckless"
	"${target_dir}/reckless" bench || die "PGO training run failed"

	[[ -n $(find "${profdir}" -maxdepth 1 -name '*.profraw' -print -quit) ]] ||
		die "no .profraw files written to ${profdir} -- instrumented binary" \
			"may not have exited cleanly, or LLVM_PROFILE_FILE is" \
			"being overridden elsewhere"

	einfo "Merging profile data with ${profdata}"
	"${profdata}" merge -o "${profdir}/merged.profdata" "${profdir}" ||
		die "llvm-profdata merge failed"
}

src_compile() {
	if ! use pgo; then
		cargo_src_compile
		return
	fi

	# Resolved once in pkg_setup(); this is just a sanity check.
	local profdata
	[[ -n ${RECKLESS_LLVM_PROFDATA} ]] ||
		die "RECKLESS_LLVM_PROFDATA not set."

	profdata="${RECKLESS_LLVM_PROFDATA}"

	local profdir="${T}/pgo-profiles"
	mkdir -p "${profdir}" || die

	# cargo_target_dir() honours CARGO_TARGET_DIR
	local cargo_target_root="${CARGO_TARGET_DIR:-target}"
	[[ ${cargo_target_root} == /* ]] || cargo_target_root="${S}/${cargo_target_root}"

	# Deliberately triggers the host/target split _cargo_needs_target()
	# avoids elsewhere -- exactly the separation we want here.
	local target_dir base_rustflags
	target_dir="${cargo_target_root}/$(rust_abi)/$(usex debug debug release)"
	base_rustflags="${RUSTFLAGS}"

	_reckless_pgo_profile "${profdata}" "${profdir}" "${target_dir}" "${base_rustflags}"

	einfo "PGO pass 2/2: optimized build"
	rm -rf "${cargo_target_root}" || die
	RUSTFLAGS="${base_rustflags} -Cprofile-use=${profdir}/merged.profdata"
	RUSTFLAGS+=" -Cllvm-args=-pgo-warn-missing-function"
	export RUSTFLAGS

	cargo_src_compile --target "$(rust_abi)"
}

src_install() {
	if use pgo; then
		# --target must match src_compile's PGO build, or cargo won't
		# find it cached and will silently rebuild without PGO.
		cargo_src_install --target "$(rust_abi)"
	else
		cargo_src_install
	fi

	dodoc README.md
	use syzygy && dodoc deps/Fathom/README.md
}

pkg_postinst() {
	use amd64 || return

	if use cpu_flags_x86_avx512f; then
		return
	elif use cpu_flags_x86_avx2; then
		einfo "This merge built the AVX2 tier (x86-64-v3)."
	else
		einfo "This merge used the generic (x86-64-v1) baseline."
		if [[ -z ${CPU_FLAGS_X86} ]]; then
			optfeature "Detecting the fastest CPU tier your hardware supports" \
				app-portage/cpuid2cpuflags
			elog "To pick the fastest tier your CPU supports:"
			elog "  echo \"${CATEGORY}/${PN} \$(cpuid2cpuflags)\" > /etc/portage/package.use/00reckless"
			elog "  emerge -1 ${CATEGORY}/${PN}"
		fi
	fi
}
