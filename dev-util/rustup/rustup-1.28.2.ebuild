# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.85.0"
inherit cargo prefix shell-completion toolchain-funcs

DESCRIPTION="Rust toolchain installer"
HOMEPAGE="https://rust-lang.github.io/rustup/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/${PN}.git"
else
	SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CDLA-Permissive-2.0 ISC MIT openssl Unicode-3.0 ZLIB
"
SLOT="0"
# uses network
RESTRICT="test"

DEPEND="
	app-arch/xz-utils
	net-misc/curl:=[http2,ssl]
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"

# rust does not use *FLAGS from make.conf, silence portage warning
QA_FLAGS_IGNORED="usr/bin/rustup-init"

src_unpack() {
	if [[ "${PV}" == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	# modeled after ci/run.bash upstream
	# reqwest-rustls-tls requires ring crate, which is not very portable.
	local myfeatures=(
		no-self-update
		curl-backend
		reqwest-native-tls
	)
	case ${ARCH} in
		ppc* | mips* | riscv* | s390*)
			;;
		*) myfeatures+=( reqwest-rustls-tls )
			;;
	esac
	cargo_src_configure --no-default-features
}

src_compile() {
	export OPENSSL_NO_VENDOR=true
	cargo_src_compile
}

src_install() {
	cargo_src_install
	einstalldocs
	newbin "$(prefixify_ro "${FILESDIR}"/symlink_rustup.sh)" rustup-init-gentoo

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		ln -sf "${ED}/usr/bin/rustup-init" rustup || die

		./rustup completions bash > "${T}/${PN}" || die
		dobashcomp "${T}/${PN}"
		./rustup completions zsh > "${T}/_${PN}" || die
		dozshcomp "${T}/_${PN}"
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completions --help'"
	fi
}

pkg_postinst() {
	elog "No rustup toolchains installed by default"
	elog "eselect activated system rust toolchain can be added to rustup by running"
	elog "helper script installed as ${EPREFIX}/usr/bin/rustup-init-gentoo"
	elog "it will create symlinks to system-installed rustup in home directory"
	elog "and rustup updates will be managed by portage"
	elog "please delete current rustup binaries from ~/.cargo/bin/ (if any)"
	elog "before running rustup-init-gentoo"
}
