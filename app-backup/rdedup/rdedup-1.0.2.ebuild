# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.5.3
argparse-0.2.1
env_logger-0.3.5
flate2-0.2.17
fs2-0.2.5
gcc-0.3.43
kernel32-sys-0.2.2
libc-0.2.20
libsodium-sys-0.0.12
log-0.3.6
memchr-0.1.11
miniz-sys-0.1.9
pkg-config-0.3.9
rand-0.3.15
rdedup-lib-1.0.2
regex-0.1.80
regex-syntax-0.3.9
rollsum-0.2.1
rpassword-0.2.3
rust-crypto-0.2.36
rustc-serialize-0.3.22
serde-0.7.15
sodiumoxide-0.0.12
termios-0.2.2
thread-id-2.0.0
thread_local-0.2.7
time-0.1.36
utf8-ranges-0.1.3
winapi-0.2.8
winapi-build-0.1.1
rdedup-1.0.2
rdedup-lib-1.0.2
redox_syscall-0.1.16
"

inherit cargo

DESCRIPTION="data deduplication with compression and public key encryption"
HOMEPAGE="https://github.com/dpc/rdedup"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/libsodium-1.0.11:="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	ln -sf "${WORKDIR}/cargo_home/gentoo/rdedup-lib-${PV}" lib || die
}

src_install() {
	cargo_src_install
	dodoc {CHANGELOG,README}.md
}
