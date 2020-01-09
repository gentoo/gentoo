# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
argparse-0.2.2
base32-0.4.0
cc-1.0.48
cfg-if-0.1.10
getrandom-0.1.13
lazy_static-1.4.0
libc-0.2.66
memchr-2.2.1
nitrocli-0.3.1
nitrokey-0.4.0
nitrokey-sys-3.5.0
nitrokey-test-0.3.2
nitrokey-test-state-0.1.0
proc-macro2-1.0.7
quote-1.0.2
rand_core-0.5.1
regex-1.3.1
regex-syntax-0.6.12
syn-1.0.13
thread_local-0.3.6
unicode-xid-0.2.0
wasi-0.7.0
"

inherit cargo

DESCRIPTION="A command line tool for interacting with Nitrokey devices."
HOMEPAGE="https://github.com/d-e-s-o/nitrocli/tree/master/nitrocli"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 GPL-3+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

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
	cargo_src_install

	einstalldocs
	doman "doc/nitrocli.1"
}
