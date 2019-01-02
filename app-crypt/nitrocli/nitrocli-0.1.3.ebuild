# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
cc-1.0.25
hid-0.4.1
hidapi-sys-0.1.4
libc-0.2.45
nitrocli-0.1.3
pkg-config-0.3.14
"

inherit cargo

DESCRIPTION="A command line tool for interacting with the Nitrokey Storage"
HOMEPAGE="https://github.com/d-e-s-o/nitrocli"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

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

# Requires a Nitrokey in pristine configuration.
RESTRICT="test"
QA_FLAGS_IGNORED="/usr/bin/nitrocli"

src_install() {
	cargo install -j $(makeopts_jobs) --path=. --root="${D}/usr" $(usex debug --debug "") \
		|| die "cargo install failed"
	rm "${D}/usr/.crates.toml" || die "failed to remove .crates.toml"

	einstalldocs
	doman "${S}/doc/nitrocli.1"
}
