# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 20 )
LLVM_OPTIONAL="yes"

inherit edo llvm-r1 multilib prefix rust-toolchain verify-sig multilib-minimal optfeature

if [[ ${PV} == *9999* ]]; then
	# We need to fetch a tarball in src_unpack
	PROPERTIES+=" live"
elif [[ ${PV} == *beta* ]]; then
	# curl -Ls static.rust-lang.org/dist/channel-rust-beta.toml | grep "xz_url.*rust-src"
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	RUST_TOOLCHAIN_BASEURL=https://static.rust-lang.org/dist/${BETA_SNAPSHOT}/
	SRC_URI="$(rust_all_arch_uris rust-beta rust-${PV})
		rust-src? ( ${RUST_TOOLCHAIN_BASEURL%/}/rust-src-beta.tar.xz -> rust-src-${PV}.tar.xz )
	"
else
	# curl -Ls static.rust-lang.org/dist/channel-rust-${PV}.toml | grep "xz_url.*rust-src"
	SRC_URI="$(rust_all_arch_uris "rust-${PV}")
		rust-src? ( ${RUST_TOOLCHAIN_BASEURL%/}/2025-06-26/rust-src-${PV}.tar.xz )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
fi

GENTOO_BIN_BASEURI="https://github.com/projg2/rust-bootstrap/releases/download/${PVR}" # omit trailing slash

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

if [[ ${PV} != *9999* && ${PV} != *beta* ]] && false ; then
	# Keep this separate to allow easy commenting out if not yet built
	SRC_URI+=" sparc? ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-sparc64-unknown-linux-gnu.tar.xz ) "
	SRC_URI+=" mips? (
		abi_mips_o32? (
			big-endian?  ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-mips-unknown-linux-gnu.tar.xz )
			!big-endian? ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-mipsel-unknown-linux-gnu.tar.xz )
		)
		abi_mips_n64? (
			big-endian?  ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-mips64-unknown-linux-gnuabi64.tar.xz )
			!big-endian? ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-mips64el-unknown-linux-gnuabi64.tar.xz )
		)
	)"
	SRC_URI+=" riscv? (
		elibc_musl? ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-riscv64gc-unknown-linux-musl.tar.xz )
	)"
	SRC_URI+=" ppc64? ( elibc_musl? (
		big-endian?  ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-powerpc64-unknown-linux-musl.tar.xz )
		!big-endian? ( ${GENTOO_BIN_BASEURI}/rust-${PVR}-powerpc64le-unknown-linux-musl.tar.xz )
	) )"
fi

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"
SLOT="${PV%%_*}" # Beta releases get to share the same SLOT as the eventual stable
IUSE="big-endian clippy cpu_flags_x86_sse2 doc prefix rust-analyzer rust-src rustfmt"

RDEPEND="
	>=app-eselect/eselect-rust-20190311
	dev-libs/openssl
	sys-apps/lsb-release
	|| (
		llvm-runtimes/libgcc
		sys-devel/gcc:*
	)
	!dev-lang/rust:stable
	!dev-lang/rust-bin:stable
"
BDEPEND="
	prefix? ( dev-util/patchelf )
	verify-sig? ( sec-keys/openpgp-keys-rust )
"
[[ ${PV} == *9999* ]] && BDEPEND+=" net-misc/curl"

REQUIRED_USE="x86? ( cpu_flags_x86_sse2 )"

# stripping rust may break it (at least on x86_64)
# https://github.com/rust-lang/rust/issues/112286
RESTRICT="strip"

QA_PREBUILT="
	opt/rust-bin-${SLOT}/bin/.*
	opt/rust-bin-${SLOT}/lib/.*.so*
	opt/rust-bin-${SLOT}/libexec/.*
	opt/rust-bin-${SLOT}/lib/rustlib/.*/bin/.*
	opt/rust-bin-${SLOT}/lib/rustlib/.*/lib/.*
"

# An rmeta file is custom binary format that contains the metadata for the crate.
# rmeta files do not support linking, since they do not contain compiled object files.
# so we can safely silence the warning for this QA check.
QA_EXECSTACK="opt/${PN}-${SLOT}/lib/rustlib/*/lib*.rlib:lib.rmeta"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/rust.asc"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		# We need to fetch the latest nightly listing and get the apprapriate src_uri for our arch
		local rust_bin_url rustc_src_url
		# Cut down on webrequests by fetching the nightly toml once
		curl -Ls static.rust-lang.org/dist/channel-rust-nightly.toml > "${WORKDIR}/channel-rust-nightly.toml" ||
			die "Failed to fetch nightly revision info"
		rustc_src_url=$(grep 'xz_url.*rust-src' "${WORKDIR}/channel-rust-nightly.toml" | cut -d '"' -f 2)
		rust_bin_url=$(grep "xz_url.*rust-nightly-$(rust_abi)" "${WORKDIR}/channel-rust-nightly.toml" | cut -d '"' -f 2)
		einfo "Using nightly Rust from: ${rust_bin_url}"

		if use rust-src; then
			einfo "Using nightly Rust-src from: ${rustc_src_url}"
			# We need to fetch the rust-src tarball
			einfo "Fetching nightly rust-src tarball ..."
			curl --progress-bar -L "${rustc_src_url}" -o "${WORKDIR}/rust-src-${PV}.tar.xz" ||
				die "Failed to fetch nightly rust-src tarball."
			# no verify-sig here, just unpack it
			tar -xf "${WORKDIR}/rust-src-${PV}.tar.xz" || die "Failed to unpack nightly rust-src tarball"
		fi

		einfo "Fetching nightly Rust tarball ..."
		curl --progress-bar -L "${rust_bin_url}" -O || die "Failed to fetch nightly tarball"
		if use verify-sig; then
			einfo "Fetching nightly signature ..."
			curl --progress-bar -L "${rust_bin_url}.asc" -O || die "Failed to fetch nightly signature"
			verify-sig_verify_detached "${WORKDIR}/rust-nightly-$(rust_abi).tar.xz" \
				"${WORKDIR}/rust-nightly-$(rust_abi).tar.xz.asc"
		fi
		tar -xf "${WORKDIR}/rust-nightly-$(rust_abi).tar.xz" || die "Failed to unpack nightly tarball"
	else
		# sadly rust-src tarball does not have corresponding .asc file
		# so do partial verification
		if use verify-sig; then
			for f in ${A}; do
				if [[ -f ${DISTDIR}/${f}.asc ]]; then
					verify-sig_verify_detached "${DISTDIR}/${f}" "${DISTDIR}/${f}.asc"
				fi
			done
		fi

		default_src_unpack

	fi
	case ${PV} in
		*9999*)
			mv "${WORKDIR}/rust-nightly-$(rust_abi)" "${S}" || die
			;;
		*beta*)
			mv "${WORKDIR}/rust-beta-$(rust_abi)" "${S}" || die
			;;
		*)
			mv "${WORKDIR}/rust-${PV}-$(rust_abi)" "${S}" || die
			;;
	esac
}

patchelf_for_bin() {
	local filetype=$(file -b ${1})
	if [[ ${filetype} == *ELF*interpreter* ]]; then
		einfo "${1}'s interpreter changed"
		patchelf ${1} --set-interpreter ${2} || die
	elif [[ ${filetype} == *script* ]]; then
		hprefixify ${1}
	fi
}

rust_native_abi_install() {
	pushd "${S}" >/dev/null || die
	local analysis="$(grep 'analysis' ./components || die "analysis not found in components")"
	local std="$(grep 'std' ./components || die "std not found in components")"
	local components=( "rustc" "cargo" "${std}" )
	use doc && components+=( "rust-docs" )
	use clippy && components+=( "clippy-preview" )
	use rustfmt && components+=( "rustfmt-preview" )
	use rust-analyzer && components+=( "rust-analyzer-preview" "${analysis}" )
	# Rust component 'rust-src' is extracted from separate archive
	if use rust-src; then
		einfo "Combining rust and rust-src installers"
		case ${PV} in
			*9999*)
				mv -v "${WORKDIR}/rust-src-nightly/rust-src" "${S}" || die
				;;
			*beta*)
				mv -v "${WORKDIR}/rust-src-beta/rust-src" "${S}" || die
				;;
			*)
				mv -v "${WORKDIR}/rust-src-${PV}/rust-src" "${S}" || die
				;;
		esac
		echo rust-src >> ./components || die
		components+=( "rust-src" )
	fi
	edo ./install.sh \
		--components="$(IFS=,; echo "${components[*]}")" \
		--disable-verify \
		--prefix="${ED}/opt/rust-bin-${SLOT}" \
		--mandir="${ED}/opt/rust-bin-${SLOT}/man" \
		--disable-ldconfig

	docompress /opt/${P}/man/

	if use prefix; then
		local interpreter=$(patchelf --print-interpreter "${EPREFIX}"/bin/bash)
		ebegin "Changing interpreter to ${interpreter} for Gentoo prefix at ${ED}/opt/${SLOT}/bin"
		find "${ED}/opt/${SLOT}/bin" -type f -print0 | \
			while IFS=  read -r -d '' filename; do
				patchelf_for_bin ${filename} ${interpreter} \; || die
			done
		eend $?
	fi

	local symlinks=(
		cargo
		rustc
		rustdoc
		rust-gdb
		rust-gdbgui
		rust-lldb
	)

	use clippy && symlinks+=( clippy-driver cargo-clippy )
	use rustfmt && symlinks+=( rustfmt cargo-fmt )
	use rust-analyzer && symlinks+=( rust-analyzer )

	einfo "installing eselect-rust symlinks and paths"
	local i
	for i in "${symlinks[@]}"; do
		# we need realpath on /usr/bin/* symlink return version-appended binary path.
		# so /usr/bin/rustc should point to /opt/rust-bin-<ver>/bin/rustc-<ver>
		local ver_i="${i}-bin-${SLOT}"
		ln -v "${ED}/opt/rust-bin-${SLOT}/bin/${i}" "${ED}/opt/rust-bin-${SLOT}/bin/${ver_i}" || die
		dosym -r "/opt/rust-bin-${SLOT}/bin/${ver_i}" "/usr/bin/${ver_i}"
	done

	# symlinks to switch components to active rust in eselect
	dosym -r "/opt/rust-bin-${SLOT}/lib" "/usr/lib/rust/lib-bin-${SLOT}"
	dosym -r "/opt/rust-bin-${SLOT}/man" "/usr/lib/rust/man-bin-${SLOT}"
	dosym -r "/opt/rust-bin-${SLOT}/lib/rustlib" "/usr/lib/rustlib-bin-${SLOT}"
	dosym -r "/opt/rust-bin-${SLOT}/share/doc/rust" "/usr/share/doc/rust-bin-${SLOT}"

	# make all capital underscored variable
	local CARGO_TRIPLET="$(rust_abi)"
	CARGO_TRIPLET="${CARGO_TRIPLET//-/_}"
	CARGO_TRIPLET="${CARGO_TRIPLET^^}"
	cat <<-_EOF_ > "${T}/50${P}"
		MANPATH="${EPREFIX}/usr/lib/rust/man-bin-${SLOT}"
	$(usev elibc_musl "CARGO_TARGET_${CARGO_TRIPLET}_RUSTFLAGS=\"-C target-feature=-crt-static\"")
	_EOF_
	doenvd "${T}/50${P}"

	# note: eselect-rust adds EROOT to all paths below
	cat <<-_EOF_ > "${T}/provider-${PN}-${SLOT}"
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
		echo /usr/bin/clippy-driver >> "${T}/provider-${PN}-${SLOT}"
		echo /usr/bin/cargo-clippy >> "${T}/provider-${PN}-${SLOT}"
	fi
	if use rustfmt; then
		echo /usr/bin/rustfmt >> "${T}/provider-${PN}-${SLOT}"
		echo /usr/bin/cargo-fmt >> "${T}/provider-${PN}-${SLOT}"
	fi
	if use rust-analyzer; then
		echo /usr/bin/rust-analyzer >> "${T}/provider-${PN}-${SLOT}"
	fi

	insinto /etc/env.d/rust
	doins "${T}/provider-${PN}-${SLOT}"
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi; then
		rust_native_abi_install
	else
		local rust_target
		rust_target="$(rust_abi $(get_abi_CHOST ${v##*.}))"
		dodir "/opt/${P}/lib/rustlib"
		cp -vr "${WORKDIR}/rust-${PV}-${rust_target}/rust-std-${rust_target}/lib/rustlib/${rust_target}"\
			"${ED}/opt/${P}/lib/rustlib" || die
	fi

	# BUG: installs x86_64 binary on other arches
	rm -f "${ED}/opt/${P}/lib/rustlib/"*/bin/rust-llvm-dwp || die
}

pkg_postinst() {
	eselect rust update

	if has_version dev-debug/gdb || has_version llvm-core/lldb; then
		elog "Rust installs helper scripts for calling GDB and LLDB,"
		elog "for convenience they are installed under /usr/bin/rust-{gdb,lldb}-${PV}."
	fi

	if has_version app-editors/emacs; then
		optfeature "emacs support for rust" app-emacs/rust-mode
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		optfeature "vim support for rust" app-vim/rust-vim
	fi
}

pkg_postrm() {
	eselect rust cleanup
}
