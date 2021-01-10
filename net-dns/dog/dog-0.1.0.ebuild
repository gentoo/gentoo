# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
ansi_term-0.12.1
atty-0.2.14
autocfg-1.0.1
bitflags-1.2.1
byteorder-1.3.4
cc-1.0.61
cfg-if-0.1.10
core-foundation-0.7.0
core-foundation-sys-0.7.0
ctor-0.1.16
datetime-0.5.1
difference-2.0.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
getopts-0.2.21
getrandom-0.1.15
hermit-abi-0.1.17
httparse-1.3.4
ipconfig-0.2.2
itoa-0.4.6
lazy_static-1.4.0
libc-0.2.80
log-0.4.11
native-tls-0.2.4
openssl-0.10.30
openssl-probe-0.1.2
openssl-sys-0.9.58
output_vt100-0.1.2
pkg-config-0.3.19
ppv-lite86-0.2.10
pretty_assertions-0.6.1
proc-macro2-1.0.24
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.57
regex-1.4.2
regex-syntax-0.6.21
remove_dir_all-0.5.3
ryu-1.0.5
schannel-0.1.19
security-framework-0.4.4
security-framework-sys-0.4.3
serde-1.0.117
serde_json-1.0.59
socket2-0.3.15
syn-1.0.48
tempfile-3.1.0
unicode-width-0.1.8
unicode-xid-0.2.1
vcpkg-0.2.10
wasi-0.9.0+wasi-snapshot-preview1
widestring-0.4.3
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.6.2
"

inherit cargo

DESCRIPTION="A command-line DNS client like dig"
HOMEPAGE="https://dns.lookup.dog https://github.com/ogham/dog"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/ogham/dog/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.2 Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT Unlicense unicode"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
	!sys-apps/dog
"
DEPEND="
	${RUST_DEPEND}
	dev-go/go-md2man
	${RDEPEND}
"
QA_FLAGS_IGNORED="/usr/bin/dog"

src_prepare() {
	default
	sed -e '/mutagen/d' -e '/features/d' -i dns/Cargo.toml || die
	go-md2man -in man/dog.1.md -out dog.1 || die
	rm -rf man || die
}

src_configure() {
	local myfeatures=(
		$(usex ssl tls '')
		$(usex ssl https '')
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install
	doman dog.1
}
