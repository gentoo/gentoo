# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES=""

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
	local myfeatures=( no-self-update )
	cargo_src_configure
}

src_compile() {
	export OPENSSL_NO_VENDOR=true
	cargo_src_compile
}

src_install() {
	cargo_src_install
	einstalldocs
	exeinto /usr/share/rustup
	newexe "$(prefixify_ro "${FILESDIR}"/symlink_rustup.sh)" symlink_rustup

	ln -s "${ED}/usr/bin/rustup-init" rustup || die
	./rustup completions bash rustup > "${T}/rustup" || die
	./rustup completions zsh rustup > "${T}/_rustup" || die

	dobashcomp "${T}/rustup"

	insinto /usr/share/zsh/site-functions
	doins "${T}/_rustup"
}

pkg_postinst() {
		einfo "No rustup toolchains installed by default"
		einfo "system rust toolchain can be added to rustup by running"
		einfo "helper script installed to ${EPREFIX}/usr/share/rustup/symlink_rustup"
		einfo "it will create proper symlinks in user home directory"
		einfo "and rustup updates will be managed by portage"
		einfo "please delete current rustup installation (if any) before running the script"
}
