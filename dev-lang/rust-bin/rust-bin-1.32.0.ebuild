# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1 rust-toolchain toolchain-funcs

MY_P="rust-${PV}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"
SRC_URI="$(rust_all_arch_uris ${MY_P})"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="clippy cpu_flags_x86_sse2 doc libressl rustfmt"

DEPEND=""
RDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libssh2
	net-misc/curl[ssl]
	!dev-lang/rust:0
	!dev-util/cargo
	rustfmt? ( !dev-util/rustfmt )"
REQUIRED_USE="x86? ( cpu_flags_x86_sse2 )"

QA_PREBUILT="
	opt/${P}/bin/*-${PV}
	opt/${P}/lib/*.so
	opt/${P}/lib/rustlib/*/lib/*.so
	opt/${P}/lib/rustlib/*/lib/*.rlib*
"

pkg_pretend () {
	if [[ "$(tc-is-softfloat)" != "no" ]] && [[ ${CHOST} == armv7* ]]; then
		die "${CHOST} is not supported by upstream Rust. You must use a hard float version."
	fi
}

src_unpack() {
	default
	mv "${WORKDIR}/${MY_P}-$(rust_abi)" "${S}" || die
}

src_install() {
	local std=$(grep 'std' ./components)
	local components="rustc,cargo,${std}"
	use doc && components="${components},rust-docs"
	use clippy && components="${components},clippy-preview"
	use rustfmt && components="${components},rustfmt-preview"
	./install.sh \
		--components="${components}" \
		--disable-verify \
		--prefix="${D}/opt/${P}" \
		--mandir="${D}/usr/share/${P}/man" \
		--disable-ldconfig \
		|| die

	local rustc=rustc-bin-${PV}
	local rustdoc=rustdoc-bin-${PV}
	local rustgdb=rust-gdb-bin-${PV}
	local rustlldb=rust-lldb-bin-${PV}

	mv "${D}/opt/${P}/bin/rustc" "${D}/opt/${P}/bin/${rustc}" || die
	mv "${D}/opt/${P}/bin/rustdoc" "${D}/opt/${P}/bin/${rustdoc}" || die
	mv "${D}/opt/${P}/bin/rust-gdb" "${D}/opt/${P}/bin/${rustgdb}" || die
	mv "${D}/opt/${P}/bin/rust-lldb" "${D}/opt/${P}/bin/${rustlldb}" || die

	dosym "../../opt/${P}/bin/${rustc}" "/usr/bin/${rustc}"
	dosym "../../opt/${P}/bin/${rustdoc}" "/usr/bin/${rustdoc}"
	dosym "../../opt/${P}/bin/${rustgdb}" "/usr/bin/${rustgdb}"
	dosym "../../opt/${P}/bin/${rustlldb}" "/usr/bin/${rustlldb}"

	local cargo=cargo-bin-${PV}
	mv "${D}/opt/${P}/bin/cargo" "${D}/opt/${P}/bin/${cargo}" || die
	dosym "../../opt/${P}/bin/${cargo}" "/usr/bin/${cargo}"
	if use clippy; then
		local clippy_driver=clippy-driver-bin-${PV}
		local cargo_clippy=cargo-clippy-bin-${PV}
		mv "${D}/opt/${P}/bin/clippy-driver" "${D}/opt/${P}/bin/${clippy_driver}" || die
		mv "${D}/opt/${P}/bin/cargo-clippy" "${D}/opt/${P}/bin/${cargo_clippy}" || die
		dosym "../../opt/${P}/bin/${clippy_driver}" "/usr/bin/${clippy_driver}"
		dosym "../../opt/${P}/bin/${cargo_clippy}" "/usr/bin/${cargo_clippy}"
	fi
	if use rustfmt; then
		local rustfmt=rustfmt-bin-${PV}
		local cargo_fmt=cargo-fmt-bin-${PV}
		mv "${D}/opt/${P}/bin/rustfmt" "${D}/opt/${P}/bin/${rustfmt}" || die
		mv "${D}/opt/${P}/bin/cargo-fmt" "${D}/opt/${P}/bin/${cargo_fmt}" || die
		dosym "../../opt/${P}/bin/${rustfmt}" "/usr/bin/${rustfmt}"
		dosym "../../opt/${P}/bin/${cargo_fmt}" "/usr/bin/${cargo_fmt}"
	fi

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/opt/${P}/lib"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	/usr/bin/rust-lldb
	EOF
	echo /usr/bin/cargo >> "${T}/provider-${P}"
	if use clippy; then
		echo /usr/bin/clippy-driver >> "${T}/provider-${P}"
		echo /usr/bin/cargo-clippy >> "${T}/provider-${P}"
	fi
	if use rustfmt; then
		echo /usr/bin/rustfmt >> "${T}/provider-${P}"
		echo /usr/bin/cargo-fmt >> "${T}/provider-${P}"
	fi
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-bin-${PV},"

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
