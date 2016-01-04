# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

if [ ${PV} == "9999" ] ; then
	inherit git-r3 linux-mod
	AUTOTOOLS_AUTORECONF="1"
	EGIT_REPO_URI="git://github.com/zfsonlinux/${PN}.git"
else
	SRC_URI="https://github.com/zfsonlinux/${PN}/releases/download/${P}/${P}.tar.gz
		https://dev.gentoo.org/~ryao/dist/${P}-patches-p1.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

inherit autotools-utils bash-completion-r1 flag-o-matic linux-info python-r1 systemd toolchain-funcs udev

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="BSD-2 CDDL MIT"
SLOT="0"
IUSE="custom-cflags debug kernel-builtin +rootfs test-suite static-libs"
RESTRICT="test"

COMMON_DEPEND="
	sys-apps/util-linux[static-libs?]
	sys-libs/zlib[static-libs(+)?]
	virtual/awk
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	!=sys-apps/grep-2.13*
	!kernel-builtin? (
		=sys-fs/zfs-kmod-${PV}*
		!<sys-fs/zfs-kmod-0.6.5.3-r1
		)
	!sys-fs/zfs-fuse
	!prefix? ( virtual/udev )
	test-suite? (
		sys-apps/util-linux
		sys-devel/bc
		sys-block/parted
		sys-fs/lsscsi
		sys-fs/mdadm
		sys-process/procps
		virtual/modutils
		)
	rootfs? (
		app-arch/cpio
		app-misc/pax-utils
		!<sys-boot/grub-2.00-r2:2
		)
	!>=sys-fs/udev-init-scripts-28
"

AT_M4DIR="config"
AUTOTOOLS_IN_SOURCE_BUILD="1"

pkg_setup() {
	if use kernel_linux && use test-suite; then
		linux-info_pkg_setup
		if  ! linux_config_exists; then
			ewarn "Cannot check the linux kernel configuration."
		else
			# recheck that we don't have usblp to collide with libusb
			if use test-suite; then
				if linux_chkconfig_present BLK_DEV_LOOP; then
					eerror "The ZFS test suite requires loop device support enabled."
					eerror "Please enable it:"
					eerror "    CONFIG_BLK_DEV_LOOP=y"
					eerror "in /usr/src/linux/.config or"
					eerror "    Device Drivers --->"
					eerror "        Block devices --->"
					eerror "            [ ] Loopback device support"
				fi
			fi
		fi
	fi

}

src_prepare() {
	if [ ${PV} != "9999" ]
	then
		# Apply patch set
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		epatch "${WORKDIR}/${P}-patches"
	fi

	# Update paths
	sed -e "s|/sbin/lsmod|/bin/lsmod|" \
		-e "s|/usr/bin/scsi-rescan|/usr/sbin/rescan-scsi-bus|" \
		-e "s|/sbin/parted|/usr/sbin/parted|" \
		-i scripts/common.sh.in

	autotools-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=user
		--with-dracutdir="/usr/$(get_libdir)/dracut"
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-udevdir="$(get_udevdir)"
		--with-blkid
		$(use_enable debug)
	)
	autotools-utils_src_configure

	# prepare systemd unit and helper script
	cat "${FILESDIR}/zfs.service.in" | \
		sed -e "s:@sbindir@:${EPREFIX}/sbin:g" \
			-e "s:@sysconfdir@:${EPREFIX}/etc:g" \
		> "${T}/zfs.service" || die
	cat "${FILESDIR}/zfs-init.sh.in" | \
		sed -e "s:@sbindir@:${EPREFIX}/sbin:g" \
			-e "s:@sysconfdir@:${EPREFIX}/etc:g" \
		> "${T}/zfs-init.sh" || die
}

src_install() {
	autotools-utils_src_install
	gen_usr_ldscript -a uutil nvpair zpool zfs zfs_core
	use test-suite || rm -rf "${ED}usr/share/zfs"

	newbashcomp "${FILESDIR}/bash-completion-r1" zfs
	bashcomp_alias zfs zpool

	exeinto /usr/libexec
	doexe "${T}/zfs-init.sh"
	systemd_dounit "${T}/zfs.service"
}

pkg_postinst() {
	if ! use kernel-builtin && [ ${PV} = "9999" ]
	then
		einfo "Adding ${P} to the module database to ensure that the"
		einfo "kernel modules and userland utilities stay in sync."
		update_moduledb
	fi

	if [ -e "${EROOT}etc/runlevels/boot/zfs" ]
	then
		einfo 'The zfs boot script has been split into the zfs-import,'
		einfo 'zfs-mount and zfs-share scripts.'
		einfo
		einfo 'You had the zfs script in your boot runlevel. For your'
		einfo 'convenience, it has been automatically removed and the three'
		einfo 'scripts that replace it have been configured to start.'
		einfo 'The zfs-import and zfs-mount scripts have been added to the boot'
		einfo 'runlevel while the zfs-share script is in the default runlevel.'

		rm "${EROOT}etc/runlevels/boot/zfs"
		ln -snf "${EROOT}etc/init.d/zfs-import" \
			"${EROOT}etc/runlevels/boot/zfs-import"
		ln -snf "${EROOT}etc/init.d/zfs-mount" \
			"${EROOT}etc/runlevels/boot/zfs-mount"
		ln -snf "${EROOT}etc/init.d/zfs-share" \
			"${EROOT}etc/runlevels/default/zfs-share"
	else
		[ -e "${EROOT}etc/runlevels/boot/zfs-import" ] || \
			einfo "You should add zfs-import to the boot runlevel."
		[ -e "${EROOT}etc/runlevels/boot/zfs-mount" ] || \
			einfo "You should add zfs-mount to the boot runlevel."
		[ -e "${EROOT}etc/runlevels/default/zfs-share" ] || \
			einfo "You should add zfs-share to the default runlevel."
	fi

	if [ -e "${EROOT}etc/runlevels/default/zed" ]
	then
		einfo 'The downstream OpenRC zed script has replaced by the upstream'
		einfo 'OpenRC zfs-zed script.'
		einfo
		einfo 'You had the zed script in your default runlevel. For your'
		einfo 'convenience, it has been automatically removed and the zfs-zed'
		einfo 'script that replaced it has been configured to start.'

		rm "${EROOT}etc/runlevels/boot/zed"
		ln -snf "${EROOT}etc/init.d/zfs-sed" \
			"${EROOT}etc/runlevels/default/zfs-zed"
	else
		[ -e "${EROOT}etc/runlevels/default/zfs-zed" ] || \
			einfo "You should add zfs-zed to the default runlevel."
	fi

	if [ -e "${EROOT}etc/runlevels/shutdown/zfs-shutdown" ]
	then
		einfo "The zfs-shutdown script is obsolete. Removing it from runlevel."
		rm "${EROOT}etc/runlevels/shutdown/zfs-shutdown"
	fi

	einfo "sys-kernel/spl-0.6.5.3-r1, sys-fs/zfs-kmod-0.6.5.3-r1 and "
	einfo "sys-fs/zfs-0.6.5.3-r1 have introduced a partial stable "
	einfo "/dev/zfs API developed by ClusterHQ. This means that situations "
	einfo "arising from the kernel modules and userland tools being "
	einfo "mismatched on future updates will not cause problems."
	einfo
	einfo "In specific, this should solve the failure to mount filesystems when "
	einfo "old modules are cached in an old initramfs provided that those "
	einfo "modules support this API"
	if use rootfs
	then
		einfo
		ewarn "The older modules will *NOT* work with the new userland code."
		ewarn "It is very important that you update your initramfs after this "
		ewarn "update."
	fi
}

pkg_postrm() {
	if ! use kernel-builtin && [ ${PV} = "9999" ]
	then
		remove_moduledb
	fi
}
