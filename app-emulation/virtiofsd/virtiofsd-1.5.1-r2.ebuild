# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ansi_term-0.12.1
	arc-swap-1.5.0
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	capng-0.2.2
	cc-1.0.78
	cfg-if-1.0.0
	clap-2.34.0
	env_logger-0.10.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	error-chain-0.12.4
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	heck-0.3.3
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hostname-0.3.1
	humantime-2.1.0
	io-lifetimes-1.0.4
	is-terminal-0.4.2
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.139
	libseccomp-sys-0.2.1
	linux-raw-sys-0.1.4
	log-0.4.17
	match_cfg-0.1.0
	memchr-2.5.0
	num_cpus-1.13.1
	num_threads-0.1.6
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.40
	quote-1.0.20
	regex-1.6.0
	regex-syntax-0.6.27
	rustix-0.36.7
	slab-0.4.7
	strsim-0.8.0
	structopt-0.3.26
	structopt-derive-0.4.18
	syn-1.0.98
	syslog-6.0.1
	termcolor-1.1.3
	textwrap-0.11.0
	time-0.3.11
	unicode-ident-1.0.2
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	vec_map-0.8.2
	version_check-0.9.4
	vhost-0.6.0
	vhost-user-backend-0.8.0
	virtio-bindings-0.1.0
	virtio-queue-0.7.0
	vm-memory-0.10.0
	vmm-sys-util-0.11.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
"

inherit cargo

DESCRIPTION="Shared file system for virtual machines"
HOMEPAGE="https://virtio-fs.gitlab.io/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/virtio-fs/virtiofsd.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://gitlab.com/virtio-fs/virtiofsd/-/archive/v${PV}/virtiofsd-v${PV}.tar.gz
			$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016 Unlicense"
SLOT="0"

DEPEND="
	sys-libs/libcap-ng
	sys-libs/libseccomp
"
RDEPEND="${DEPEND}"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/libexec/${PN}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	cargo_src_install

	mkdir "${ED}/usr/libexec" || die
	mv "${ED}/usr/"{bin,libexec}/${PN} || die

	# Install 50-qemu-virtiofsd.json but to avoid conflicts with
	# <app-emulation/qemu-8.0.0 install it under different name. In this case,
	# smaller number means higher priority, but that's probably what users want
	# anyway if they install this package on top of app-emulation/qemu.
	# TODO: remove once old QEMUs are removed from the portage.
	insinto "/usr/share/qemu/vhost-user"
	newins "50-qemu-virtiofsd.json" "40-qemu-virtiofsd.json"
}
