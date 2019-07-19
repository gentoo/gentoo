# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit bash-completion-r1 flag-o-matic linux-info linux-mod distutils-r1 systemd toolchain-funcs udev usr-ldscript

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="https://zfsonlinux.org/"

if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/zfsonlinux/zfs.git"
else
	SRC_URI="https://github.com/zfsonlinux/${PN}/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2 CDDL MIT"
SLOT="0"
IUSE="custom-cflags debug kernel-builtin python +rootfs test-suite static-libs"

COMMON_DEPEND="
	${PYTHON_DEPS}
	net-libs/libtirpc
	sys-apps/util-linux[static-libs?]
	sys-libs/zlib[static-libs(+)?]
	virtual/awk
	python? (
		virtual/python-cffi[${PYTHON_USEDEP}]
	)
"

BDEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

RDEPEND="${COMMON_DEPEND}
	!=sys-apps/grep-2.13*
	!kernel-builtin? ( ~sys-fs/zfs-kmod-${PV} )
	!sys-fs/zfs-fuse
	!prefix? ( virtual/udev )
	sys-fs/udev-init-scripts
	rootfs? (
		app-arch/cpio
		app-misc/pax-utils
		!<sys-boot/grub-2.00-r2:2
		!<sys-kernel/genkernel-3.5.1.1
		!<sys-kernel/genkernel-next-67
		!<sys-kernel/bliss-initramfs-7.1.0
		!<sys-kernel/dracut-044-r1
	)
	test-suite? (
		sys-apps/util-linux
		sys-devel/bc
		sys-block/parted
		sys-fs/lsscsi
		sys-fs/mdadm
		sys-process/procps
		virtual/modutils
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

PATCHES=( "${FILESDIR}/bash-completion-sudo.patch" )

pkg_setup() {
	if use kernel_linux && use test-suite; then
		linux-info_pkg_setup

		if  ! linux_config_exists; then
			ewarn "Cannot check the linux kernel configuration."
		else
			if use test-suite; then
				if linux_chkconfig_present BLK_DEV_LOOP; then
					eerror "The ZFS test suite requires loop device support enabled."
					eerror "Please enable it:"
					eerror "    CONFIG_BLK_DEV_LOOP=y"
					eerror "in /usr/src/linux/.config or"
					eerror "    Device Drivers --->"
					eerror "        Block devices --->"
					eerror "            [X] Loopback device support"
				fi
			fi
		fi
	fi
}

src_prepare() {
	default

	if [[ ${PV} == "9999" ]]; then
		eautoreconf
	else
		# Set revision number
		sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" META || die "Could not set Gentoo release"
	fi

	# Update paths
	sed -e "s|/sbin/lsmod|/bin/lsmod|" \
		-e "s|/usr/bin/scsi-rescan|/usr/sbin/rescan-scsi-bus|" \
		-e "s|/sbin/parted|/usr/sbin/parted|" \
		-i scripts/common.sh.in || die

	if use python; then
		pushd contrib/pyzfs >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	fi
}

src_configure() {
	use custom-cflags || strip-flags

	local myconf=(
		--bindir="${EPREFIX}/bin"
		--enable-systemd
		--enable-sysvinit
		--localstatedir="${EPREFIX}/var"
		--sbindir="${EPREFIX}/sbin"
		--with-config=user
		--with-dracutdir="${EPREFIX}/usr/lib/dracut"
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-udevdir="$(get_udevdir)"
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		--with-systemdpresetdir="${EPREFIX}/lib/systemd/system-preset"
		$(use_enable debug)
		$(use_enable python pyzfs)
	)

	econf "${myconf[@]}"
}

src_compile() {
	default
	if use python; then
		pushd contrib/pyzfs >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	default

	gen_usr_ldscript -a uutil nvpair zpool zfs zfs_core

	use test-suite || rm -rf "${ED}/usr/share/zfs"

	dobashcomp contrib/bash_completion.d/zfs
	bashcomp_alias zfs zpool

	# strip executable bit from conf.d file
	fperms 0644 /etc/conf.d/zfs

	if use python; then
		pushd contrib/pyzfs >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi

	# enforce best available python implementation
	python_setup
	python_fix_shebang "${ED}/bin"
}

pkg_postinst() {
	if has_version "<=sys-kernel/genkernel-3.5.3.3"; then
		einfo "genkernel version 3.5.3.3 and earlier does NOT support"
		einfo " unlocking pools with native zfs encryption enabled at boot"
		einfo " use dracut or genkernel-9999 if you requre this functionality"
	fi

	if ! use kernel-builtin && [[ ${PV} = "9999" ]]; then
		einfo "Adding ${P} to the module database to ensure that the"
		einfo "kernel modules and userland utilities stay in sync."
		update_moduledb
	fi

	if [[ -e "${EROOT}/etc/runlevels/boot/zfs" ]]; then
		einfo 'The zfs boot script has been split into the zfs-import,'
		einfo 'zfs-mount and zfs-share scripts.'
		einfo
		einfo 'You had the zfs script in your boot runlevel. For your'
		einfo 'convenience, it has been automatically removed and the three'
		einfo 'scripts that replace it have been configured to start.'
		einfo 'The zfs-import and zfs-mount scripts have been added to the boot'
		einfo 'runlevel while the zfs-share script is in the default runlevel.'

		rm "${EROOT}/etc/runlevels/boot/zfs"
		ln -snf "${EROOT}/etc/init.d/zfs-import" \
			"${EROOT}/etc/runlevels/boot/zfs-import"
		ln -snf "${EROOT}/etc/init.d/zfs-mount" \
			"${EROOT}/etc/runlevels/boot/zfs-mount"
		ln -snf "${EROOT}/etc/init.d/zfs-share" \
			"${EROOT}/etc/runlevels/default/zfs-share"
	else
		[[ -e "${EROOT}/etc/runlevels/boot/zfs-import" ]] || \
			einfo "You should add zfs-import to the boot runlevel."
		[[ -e "${EROOT}/etc/runlevels/boot/zfs-mount" ]]|| \
			einfo "You should add zfs-mount to the boot runlevel."
		[[ -e "${EROOT}/etc/runlevels/default/zfs-share" ]] || \
			einfo "You should add zfs-share to the default runlevel."
	fi

	if [[ -e "${EROOT}/etc/runlevels/default/zed" ]]; then
		einfo 'The downstream OpenRC zed script has replaced by the upstream'
		einfo 'OpenRC zfs-zed script.'
		einfo
		einfo 'You had the zed script in your default runlevel. For your'
		einfo 'convenience, it has been automatically removed and the zfs-zed'
		einfo 'script that replaced it has been configured to start.'

		rm "${EROOT}/etc/runlevels/boot/zed"
		ln -snf "${EROOT}/etc/init.d/zfs-zed" \
			"${EROOT}/etc/runlevels/default/zfs-zed"
	else
		[[ -e "${EROOT}/etc/runlevels/default/zfs-zed" ]] || \
			einfo "You should add zfs-zed to the default runlevel."
	fi

	if [[ -e "${EROOT}/etc/runlevels/shutdown/zfs-shutdown" ]]; then
		einfo "The zfs-shutdown script is obsolete. Removing it from runlevel."
		rm "${EROOT}/etc/runlevels/shutdown/zfs-shutdown"
	fi

	systemd_reenable zfs-zed.service
	systemd_reenable zfs-import-cache.service
	systemd_reenable zfs-import-scan.service
	systemd_reenable zfs-mount.service
	systemd_reenable zfs-share.service
	systemd_reenable zfs-import.target
	systemd_reenable zfs.target
}

pkg_postrm() {
	if ! use kernel-builtin && [[ ${PV} == "9999" ]]; then
		remove_moduledb
	fi
}
