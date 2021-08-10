# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Secure and fast microVMs for serverless computing (static build)"
HOMEPAGE="https://firecracker-microvm.github.io https://github.com/firecracker-microvm/firecracker"
SRC_URI="
	amd64? (
		https://github.com/firecracker-microvm/firecracker/releases/download/v${PV}/firecracker-v${PV}-x86_64.tgz
	)
	arm64? (
		https://github.com/firecracker-microvm/firecracker/releases/download/v${PV}/firecracker-v${PV}-aarch64.tgz
	)"

LICENSE="|| ( Apache-2.0 MIT Apache-2.0-with-LLVM-exceptions ) MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="test strip"

RDEPEND="!app-emulation/firecracker
	acct-group/kvm"

QA_PREBUILT="/usr/bin/firecracker
	/usr/bin/jailer"

S="${WORKDIR}"

pkg_pretend() {
	if use kernel_linux && kernel_is lt 4 14; then
		eerror "Firecracker requires a host kernel of 4.14 or higher."
	elif use kernel_linux; then
		if ! linux_config_exists; then
			eerror "Unable to check your kernel for KVM support"
		else
			CONFIG_CHECK="~KVM ~TUN ~BRIDGE ~VHOST_VSOCK"
			ERROR_KVM="You must enable KVM in your kernel to continue"
			ERROR_KVM_AMD="If you have an AMD CPU, you must enable KVM_AMD in"
			ERROR_KVM_AMD+=" your kernel configuration."
			ERROR_KVM_INTEL="If you have an Intel CPU, you must enable"
			ERROR_KVM_INTEL+=" KVM_INTEL in your kernel configuration."
			ERROR_TUN="You will need the Universal TUN/TAP driver compiled"
			ERROR_TUN+=" into your kernel or loaded as a module to use"
			ERROR_TUN+=" virtual network devices."
			ERROR_BRIDGE="You will also need support for 802.1d"
			ERROR_BRIDGE+=" Ethernet Bridging for some network configurations."
			ERROR_VHOST_VSOCK="To use AF_VSOCK sockets for communication"
			ERROR_VHOST_VSOCK+=" between host and guest, you will need to enable"
			ERROR_VHOST_VSOCK+=" the vhost virtio-vsock driver in your kernel."

			if use amd64 || use amd64-linux; then
				if grep -q AuthenticAMD /proc/cpuinfo; then
					CONFIG_CHECK+=" ~KVM_AMD"
				elif grep -q GenuineIntel /proc/cpuinfo; then
					CONFIG_CHECK+=" ~KVM_INTEL"
				fi
			fi

			# Now do the actual checks setup above
			check_extra_config
		fi
	fi
}

src_compile() { :; }

src_install() {
	if use amd64; then
		my_arch=x86_64
	elif use arm64; then
		my_arch=aarch64
	fi

	newbin "firecracker-v${PV}-${my_arch}" firecracker
	newbin "jailer-v${PV}-${my_arch}" jailer
}
