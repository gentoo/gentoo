# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.9
argparse-0.2.2
base32-0.4.0
bitflags-1.0.4
cc-1.0.28
cfg-if-0.1.6
cloudabi-0.0.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
lazy_static-1.2.0
libc-0.2.45
libc-0.2.45
memchr-2.1.2
nitrocli-0.2.2
nitrokey-0.3.1
nitrokey-sys-3.4.1
nitrokey-test-0.1.1
proc-macro2-0.4.24
quote-0.6.10
rand-0.6.1
rand-0.6.1
rand_chacha-0.1.0
rand_core-0.3.0
rand_hc-0.1.0
rand_isaac-0.1.0
rand_pcg-0.1.1
rand_xorshift-0.1.0
regex-1.1.0
regex-syntax-0.6.4
rustc_version-0.2.3
semver-0.9.0
semver-parser-0.7.0
syn-0.15.23
thread_local-0.3.6
ucd-util-0.1.3
unicode-xid-0.1.0
utf8-ranges-1.0.2
version_check-0.1.5
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

# Uses a plugged-in Nitrokey and runs tests on it. These tests assumes a
# pristine configuration and will modify the device's state. Not meant
# to be run as part of the installation.
RESTRICT="test"
QA_FLAGS_IGNORED="/usr/bin/nitrocli"

src_install() {
	cargo_src_install --path=.

	einstalldocs
	doman "${S}/doc/nitrocli.1"
}
