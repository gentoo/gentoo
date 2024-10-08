# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic bash-completion-r1 edo optfeature systemd toolchain-funcs

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dracut-ng/dracut-ng"
else
	if [[ "${PV}" != *_rc* ]]; then
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"
	fi
	SRC_URI="https://github.com/dracut-ng/dracut-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-ng-${PV}"
fi

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="https://github.com/dracut-ng/dracut-ng/wiki"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux test"
RESTRICT="test"
PROPERTIES="test? ( test_privileged test_network )"

RDEPEND="
	app-alternatives/cpio
	>=app-shells/bash-4.0:0
	sys-apps/coreutils[xattr(-)]
	>=sys-apps/kmod-23[tools]
	|| (
		>=sys-apps/sysvinit-2.87-r3
		sys-apps/openrc[sysv-utils(-),selinux?]
		sys-apps/openrc-navi[sysv-utils(-),selinux?]
		sys-apps/systemd[sysv-utils]
		sys-apps/s6-linux-init[sysv-utils(-)]
	)
	>=sys-apps/util-linux-2.21
	virtual/pkgconfig[native-symlinks(+)]
	virtual/udev

	elibc_musl? ( sys-libs/fts-standalone )
	selinux? (
		sec-policy/selinux-dracut
		sys-libs/libselinux
		sys-libs/libsepol
	)
"
DEPEND="
	>=sys-apps/kmod-23
	elibc_musl? ( sys-libs/fts-standalone )
"

BDEPEND="
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.5
	>=app-text/docbook-xsl-stylesheets-1.75.2
	>=dev-libs/libxslt-1.1.26
	virtual/pkgconfig
	test? (
		net-nds/rpcbind
		net-fs/nfs-utils
		sys-block/open-iscsi
		sys-fs/btrfs-progs
		sys-fs/dmraid
		sys-fs/lvm2[lvm,thin]
		sys-fs/mdadm
		sys-fs/multipath-tools
		alpha? ( app-emulation/qemu[qemu_softmmu_targets_alpha] )
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		arm? ( app-emulation/qemu[qemu_softmmu_targets_arm] )
		arm64? ( app-emulation/qemu[qemu_softmmu_targets_aarch64] )
		hppa? ( app-emulation/qemu[qemu_softmmu_targets_hppa] )
		loong? ( app-emulation/qemu[qemu_softmmu_targets_loongarch64] )
		mips? ( || (
			app-emulation/qemu[qemu_softmmu_targets_mips]
			app-emulation/qemu[qemu_softmmu_targets_mips64]
			app-emulation/qemu[qemu_softmmu_targets_mips64el]
		) )
		ppc? ( app-emulation/qemu[qemu_softmmu_targets_ppc] )
		ppc64? ( app-emulation/qemu[qemu_softmmu_targets_ppc64] )
		riscv? ( || (
			app-emulation/qemu[qemu_softmmu_targets_riscv32]
			app-emulation/qemu[qemu_softmmu_targets_riscv64]
		) )
		sparc? ( || (
			app-emulation/qemu[qemu_softmmu_targets_sparc]
			app-emulation/qemu[qemu_softmmu_targets_sparc64]
		) )
		x86? ( app-emulation/qemu[qemu_softmmu_targets_i386] )
	)
"

QA_MULTILIB_PATHS="usr/lib/dracut/.*"

PATCHES=(
	"${FILESDIR}"/gentoo-ldconfig-paths-r1.patch
	# Gentoo specific acct-user and acct-group conf adjustments
	"${FILESDIR}"/${PN}-103-acct-user-group-gentoo.patch
	# https://github.com/dracut-ng/dracut-ng/pull/507
	"${FILESDIR}"/${PN}-103-systemd-udev-256-kmod.patch
	# libsystemd-core is sometimes missing
	"${FILESDIR}"/${PN}-103-always-install-libsystemd.patch
)

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		--bashcompletiondir="$(get_bashcompdir)"
		--systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	# this emulates what the build system would be doing without us
	append-cflags -D_FILE_OFFSET_BITS=64

	tc-export CC PKG_CONFIG

	edo ./configure "${myconf[@]}"
}

src_test() {
	addwrite /dev/kvm
	# Translate ARCH so run-qemu can find the correct qemu-system-ARCH
	local qemu_arch
	if use amd64; then
		qemu_arch=x86_64
	elif use arm64; then
		qemu_arch=aarch64
	elif use loong; then
		qemu_arch=loongarch64
	elif use x86; then
		qemu_arch=i386
	else
		qemu_arch=$(tc-arch)
	fi
	ARCH=${qemu_arch} emake -C test check
}

src_install() {
	local DOCS=(
		AUTHORS
		NEWS.md
		README.md
		docs/HACKING.md
		docs/README.cross
		docs/README.kernel
		docs/RELEASE.md
		docs/SECURITY.md
	)

	default

	docinto html
	dodoc dracut.html
}

pkg_postinst() {
	optfeature "Networking support" net-misc/networkmanager
	optfeature "Legacy networking support" net-misc/curl "net-misc/dhcp[client]" \
		sys-apps/iproute2 "net-misc/iputils[arping]"
	optfeature "Scan for Btrfs on block devices"  sys-fs/btrfs-progs
	optfeature "Load kernel modules and drop this privilege for real init" \
		sys-libs/libcap
	optfeature "Support CIFS" net-fs/cifs-utils
	optfeature "Decrypt devices encrypted with cryptsetup/LUKS" \
		"sys-fs/cryptsetup[-static-libs]"
	optfeature "Support for GPG-encrypted keys for crypt module" \
		app-crypt/gnupg
	optfeature \
		"Allows use of dash instead of default bash (on your own risk)" \
		app-shells/dash
	optfeature \
		"Allows use of busybox instead of default bash (on your own risk)" \
		sys-apps/busybox
	optfeature "Support iSCSI" sys-block/open-iscsi
	optfeature "Support Logical Volume Manager" sys-fs/lvm2[lvm]
	optfeature "Support MD devices, also known as software RAID devices" \
		sys-fs/mdadm sys-fs/dmraid
	optfeature "Support Device Mapper multipathing" sys-fs/multipath-tools
	optfeature "Plymouth boot splash"  '>=sys-boot/plymouth-0.8.5-r5'
	optfeature "Support network block devices" sys-block/nbd
	optfeature "Support NFS" net-fs/nfs-utils net-nds/rpcbind
	optfeature \
		"Install ssh and scp along with config files and specified keys" \
		virtual/openssh
	optfeature "Enable logging with rsyslog" app-admin/rsyslog
	optfeature "Support Squashfs" sys-fs/squashfs-tools
	optfeature "Support TPM 2.0 TSS" app-crypt/tpm2-tools
	optfeature "Support Bluetooth (experimental)" net-wireless/bluez
	optfeature "Support BIOS-given device names" sys-apps/biosdevname
	optfeature "Support network NVMe" sys-apps/nvme-cli app-misc/jq
	optfeature \
		"Enable rngd service to help generating entropy early during boot" \
		sys-apps/rng-tools
	optfeature "building Unified Kernel Images with dracut (--uefi)" \
		"sys-apps/systemd[boot]" "sys-apps/systemd-utils[boot]"
	optfeature "automatically generating an initramfs on each kernel installation" \
		"sys-kernel/installkernel[dracut]"
	optfeature "automatically generating an UKI on each kernel installation" \
		"sys-kernel/installkernel[dracut,uki]"
}
