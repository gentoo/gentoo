# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_pre???????? ]] && \
	COMMIT="19e53b05828a43b7062b67a9cc6c84836ca26439"

CRATES="
ansi_term-0.11.0
approx-0.5.0
async-trait-0.1.51
atty-0.2.14
autocfg-1.0.1
bitflags-1.3.2
bytes-0.5.6
bytes-1.1.0
cc-1.0.70
cfg-if-0.1.10
cfg-if-1.0.0
claim-0.5.0
clap-2.33.3
core-foundation-0.6.4
core-foundation-sys-0.6.2
domain-0.6.1
dtoa-0.4.8
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-channel-0.3.17
futures-core-0.3.17
futures-sink-0.3.17
futures-task-0.3.17
futures-util-0.3.17
getrandom-0.2.3
h2-0.2.7
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
http-0.2.4
http-body-0.3.1
httparse-1.5.1
httpdate-0.3.2
hyper-0.13.10
indexmap-1.7.0
iovec-0.1.4
itoa-0.4.8
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.102
log-0.4.14
memchr-2.4.1
mio-0.6.23
mio-uds-0.6.8
miow-0.2.2
net2-0.2.37
num-traits-0.2.14
once_cell-1.8.0
openssl-0.10.36
openssl-probe-0.1.4
openssl-sys-0.9.66
openssl-src-111.16.0+1.1.1l
pin-project-1.0.8
pin-project-internal-1.0.8
pin-project-lite-0.1.12
pin-project-lite-0.2.7
pin-utils-0.1.0
pkg-config-0.3.19
ppv-lite86-0.2.10
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.29
quote-1.0.9
rand-0.8.4
rand_chacha-0.3.1
rand_core-0.6.3
rand_hc-0.3.1
redox_syscall-0.2.10
remove_dir_all-0.5.3
schannel-0.1.19
security-framework-0.3.4
security-framework-sys-0.3.3
signal-hook-registry-1.4.0
simple_logger-1.13.0
slab-0.4.4
socket2-0.3.19
strsim-0.8.0
structopt-0.3.23
structopt-derive-0.4.16
syn-1.0.76
tempfile-3.2.0
textwrap-0.11.0
tokio-0.2.25
tokio-macros-0.2.6
tokio-tls-0.3.1
tokio-util-0.3.1
tower-service-0.3.1
tracing-0.1.28
tracing-core-0.1.20
tracing-futures-0.2.5
try-lock-0.2.3
unicode-segmentation-1.8.0
unicode-width-0.1.9
unicode-xid-0.2.2
vcpkg-0.2.15
vec_map-0.8.2
version_check-0.9.3
want-0.3.0
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
"

inherit cargo

RUST_NATIVE_TLS_COMMIT="255dd5493b446755a9e40be3a4638afedfe67b03"
DESCRIPTION="Prometheus exporter for Unbound DNS resolver"
HOMEPAGE="https://github.com/svartalf/unbound-telemetry"
SRC_URI="
	https://github.com/svartalf/unbound-telemetry/archive/${COMMIT:-${PV}}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	https://github.com/Goirad/rust-native-tls/archive/${RUST_NATIVE_TLS_COMMIT}.tar.gz -> rust-native-tls-${RUST_NATIVE_TLS_COMMIT}.crate
"
S="${WORKDIR}/${PN}-${COMMIT:-${PV}}"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/unbound-telemetry
	acct-user/unbound-telemetry
"

DOCS=(
	README.md
)

src_prepare() {
	# Ensure Cargo is satisfied with the manually downloaded rust-native-tls
	# Upstream use a fork *and* a certain branch
	sed -i -e '/pkcs8/d' Cargo.toml || die

	default
}

src_install() {
	cargo_src_install

	dodoc "${DOCS[@]}"
	newinitd "${FILESDIR}/initd" "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
}
