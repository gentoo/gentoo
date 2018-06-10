# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1 versionator toolchain-funcs

MY_P="rust-${PV}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"
SRC_URI="amd64? ( https://static.rust-lang.org/dist/${MY_P}-x86_64-unknown-linux-gnu.tar.xz )
	arm? (
		https://static.rust-lang.org/dist/${MY_P}-arm-unknown-linux-gnueabi.tar.xz
		https://static.rust-lang.org/dist/${MY_P}-arm-unknown-linux-gnueabihf.tar.xz
		https://static.rust-lang.org/dist/${MY_P}-armv7-unknown-linux-gnueabihf.tar.xz
		)
	x86? ( https://static.rust-lang.org/dist/${MY_P}-i686-unknown-linux-gnu.tar.xz )"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

CARGO_DEPEND_VERSION="0.$(($(get_version_component_range 2) + 1)).0"

DEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
	!dev-lang/rust:0
"
RDEPEND="${DEPEND}"
PDEPEND=">=dev-util/cargo-${CARGO_DEPEND_VERSION}"

QA_PREBUILT="
	opt/${P}/bin/rustc-bin-${PV}
	opt/${P}/bin/rustdoc-bin-${PV}
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

	local postfix
	use amd64 && postfix=x86_64-unknown-linux-gnu

	if use arm && [[ "$(tc-is-softfloat)" != "no" ]] && [[ ${CHOST} == armv6* ]]; then
		postfix=arm-unknown-linux-gnueabi
	elif use arm && [[ ${CHOST} == armv6*h* ]]; then
		postfix=arm-unknown-linux-gnueabihf
	elif use arm && [[ ${CHOST} == armv7*h* ]]; then
		postfix=armv7-unknown-linux-gnueabihf
	fi

	use x86 && postfix=i686-unknown-linux-gnu
	mv "${WORKDIR}/${MY_P}-${postfix}" "${S}" || die
}

src_install() {
	local std=$(grep 'std' ./components)
	local components="rustc,${std}"
	use doc && components="${components},rust-docs"
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

	mv "${D}/opt/${P}/bin/rustc" "${D}/opt/${P}/bin/${rustc}" || die
	mv "${D}/opt/${P}/bin/rustdoc" "${D}/opt/${P}/bin/${rustdoc}" || die
	mv "${D}/opt/${P}/bin/rust-gdb" "${D}/opt/${P}/bin/${rustgdb}" || die

	dosym "../../opt/${P}/bin/${rustc}" "/usr/bin/${rustc}"
	dosym "../../opt/${P}/bin/${rustdoc}" "/usr/bin/${rustdoc}"
	dosym "../../opt/${P}/bin/${rustgdb}" "/usr/bin/${rustgdb}"

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/opt/${P}/lib"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	EOF
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
