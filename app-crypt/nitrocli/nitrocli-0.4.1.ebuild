# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
aho-corasick-0.7.18
anyhow-1.0.40
autocfg-1.0.1
base32-0.4.0
bitflags-1.2.1
cc-1.0.67
cfg-if-1.0.0
clap-2.33.3
directories-3.0.2
dirs-sys-0.3.6
envy-0.4.2
getrandom-0.1.16
getrandom-0.2.2
heck-0.3.2
lazy_static-1.4.0
libc-0.2.94
log-0.4.14
memchr-2.4.0
merge-0.1.0
merge_derive-0.1.0
nitrocli-0.4.1
nitrokey-0.9.0
nitrokey-sys-3.6.0
nitrokey-test-0.5.0
nitrokey-test-state-0.1.0
num-traits-0.2.14
numtoa-0.1.0
ppv-lite86-0.2.10
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.26
progressing-3.0.2
quote-1.0.9
rand-0.8.3
rand_chacha-0.3.0
rand_core-0.5.1
rand_core-0.6.2
rand_hc-0.3.0
redox_syscall-0.2.8
redox_termios-0.1.2
redox_users-0.4.0
regex-1.5.4
regex-syntax-0.6.25
remove_dir_all-0.5.3
serde-1.0.125
serde_derive-1.0.125
structopt-0.3.21
structopt-derive-0.4.14
syn-1.0.72
tempfile-3.2.0
termion-1.5.6
textwrap-0.11.0
toml-0.5.8
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.2
version_check-0.9.3
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A command line tool for interacting with Nitrokey devices"
HOMEPAGE="https://github.com/d-e-s-o/nitrocli"
SRC_URI="$(cargo_crate_uris)"

LICENSE="Apache-2.0 BSD-2 CC0-1.0 GPL-3+ LGPL-3 MIT"
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
QA_FLAGS_IGNORED="usr/bin/nitrocli"

src_compile() {
	cargo_src_compile --bin=nitrocli
	# Install shell-complete binary into source directory to be able to
	# use it later on.
	cargo install --bin=shell-complete --path . --root "${S}" || die
}

src_install() {
	cargo_src_install --bin=nitrocli

	"${S}"/bin/shell-complete bash > ${PN}.bash || die
	newbashcomp ${PN}.bash ${PN}

	"${S}"/bin/shell-complete fish > ${PN}.fish || die
	insinto /usr/share/fish/vendor_conf.d/
	insopts -m0755
	doins ${PN}.fish

	einstalldocs
	doman doc/${PN}.1
}
