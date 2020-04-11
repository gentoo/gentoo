# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
base32-0.4.0
bitflags-1.2.1
cc-1.0.48
cfg-if-0.1.10
clap-2.33.0
getrandom-0.1.13
heck-0.3.1
lazy_static-1.4.0
libc-0.2.66
memchr-2.2.1
nitrocli-0.3.2
nitrokey-0.6.0
nitrokey-sys-3.5.0
nitrokey-test-0.3.2
nitrokey-test-state-0.1.0
proc-macro-error-0.4.12
proc-macro-error-attr-0.4.12
proc-macro2-1.0.7
quote-1.0.3
rand_core-0.5.1
regex-1.3.1
regex-syntax-0.6.12
structopt-0.3.12
structopt-derive-0.4.5
syn-1.0.14
syn-mid-0.5.0
textwrap-0.11.0
thread_local-0.3.6
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
version_check-0.9.1
wasi-0.7.0
"

inherit cargo

DESCRIPTION="A command line tool for interacting with Nitrokey devices."
HOMEPAGE="https://github.com/d-e-s-o/nitrocli/tree/master"
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
