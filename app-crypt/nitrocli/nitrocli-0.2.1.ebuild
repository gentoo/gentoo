# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
argparse-0.2.2
bitflags-1.0.4
cc-1.0.28
cloudabi-0.0.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
libc-0.2.45
nitrocli-0.2.1
nitrokey-0.2.3
nitrokey-sys-3.4.1
rand-0.6.1
rand_chacha-0.1.0
rand_core-0.3.0
rand_hc-0.1.0
rand_isaac-0.1.0
rand_pcg-0.1.1
rand_xorshift-0.1.0
rustc_version-0.2.3
rustc_version-0.2.3
semver-0.9.0
semver-parser-0.7.0
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
	cargo_src_install --path=.

	einstalldocs
	doman "${S}/doc/nitrocli.1"
}
