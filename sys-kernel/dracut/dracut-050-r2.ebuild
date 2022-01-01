# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 linux-info optfeature systemd toolchain-funcs

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dracutdevs/dracut"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 sparc x86"
	SRC_URI="https://www.kernel.org/pub/linux/utils/boot/${PN}/${P}.tar.xz"
fi

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="https://dracut.wiki.kernel.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux"

# Tests need root privileges, bug #298014
RESTRICT="test"

RDEPEND="
	app-arch/cpio
	>=app-shells/bash-4.0:0
	sys-apps/coreutils[xattr(-)]
	>=sys-apps/kmod-23[tools]
	|| (
		>=sys-apps/sysvinit-2.87-r3
		sys-apps/openrc[sysv-utils(-),selinux?]
		sys-apps/systemd[sysv-utils]
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

DOCS=( AUTHORS HACKING NEWS README.md README.generic README.kernel README.modules
	README.testsuite TODO )

QA_MULTILIB_PATHS="usr/lib/dracut/.*"

PATCHES=(
	"${FILESDIR}"/050-Makefile-merge-main-version-and-git-version-earlier.patch
	"${FILESDIR}"/050-dracut.sh-don-t-call-fsfreeze-on-subvol-of-root-file.patch
	"${FILESDIR}"/050-Makefile-fix-VERSION-again.patch
	"${FILESDIR}"/050-btrfs-force-preload-btrfs-module.patch
	"${FILESDIR}"/050-network-manager-ensure-that-nm-run.sh-is-executed-wh.patch
	"${FILESDIR}"/050-dracut-lib.sh-quote-variables-in-parameter-expansion.patch
	"${FILESDIR}"/050-busybox-module-fix.patch
	"${FILESDIR}"/050-systemd-remove-obsolete-syslog-parameter.patch
	"${FILESDIR}"/050-lvm-fix-removal-of-pvscan-from-udev-rules.patch
	"${FILESDIR}"/gentoo-ldconfig-paths.patch
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

src_install() {
	default

	insinto /etc/logrotate.d
	newins dracut.logrotate dracut

	docinto html
	dodoc dracut.html
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_exists; then
		ewarn ""
		ewarn "If the following test report contains a missing kernel"
		ewarn "configuration option, you should reconfigure and rebuild your"
		ewarn "kernel before booting image generated with this Dracut version."
		ewarn ""

		local CONFIG_CHECK="~BLK_DEV_INITRD ~DEVTMPFS"

		# Kernel configuration options descriptions:
		local ERROR_DEVTMPFS='CONFIG_DEVTMPFS: "Maintain a devtmpfs filesystem to mount at /dev" '
		ERROR_DEVTMPFS+='is missing and REQUIRED'
		local ERROR_BLK_DEV_INITRD='CONFIG_BLK_DEV_INITRD: "Initial RAM filesystem and RAM disk '
		ERROR_BLK_DEV_INITRD+='(initramfs/initrd) support" is missing and REQUIRED'

		check_extra_config
		echo
	else
		ewarn ""
		ewarn "Your kernel configuration couldn't be checked."
		ewarn "Please check manually if following options are enabled:"
		ewarn ""
		ewarn "  CONFIG_BLK_DEV_INITRD"
		ewarn "  CONFIG_DEVTMPFS"
		ewarn ""
	fi

	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	elog ""
	optfeature "Networking support" net-misc/networkmanager
	optfeature "Legacy networking support" net-misc/curl "net-misc/dhcp[client]" \
		sys-apps/iproute2 "net-misc/iputils[arping]"
	optfeature \
		"Measure performance of the boot process for later visualisation" \
		app-benchmarks/bootchart2 app-admin/killproc sys-process/acct
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
	optfeature "Support iSCSI" sys-block/open-iscsi
	optfeature "Support Logical Volume Manager" sys-fs/lvm2
	optfeature "Support MD devices, also known as software RAID devices" \
		sys-fs/mdadm
	optfeature "Support Device Mapper multipathing" sys-fs/multipath-tools
	optfeature "Plymouth boot splash"  '>=sys-boot/plymouth-0.8.5-r5'
	optfeature "Support network block devices" sys-block/nbd
	optfeature "Support NFS" net-fs/nfs-utils net-nds/rpcbind
	optfeature \
		"Install ssh and scp along with config files and specified keys" \
		net-misc/openssh
	optfeature "Enable logging with rsyslog" app-admin/rsyslog
	optfeature \
		"Enable rngd service to help generating entropy early during boot" \
		sys-apps/rng-tools
}
