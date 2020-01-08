# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.10
backtrace-0.3.35
backtrace-sys-0.1.31
base64-0.9.3
bitflags-0.5.0
bitflags-1.1.0
byteorder-1.2.1
bytes-0.4.12
c2-chacha-0.2.2
cc-1.0.41
cfg-if-0.1.9
clap-2.33.0
cpuid-0.1.0
device_tree-1.1.0
epoll-4.0.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.18
futures-cpupool-0.1.8
getrandom-0.1.11
getrandom_package-0.1.20
glob-0.2.11
httparse-1.3.4
hyper-0.11.16
iovec-0.1.2
ipnetwork-0.14.0
itoa-0.4.4
kernel-0.1.0
kernel32-sys-0.2.2
kvm-bindings-0.1.1
kvm-ioctls-0.2.0
language-tags-0.2.2
lazy_static-1.4.0
libc-0.2.62
log-0.3.9
log-0.4.8
logger-0.1.0
memchr-2.2.1
mime-0.3.13
mio-0.6.19
mio-uds-0.6.7
miow-0.2.1
net2-0.2.33
num_cpus-1.10.1
percent-encoding-1.0.1
pnet-0.22.0
pnet_base-0.22.0
pnet_datalink-0.22.0
pnet_macros-0.22.0
pnet_macros_support-0.22.0
pnet_packet-0.22.0
pnet_sys-0.22.0
pnet_transport-0.22.0
ppv-lite86-0.2.5
proc-macro2-1.0.2
quote-1.0.2
rand-0.7.0
rand_chacha-0.2.1
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.0.6
regex-syntax-0.6.11
relay-0.1.1
remove_dir_all-0.5.2
rustc-demangle-0.1.16
rustc-serialize-0.3.24
ryu-1.0.0
safemem-0.3.2
scoped-tls-0.1.2
seccomp-0.1.0
serde-1.0.99
serde_derive-1.0.99
serde_json-1.0.40
slab-0.4.2
syn-1.0.5
syntex-0.42.2
syntex_errors-0.42.0
syntex_pos-0.42.0
syntex_syntax-0.42.0
sys_util-0.1.0
tempfile-3.1.0
term-0.4.6
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
timerfd-1.0.0
tokio-core-0.1.12
tokio-io-0.1.5
tokio-service-0.1.0
tokio-uds-0.1.7
unicase-2.4.0
unicode-width-0.1.6
unicode-xid-0.0.3
unicode-xid-0.2.0
utf8-ranges-1.0.4
version_check-0.1.5
wasi-0.5.0
ws2_32-sys-0.2.1
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
rust-libcore-0.0.3
"

inherit cargo linux-info toolchain-funcs

DESCRIPTION="Secure and fast microVMs for serverless computing"
HOMEPAGE="https://firecracker-microvm.github.io https://github.com/firecracker-microvm/firecracker"
SRC_URI="https://github.com/firecracker-microvm/firecracker/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( Apache-2.0 MIT Apache-2.0-with-LLVM-exceptions ) MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="test"

BDEPEND="acct-group/kvm"

set_target_arch() {
	case "$(tc-arch)" in
		amd64) target_arch=x86_64 ;;
		x86)   target_arch=i686 ;;
	esac
}

pkg_setup() {

	if ! linux_config_exists; then
			eerror "Unable to check your kernel for KVM support"
	else
		        CONFIG_CHECK+=" ~KVM_AMD" || \
			CONFIG_CHECK+=" ~KVM_INTEL"
			ERROR_KVM="${P} requires KVM in-kernel support."
	fi
}

src_compile() {
	local target_arch
	set_target_arch
	cargo_src_compile --target ${target_arch}-unknown-linux-gnu
}
