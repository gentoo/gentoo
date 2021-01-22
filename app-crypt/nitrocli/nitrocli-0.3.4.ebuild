# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
anyhow-1.0.32
base32-0.4.0
bitflags-1.2.1
cc-1.0.50
cfg-if-0.1.10
clap-2.33.0
getrandom-0.1.14
heck-0.3.1
lazy_static-1.4.0
libc-0.2.69
memchr-2.3.3
nitrocli-0.3.4
nitrokey-0.7.1
nitrokey-sys-3.5.0
nitrokey-test-0.4.0
nitrokey-test-state-0.1.0
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro2-1.0.19
quote-1.0.3
rand_core-0.5.1
regex-1.3.7
regex-syntax-0.6.17
structopt-0.3.13
structopt-derive-0.4.6
syn-1.0.36
syn-mid-0.5.0
textwrap-0.11.0
thread_local-1.0.1
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
version_check-0.9.1
wasi-0.9.0+wasi-snapshot-preview1
"

inherit bash-completion-r1 cargo

DESCRIPTION="A command line tool for interacting with Nitrokey devices"
HOMEPAGE="https://github.com/d-e-s-o/nitrocli.git"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 GPL-3+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

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
	cargo_src_install --bin=nitrocli

	target/release/shell-complete > nitrocli.bash || die
	newbashcomp nitrocli.bash ${PN}

	einstalldocs
	doman "doc/nitrocli.1"
}
