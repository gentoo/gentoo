# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
anyhow-1.0.32
arrayref-0.3.6
arrayvec-0.5.1
autocfg-1.0.0
base32-0.4.0
base64-0.11.0
bitflags-1.2.1
blake2b_simd-0.5.10
cc-1.0.50
cfg-if-0.1.10
clap-2.33.0
constant_time_eq-0.1.5
crossbeam-utils-0.7.2
directories-3.0.1
dirs-sys-0.3.5
envy-0.4.2
getrandom-0.1.14
heck-0.3.1
lazy_static-1.4.0
libc-0.2.69
memchr-2.3.3
merge-0.1.0
merge_derive-0.1.0
nitrocli-0.3.5
nitrokey-0.7.1
nitrokey-sys-3.5.0
nitrokey-test-0.4.0
nitrokey-test-state-0.1.0
num-traits-0.2.12
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro2-1.0.19
quote-1.0.3
rand_core-0.5.1
redox_syscall-0.1.57
redox_users-0.3.4
regex-1.3.7
regex-syntax-0.6.17
rust-argon2-0.7.0
serde-1.0.114
serde_derive-1.0.114
structopt-0.3.17
structopt-derive-0.4.10
syn-1.0.36
syn-mid-0.5.0
textwrap-0.11.0
thread_local-1.0.1
toml-0.5.6
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
version_check-0.9.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A command line tool for interacting with Nitrokey devices"
HOMEPAGE="https://github.com/d-e-s-o/nitrocli.git"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD-2 CC0-1.0 GPL-3+ LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

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
