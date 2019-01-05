# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
argparse-0.2.2
bitflags-1.0.4
cc-1.0.25
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
libc-0.2.45
nitrocli-0.2.0
nitrokey-0.2.1
nitrokey-sys-3.4.1
rand-0.4.3
winapi-0.3.6
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A command line application for interacting with Nitrokey devices"
HOMEPAGE="https://github.com/d-e-s-o/nitrocli"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

BDEPEND="
	>=dev-lang/rust-1.31.0
"
DEPEND="
	dev-libs/hidapi
"
# We require gnupg for /usr/bin/gpg-connect-agent.
RDEPEND="
	${DEPEND}
	app-crypt/gnupg
"

QA_FLAGS_IGNORED="/usr/bin/nitrocli"

src_install() {
	cargo install -j $(makeopts_jobs) --path=. --root="${D}/usr" $(usex debug --debug "") \
		|| die "cargo install failed"
	rm "${D}/usr/.crates.toml" || die "failed to remove .crates.toml"

	einstalldocs
	doman "${S}/doc/nitrocli.1"
}

src_test() {
	cargo test -j $(makeopts_jobs) $(usex debug "" --release) -v || die "cargo test failed"
}
