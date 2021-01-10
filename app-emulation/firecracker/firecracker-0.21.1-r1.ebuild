# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.8
backtrace-0.3.44
backtrace-sys-0.1.32
bitflags-1.2.1
cc-1.0.50
cfg-if-0.1.10
cpuid-0.1.0
device_tree-1.1.0
epoll-4.1.0
itoa-0.4.5
kernel-0.1.0
kvm-bindings-0.2.0
kvm-ioctls-0.5.0
lazy_static-1.4.0
libc-0.2.66
log-0.4.8
logger-0.1.0
memchr-2.3.2
proc-macro2-1.0.8
quote-1.0.2
regex-1.3.4
regex-syntax-0.6.14
rustc-demangle-0.1.16
ryu-1.0.2
seccomp-0.1.0
serde-1.0.104
serde_derive-1.0.104
serde_json-1.0.48
syn-1.0.14
thread_local-1.0.1
timerfd-1.1.1
unicode-xid-0.2.0
vm-memory-0.1.0
vmm-sys-util-0.4.0
"

inherit cargo linux-info toolchain-funcs

DESCRIPTION="Secure and fast microVMs for serverless computing"
HOMEPAGE="https://firecracker-microvm.github.io https://github.com/firecracker-microvm/firecracker"
SRC_URI="https://github.com/firecracker-microvm/firecracker/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( Apache-2.0 MIT Apache-2.0-with-LLVM-exceptions ) MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RESTRICT="test"

BDEPEND="acct-group/kvm"

QA_FLAGS_IGNORED='.*'

set_target_arch() {
	case "$(tc-arch)" in
		amd64) target_arch=x86_64 ;;
		arm64)   target_arch=aarch64 ;;
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

src_install() {
	local target_arch
	set_target_arch
	dobin "${S}"/build/cargo_target/${target_arch}-unknown-linux-gnu/release/${PN}
	dobin "${S}"/build/cargo_target/${target_arch}-unknown-linux-gnu/release/jailer
}
