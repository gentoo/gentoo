# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit prefix bash-completion-r1 check-reqs estack flag-o-matic llvm multiprocessing multilib-build python-any-r1 rust-toolchain toolchain-funcs

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz"
else
	ABI_VER="$(ver_cut 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

RUST_STAGE0_VERSION="1.$(($(ver_cut 2) - 1)).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

SRC_URI="
	https://static.rust-lang.org/dist/${SRC}
	!system-bootstrap? ( $(rust_all_arch_uris rust-${RUST_STAGE0_VERSION}) )
"

# keep in sync with llvm ebuild of the same version as bundled one.
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="clippy cpu_flags_x86_sse2 debug doc libressl miri nightly parallel-compiler rls rustfmt system-bootstrap system-llvm test wasm ${ALL_LLVM_TARGETS[*]}"

# Please keep the LLVM dependency block separate. Since LLVM is slotted,
# we need to *really* make sure we're not pulling more than one slot
# simultaneously.

# How to use it:
# 1. List all the working slots (with min versions) in ||, newest first.
# 2. Update the := to specify *max* version, e.g. < 12.
# 3. Specify LLVM_MAX_SLOT, e.g. 11.
LLVM_DEPEND="
	|| (
		sys-devel/llvm:11[${LLVM_TARGET_USEDEPS// /,}]
	)
	<sys-devel/llvm-12:=
	wasm? ( sys-devel/lld )
"
LLVM_MAX_SLOT=11

# to bootstrap we need at least exactly previous version, or same.
# most of the time previous versions fail to bootstrap with newer
# for example 1.47.x, requires at least 1.46.x, 1.47.x is ok,
# but it fails to bootstrap with 1.48.x
# https://github.com/rust-lang/rust/blob/${PV}/src/stage0.txt
BOOTSTRAP_DEPEND="||
	(
		=dev-lang/rust-$(ver_cut 1).$(($(ver_cut 2) - 1))*
		=dev-lang/rust-bin-$(ver_cut 1).$(($(ver_cut 2) - 1))*
		=dev-lang/rust-$(ver_cut 1).$(ver_cut 2)*
		=dev-lang/rust-bin-$(ver_cut 1).$(ver_cut 2)*
	)
"

BDEPEND="${PYTHON_DEPS}
	prefix? ( !system-bootstrap? ( dev-util/patchelf ) )
	app-eselect/eselect-rust
	|| (
		>=sys-devel/gcc-4.7
		>=sys-devel/clang-3.5
	)
	system-bootstrap? ( ${BOOTSTRAP_DEPEND} )
	!system-llvm? (
		dev-util/cmake
		dev-util/ninja
	)
"

DEPEND="
	>=app-arch/xz-utils-5.2
	net-misc/curl:=[http2,ssl]
	sys-libs/zlib:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	elibc_musl? ( sys-libs/libunwind:= )
	system-llvm? (
		${LLVM_DEPEND}
	)
"

# we need to block older versions due to layout changes.
RDEPEND="${DEPEND}
	app-eselect/eselect-rust
	!<dev-lang/rust-1.47.0-r1
	!<dev-lang/rust-bin-1.47.0-r1
"

REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )
	miri? ( nightly )
	parallel-compiler? ( nightly )
	test? ( ${ALL_LLVM_TARGETS[*]} )
	wasm? ( llvm_targets_WebAssembly )
	x86? ( cpu_flags_x86_sse2 )
"

# we don't use cmake.eclass, but can get a warnings
CMAKE_WARN_UNUSED_CLI=no

QA_FLAGS_IGNORED="
	usr/lib/${PN}/${PV}/bin/.*
	usr/lib/${PN}/${PV}/lib/lib.*.so
	usr/lib/${PN}/${PV}/lib/rustlib/.*/bin/.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

QA_SONAME="
	usr/lib/${PN}/${PV}/lib/lib.*.so.*
	usr/lib/${PN}/${PV}/lib/rustlib/.*/lib/lib.*.so
"

# causes double bootstrap
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/1.47.0-libressl.patch
	"${FILESDIR}"/1.46.0-don-t-create-prefix-at-time-of-check.patch
	"${FILESDIR}"/1.47.0-ignore-broken-and-non-applicable-tests.patch
	"${FILESDIR}"/1.47.0-llvm-tensorflow-fix.patch
	"${FILESDIR}"/1.49.0-gentoo-musl-target-specs.patch
	"${FILESDIR}"/1.49.0-llvm-ver-display.patch
)

S="${WORKDIR}/${MY_P}-src"

toml_usex() {
	usex "${1}" true false
}

boostrap_rust_version_check() {
	# never call from pkg_pretend. eselect-rust may be not installed yet.
	[[ ${MERGE_TYPE} == binary ]] && return
	local rustc_wanted="$(ver_cut 1).$(($(ver_cut 2) - 1))"
	local rustc_toonew="$(ver_cut 1).$(($(ver_cut 2) + 1))"
	local rustc_version=( $(eselect --brief rust show 2>/dev/null) )
	rustc_version=${rustc_version[0]#rust-bin-}
	rustc_version=${rustc_version#rust-}

	[[ -z "${rustc_version}" ]] && die "Failed to determine rust version, check 'eselect rust' output"

	if ver_test "${rustc_version}" -lt "${rustc_wanted}" ; then
		eerror "Rust >=${rustc_wanted} is required"
		eerror "please run 'eselect rust' and set correct rust version"
		die "selected rust version is too old"
	elif ver_test "${rustc_version}" -ge "${rustc_toonew}" ; then
		eerror "Rust <${rustc_toonew} is required"
		eerror "please run 'eselect rust' and set correct rust version"
		die "selected rust version is too new"
	else
		einfo "Using rust ${rustc_version} to build"
	fi
}

pre_build_checks() {
	local M=6144
	M=$(( $(usex clippy 128 0) + ${M} ))
	M=$(( $(usex miri 128 0) + ${M} ))
	M=$(( $(usex rls 512 0) + ${M} ))
	M=$(( $(usex rustfmt 256 0) + ${M} ))
	M=$(( $(usex system-llvm 0 2048) + ${M} ))
	M=$(( $(usex wasm 256 0) + ${M} ))
	M=$(( $(usex debug 15 10) * ${M} / 10 ))
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		M=$(( 15 * ${M} / 10 ))
	fi
	eshopts_pop
	M=$(( $(usex system-bootstrap 0 1024) + ${M} ))
	M=$(( $(usex doc 256 0) + ${M} ))
	CHECKREQS_DISK_BUILD=${M}M check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
	python-any-r1_pkg_setup

	export LIBGIT2_NO_PKG_CONFIG=1 #749381

	use system-bootstrap && boostrap_rust_version_check

	if use system-llvm; then
		llvm_pkg_setup

		local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
		export LLVM_LINK_SHARED=1
		export RUSTFLAGS="${RUSTFLAGS} -Lnative=$("${llvm_config}" --libdir)"
	fi
}

src_prepare() {
	if ! use system-bootstrap; then
		local rust_stage0_root="${WORKDIR}"/rust-stage0
		local rust_stage0="rust-${RUST_STAGE0_VERSION}-$(rust_abi)"

		"${WORKDIR}/${rust_stage0}"/install.sh --disable-ldconfig \
			--destdir="${rust_stage0_root}" --prefix=/ || die

		if use prefix; then
			interpreter=`ldconfig -p | grep ld-linux | awk '{print $NF}' || die "Cannot find your ld.so, why?"`
			ebegin "Changing interpreter to $interpreter for Gentoo prefix"
			for f in `ls -Ud ${rust_stage0_root}/bin/*  || die "Cannot find binary of rust_stage0, why?"`; do
				if file $f | grep -q ELF; then
					einfo "$f's interpreter changed"
					patchelf $f --set-interpreter $interpreter || die "Cannot patchelf, why?"
				else
					hprefixify $f
				fi
			done
			eend $?

			RPATH=${EPREFIX}/usr/$(get_libdir)
			ebegin "Changing rparh to ${RPATH} for Gentoo prefix"
			for f in `ls -Ud ${rust_stage0_root}/lib/*  || die "Cannot find lib of rust_stage0, why?"`; do
				if file $f | grep -q ELF; then
					einfo "$f's rpath changed"
					patchelf $f --remove-rpath || die "Cannot patchelf, why?"
					patchelf $f --set-rpath ${RPATH} || die "Cannot patchelf, why?"
				fi
			done
			eend $?
		fi
	fi

	default
}

src_configure() {
	local rust_target="" rust_targets="" arch_cflags

	# Collect rust target names to compile standard libs for all ABIs.
	for v in $(multilib_get_enabled_abi_pairs); do
		rust_targets="${rust_targets},\"$(rust_abi $(get_abi_CHOST ${v##*.}))\""
	done
	if use wasm; then
		rust_targets="${rust_targets},\"wasm32-unknown-unknown\""
		if use system-llvm; then
			# un-hardcode rust-lld linker for this target
			# https://bugs.gentoo.org/715348
			sed -i '/linker:/ s/rust-lld/wasm-ld/' compiler/rustc_target/src/spec/wasm32_base.rs || die
		fi
	fi
	rust_targets="${rust_targets#,}"

	local tools="\"cargo\","
	if use clippy; then
		tools="\"clippy\",$tools"
	fi
	if use miri; then
		tools="\"miri\",$tools"
	fi
	if use rls; then
		tools="\"rls\",\"analysis\",\"src\",$tools"
	fi
	if use rustfmt; then
		tools="\"rustfmt\",$tools"
	fi

	local rust_stage0_root
	if use system-bootstrap; then
		rust_stage0_root="$(rustc --print sysroot)"
	else
		rust_stage0_root="${WORKDIR}"/rust-stage0
	fi

	rust_target="$(rust_abi)"

	cat <<- _EOF_ > "${S}"/config.toml
		[llvm]
		optimize = $(toml_usex !debug)
		release-debuginfo = $(toml_usex debug)
		assertions = $(toml_usex debug)
		ninja = true
		targets = "${LLVM_TARGETS// /;}"
		experimental-targets = ""
		link-shared = $(toml_usex system-llvm)
		[build]
		build = "${rust_target}"
		host = ["${rust_target}"]
		target = [${rust_targets}]
		cargo = "${rust_stage0_root}/bin/cargo"
		rustc = "${rust_stage0_root}/bin/rustc"
		docs = $(toml_usex doc)
		compiler-docs = $(toml_usex doc)
		submodules = false
		python = "${EPYTHON}"
		locked-deps = true
		vendor = true
		extended = true
		tools = [${tools}]
		verbose = 2
		sanitizers = false
		profiler = false
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
		debuginfo-level-rustc = 0
		backtrace = true
		incremental = false
		default-linker = "$(tc-getCC)"
		parallel-compiler = $(toml_usex parallel-compiler)
		channel = "$(usex nightly nightly stable)"
		rpath = false
		verbose-tests = true
		optimize-tests = $(toml_usex !debug)
		codegen-tests = true
		dist-src = false
		remap-debuginfo = true
		lld = $(usex system-llvm false $(toml_usex wasm))
		backtrace-on-ice = true
		jemalloc = false
		[dist]
		src-tarball = false
	_EOF_

	for v in $(multilib_get_enabled_abi_pairs); do
		rust_target=$(rust_abi $(get_abi_CHOST ${v##*.}))
		arch_cflags="$(get_abi_CFLAGS ${v##*.})"

		cat <<- _EOF_ >> "${S}"/config.env
			CFLAGS_${rust_target}=${arch_cflags}
		_EOF_

		cat <<- _EOF_ >> "${S}"/config.toml
			[target.${rust_target}]
			cc = "$(tc-getBUILD_CC)"
			cxx = "$(tc-getBUILD_CXX)"
			linker = "$(tc-getCC)"
			ar = "$(tc-getAR)"
		_EOF_
		# librustc_target/spec/linux_musl_base.rs sets base.crt_static_default = true;
		if use elibc_musl; then
			cat <<- _EOF_ >> "${S}"/config.toml
				crt-static = false
			_EOF_
		fi
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
			_EOF_
		fi
	done
	if use wasm; then
		cat <<- _EOF_ >> "${S}"/config.toml
			[target.wasm32-unknown-unknown]
			linker = "$(usex system-llvm lld rust-lld)"
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
			cc = "${cross_toolchain}-gcc"
			cxx = "${cross_toolchain}-g++"
			linker = "${cross_toolchain}-gcc"
			ar = "${cross_toolchain}-ar"
		_EOF_
		if use system-llvm; then
			cat <<- _EOF_ >> "${S}"/config.toml
				llvm-config = "$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
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

	einfo "Rust configured with the following settings:"
	cat "${S}"/config.toml || die
}

src_compile() {
	# we need \n IFS to have config.env with spaces loaded properly. #734018
	(
	IFS=$'\n'
	env $(cat "${S}"/config.env) RUST_BACKTRACE=1\
		"${EPYTHON}" ./x.py dist -vv --config="${S}"/config.toml -j$(makeopts_jobs) || die
	)
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
		if ! (
				IFS=$'\n'
				env $(cat "${S}"/config.env) RUST_BACKTRACE=1 \
				"${EPYTHON}" ./x.py test -vv --config="${S}"/config.toml \
				-j$(makeopts_jobs) --no-doc --no-fail-fast "${t}"
			)
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
	# https://github.com/rust-lang/rust/issues/77721
	# also 1.46.0-don-t-create-prefix-at-time-of-check.patch
	dodir "/usr/lib/${PN}/${PV}"
	(
	IFS=$'\n'
	env $(cat "${S}"/config.env) DESTDIR="${D}" \
		"${EPYTHON}" ./x.py install -vv --config="${S}"/config.toml || die
	)

	# bug #689562, #689160
	rm -v "${ED}/usr/lib/${PN}/${PV}/etc/bash_completion.d/cargo" || die
	rmdir -v "${ED}/usr/lib/${PN}/${PV}"/etc{/bash_completion.d,} || die
	dobashcomp build/tmp/dist/cargo-image/etc/bash_completion.d/cargo

	local symlinks=(
		cargo
		rustc
		rustdoc
		rust-gdb
		rust-gdbgui
		rust-lldb
	)

	use clippy && symlinks+=( clippy-driver cargo-clippy )
	use miri && symlinks+=( miri cargo-miri )
	use rls && symlinks+=( rls )
	use rustfmt && symlinks+=( rustfmt cargo-fmt )

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
	dosym "${PV}/share/man" "/usr/lib/${PN}/man-${PV}"
	dosym "rust/${PV}/lib/rustlib" "/usr/lib/rustlib-${PV}"
	dosym "../../lib/${PN}/${PV}/share/doc/rust" "/usr/share/doc/${P}"

	newenvd - "50${P}" <<-_EOF_
		LDPATH="${EPREFIX}/usr/lib/rust/lib"
		MANPATH="${EPREFIX}/usr/lib/rust/man"
		$(usex elibc_musl 'CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-C target-feature=-crt-static"' '')
	_EOF_

	rm -rf "${ED}/usr/lib/${PN}/${PV}"/*.old || die
	rm -rf "${ED}/usr/lib/${PN}/${PV}/doc"/*.old || die

	# note: eselect-rust adds EROOT to all paths below
	cat <<-_EOF_ > "${T}/provider-${P}"
		/usr/bin/cargo
		/usr/bin/rustdoc
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
	if use rls; then
		echo /usr/bin/rls >> "${T}/provider-${P}"
	fi
	if use rustfmt; then
		echo /usr/bin/rustfmt >> "${T}/provider-${P}"
		echo /usr/bin/cargo-fmt >> "${T}/provider-${P}"
	fi

	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update

	if has_version sys-devel/gdb || has_version dev-util/lldb; then
		elog "Rust installs a helper script for calling GDB and LLDB,"
		elog "for your convenience it is installed under /usr/bin/rust-{gdb,lldb}-${PV}."
	fi

	if has_version app-editors/emacs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi
}

pkg_postrm() {
	eselect rust cleanup
}
