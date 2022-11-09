# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit bash-completion-r1 cargo prefix

DESCRIPTION="Rust toolchain installer"
HOMEPAGE="https://rust-lang.github.io/rustup/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/${PN}.git"
else
	SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 MIT Unlicense ZLIB"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/xz-utils
	net-misc/curl:=[http2,ssl]
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/.*"

# uses network
RESTRICT="test"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
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
		reqwest-backend
		reqwest-default-tls
	)
	case ${ARCH} in
		ppc*|mips*|riscv*|s390*)
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

	ln -s "${ED}/usr/bin/rustup-init" rustup || die
	./rustup completions bash rustup > "${T}/rustup" || die
	./rustup completions zsh rustup > "${T}/_rustup" || die

	dobashcomp "${T}/rustup"

	insinto /usr/share/zsh/site-functions
	doins "${T}/_rustup"
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
