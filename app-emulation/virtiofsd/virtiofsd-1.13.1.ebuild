# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.7.18
	anstream@0.3.2
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.1
	anstyle@1.0.1
	arc-swap@1.5.0
	atomic-polyfill@0.1.11
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.1
	btree-range-map@0.7.2
	btree-slab@0.6.1
	byteorder@1.4.3
	capng@0.2.2
	cc-traits@2.0.0
	cc@1.0.79
	cfg-if@1.0.0
	clap@4.3.11
	clap_builder@4.3.11
	clap_derive@4.3.2
	clap_lex@0.5.0
	cobs@0.2.3
	colorchoice@1.0.0
	critical-section@1.1.2
	env_logger@0.8.4
	errno-dragonfly@0.1.2
	errno@0.3.1
	error-chain@0.12.4
	futures-channel@0.3.21
	futures-core@0.3.21
	futures-executor@0.3.21
	futures-io@0.3.21
	futures-macro@0.3.21
	futures-sink@0.3.21
	futures-task@0.3.21
	futures-util@0.3.21
	futures@0.3.21
	getrandom@0.2.15
	hash32@0.2.1
	heapless@0.7.16
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.2
	hostname@0.3.1
	humantime@2.1.0
	is-terminal@0.4.9
	itoa@1.0.2
	libc@0.2.155
	libseccomp-sys@0.2.1
	linux-raw-sys@0.4.5
	lock_api@0.4.10
	log@0.4.17
	match_cfg@0.1.0
	memchr@2.5.0
	num_cpus@1.13.1
	num_threads@0.1.6
	once_cell@1.18.0
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	postcard@1.0.6
	ppv-lite86@0.2.20
	proc-macro2@1.0.63
	quote@1.0.29
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	range-traits@0.3.2
	regex-syntax@0.6.27
	regex@1.6.0
	rustc_version@0.4.0
	rustix@0.38.7
	scopeguard@1.2.0
	semver@1.0.18
	serde@1.0.168
	serde_derive@1.0.168
	slab@0.4.7
	smallvec@1.13.2
	spin@0.9.8
	stable_deref_trait@1.2.0
	strsim@0.10.0
	syn@1.0.98
	syn@2.0.32
	syslog@6.1.1
	termcolor@1.1.3
	thiserror-impl@1.0.41
	thiserror@1.0.41
	time@0.3.11
	unicode-ident@1.0.2
	utf8parse@0.2.1
	uuid-macro-internal@1.11.0
	uuid@1.11.0
	version_check@0.9.4
	vhost-user-backend@0.17.0
	vhost@0.13.0
	virtio-bindings@0.2.4
	virtio-queue@0.14.0
	vm-memory@0.16.0
	vmm-sys-util@0.12.1
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo

DESCRIPTION="Shared file system for virtual machines"
HOMEPAGE="https://virtio-fs.gitlab.io/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/virtio-fs/virtiofsd.git"
	EGIT_BRANCH="main"
else
	SRC_URI="
		https://gitlab.com/virtio-fs/virtiofsd/-/archive/v${PV}/virtiofsd-v${PV}.tar.bz2
		${CARGO_CRATE_URIS}
	"
	KEYWORDS="amd64 ppc64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="Apache-2.0 BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT Unicode-DFS-2016"
SLOT="0"

DEPEND="
	sys-libs/libcap-ng
	sys-libs/libseccomp
"
RDEPEND="
	sys-apps/shadow
	${DEPEND}
"

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

	# Install 50-virtiofsd.json but to avoid conflicts with
	# <app-emulation/qemu-8.0.0 install it under different name. In this case,
	# smaller number means higher priority, but that's probably what users want
	# anyway if they install this package on top of app-emulation/qemu.
	# TODO: remove once old QEMUs are removed from the portage.
	insinto "/usr/share/qemu/vhost-user"
	newins "50-virtiofsd.json" "40-virtiofsd.json"
}
