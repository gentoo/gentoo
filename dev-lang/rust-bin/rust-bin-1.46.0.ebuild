# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 rust-toolchain toolchain-funcs multilib-minimal

MY_P="rust-${PV}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"
SRC_URI="$(rust_all_arch_uris ${MY_P})"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="clippy cpu_flags_x86_sse2 doc rls rustfmt"

DEPEND=""
RDEPEND=">=app-eselect/eselect-rust-20190311"

REQUIRED_USE="x86? ( cpu_flags_x86_sse2 )"

QA_PREBUILT="
	opt/${P}/bin/*-${PV}
	opt/${P}/lib/*.so
	opt/${P}/lib/rustlib/*/bin/*
	opt/${P}/lib/rustlib/*/lib/*.so
	opt/${P}/lib/rustlib/*/lib/*.rlib*
"

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]] && [[ ${CHOST} == armv7* ]]; then
		die "${CHOST} is not supported by upstream Rust. You must use a hard float version."
	fi
}

src_unpack() {
	default
	mv "${WORKDIR}/${MY_P}-$(rust_abi)" "${S}" || die
}

multilib_src_install() {
	if multilib_is_native_abi; then

	# start native abi install
	pushd "${S}" >/dev/null || die
	local analysis std
	analysis="$(grep 'analysis' ./components)"
	std="$(grep 'std' ./components)"
	local components="rustc,cargo,${std}"
	use doc && components="${components},rust-docs"
	use clippy && components="${components},clippy-preview"
	use rls && components="${components},rls-preview,${analysis}"
	use rustfmt && components="${components},rustfmt-preview"
	./install.sh \
		--components="${components}" \
		--disable-verify \
		--prefix="${ED}/opt/${P}" \
		--mandir="${ED}/opt/${P}/man" \
		--disable-ldconfig \
		|| die

	local rustc=rustc-bin-${PV}
	local rustdoc=rustdoc-bin-${PV}
	local rustgdb=rust-gdb-bin-${PV}
	local rustgdbgui=rust-gdbgui-bin-${PV}
	local rustlldb=rust-lldb-bin-${PV}

	mv "${ED}/opt/${P}/bin/rustc" "${ED}/opt/${P}/bin/${rustc}" || die
	mv "${ED}/opt/${P}/bin/rustdoc" "${ED}/opt/${P}/bin/${rustdoc}" || die
	mv "${ED}/opt/${P}/bin/rust-gdb" "${ED}/opt/${P}/bin/${rustgdb}" || die
	mv "${ED}/opt/${P}/bin/rust-gdbgui" "${ED}/opt/${P}/bin/${rustgdbgui}" || die
	mv "${ED}/opt/${P}/bin/rust-lldb" "${ED}/opt/${P}/bin/${rustlldb}" || die

	dosym "${rustc}" "/opt/${P}/bin/rustc"
	dosym "${rustdoc}" "/opt/${P}/bin/rustdoc"
	dosym "${rustgdb}" "/opt/${P}/bin/rust-gdb"
	dosym "${rustgdbgui}" "/opt/${P}/bin/rust-gdbgui"
	dosym "${rustlldb}" "/opt/${P}/bin/rust-lldb"

	dosym "../../opt/${P}/bin/${rustc}" "/usr/bin/${rustc}"
	dosym "../../opt/${P}/bin/${rustdoc}" "/usr/bin/${rustdoc}"
	dosym "../../opt/${P}/bin/${rustgdb}" "/usr/bin/${rustgdb}"
	dosym "../../opt/${P}/bin/${rustgdbgui}" "/usr/bin/${rustgdbgui}"
	dosym "../../opt/${P}/bin/${rustlldb}" "/usr/bin/${rustlldb}"

	local cargo=cargo-bin-${PV}
	mv "${ED}/opt/${P}/bin/cargo" "${ED}/opt/${P}/bin/${cargo}" || die
	dosym "${cargo}" "/opt/${P}/bin/cargo"
	dosym "../../opt/${P}/bin/${cargo}" "/usr/bin/${cargo}"

	if use clippy; then
		local clippy_driver=clippy-driver-bin-${PV}
		local cargo_clippy=cargo-clippy-bin-${PV}
		mv "${ED}/opt/${P}/bin/clippy-driver" "${ED}/opt/${P}/bin/${clippy_driver}" || die
		mv "${ED}/opt/${P}/bin/cargo-clippy" "${ED}/opt/${P}/bin/${cargo_clippy}" || die
		dosym "${clippy_driver}" "/opt/${P}/bin/clippy-driver"
		dosym "${cargo_clippy}" "/opt/${P}/bin/cargo-clippy"
		dosym "../../opt/${P}/bin/${clippy_driver}" "/usr/bin/${clippy_driver}"
		dosym "../../opt/${P}/bin/${cargo_clippy}" "/usr/bin/${cargo_clippy}"
	fi
	if use rls; then
		local rls=rls-bin-${PV}
		mv "${ED}/opt/${P}/bin/rls" "${ED}/opt/${P}/bin/${rls}" || die

		dosym "${rls}" "/opt/${P}/bin/rls"
		dosym "../../opt/${P}/bin/${rls}" "/usr/bin/${rls}"
	fi
	if use rustfmt; then
		local rustfmt=rustfmt-bin-${PV}
		local cargo_fmt=cargo-fmt-bin-${PV}
		mv "${ED}/opt/${P}/bin/rustfmt" "${ED}/opt/${P}/bin/${rustfmt}" || die
		mv "${ED}/opt/${P}/bin/cargo-fmt" "${ED}/opt/${P}/bin/${cargo_fmt}" || die
		dosym "${rustfmt}" "/opt/${P}/bin/rustfmt"
		dosym "${cargo_fmt}" "/opt/${P}/bin/cargo-fmt"
		dosym "../../opt/${P}/bin/${rustfmt}" "/usr/bin/${rustfmt}"
		dosym "../../opt/${P}/bin/${cargo_fmt}" "/usr/bin/${cargo_fmt}"
	fi

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/opt/${P}/lib"
	MANPATH="/opt/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	# note: eselect-rust adds EROOT to all paths below
	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	/usr/bin/rust-gdbgui
	/usr/bin/rust-lldb
	EOF
	echo /usr/bin/cargo >> "${T}/provider-${P}"
	if use clippy; then
		echo /usr/bin/clippy-driver >> "${T}/provider-${P}"
		echo /usr/bin/cargo-clippy >> "${T}/provider-${P}"
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
	popd >/dev/null || die
	#end native abi install

	else
		local rust_target
		rust_target="$(rust_abi $(get_abi_CHOST ${v##*.}))"
		dodir "/opt/${P}/lib/rustlib"
		cp -vr "${WORKDIR}/rust-${PV}-${rust_target}/rust-std-${rust_target}/lib/rustlib/${rust_target}"\
			"${ED}/opt/${P}/lib/rustlib" || die
	fi
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-bin-${PV},"

	if has_version app-editors/emacs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if use elibc_musl; then
		ewarn "${PN} on *-musl targets is configured with crt-static"
		ewarn ""
		ewarn "you will need to set RUSTFLAGS=\"-C target-feature=-crt-static\" in make.conf"
		ewarn "to use it with portage, otherwise you may see failures like"
		ewarn "error: cannot produce proc-macro for serde_derive as the target "
		ewarn "x86_64-unknown-linux-musl does not support these crate types"
	fi
}

pkg_postrm() {
	eselect rust cleanup
}
