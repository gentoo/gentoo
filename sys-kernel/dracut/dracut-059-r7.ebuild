# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 optfeature systemd toolchain-funcs

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dracutdevs/dracut"
else
	if [[ "${PV}" != *_rc* ]]; then
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv sparc x86"
	fi
	SRC_URI="https://github.com/dracutdevs/dracut/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="https://github.com/dracutdevs/dracut/wiki"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/cpio
	>=app-shells/bash-4.0:0
	sys-apps/coreutils[xattr(-)]
	>=sys-apps/kmod-23[tools]
	|| (
		>=sys-apps/sysvinit-2.87-r3
		sys-apps/openrc[sysv-utils(-),selinux?]
		sys-apps/systemd[sysv-utils]
		sys-apps/s6-linux-init[sysv-utils(-)]
	)
	>=sys-apps/util-linux-2.21
	virtual/pkgconfig
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
"

QA_MULTILIB_PATHS="usr/lib/dracut/.*"

PATCHES=(
	"${FILESDIR}"/gentoo-ldconfig-paths-r1.patch
	"${FILESDIR}"/gentoo-network-r1.patch
	"${FILESDIR}"/059-kernel-install-uki.patch
	"${FILESDIR}"/059-uefi-split-usr.patch
	"${FILESDIR}"/059-uki-systemd-254.patch
	"${FILESDIR}"/059-gawk.patch
	"${FILESDIR}"/dracut-059-dmsquash-live.patch
	"${FILESDIR}"/059-systemd-pcrphase.patch
	"${FILESDIR}"/059-systemd-executor.patch
	"${FILESDIR}"/dracut-059-install-new-systemd-hibernate-resume.service.patch
)

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		--bashcompletiondir="$(get_bashcompdir)"
		--systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	tc-export CC PKG_CONFIG

	echo ./configure "${myconf[@]}"
	./configure "${myconf[@]}" || die

	if [[ ${PV} != 9999 && ! -f dracut-version.sh ]] ; then
		# Source tarball from github doesn't include this file
		echo "DRACUT_VERSION=${PV}" > dracut-version.sh || die
	fi
}

src_test() {
	if [[ ${EUID} != 0 ]]; then
		# Tests need root privileges, bug #298014
		ewarn "Skipping tests: Not running as root."
	elif [[ ! -w /dev/kvm ]]; then
		ewarn "Skipping tests: Unable to access /dev/kvm."
	else
		emake -C test check
	fi
}

src_install() {
	local DOCS=(
		AUTHORS
		NEWS.md
		README.md
		docs/README.cross
		docs/README.generic
		docs/README.kernel
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
	optfeature "Support network NVMe" sys-apps/nvme-cli
	optfeature \
		"Enable rngd service to help generating entropy early during boot" \
		sys-apps/rng-tools
}
