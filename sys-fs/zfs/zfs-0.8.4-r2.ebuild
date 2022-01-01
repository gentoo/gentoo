# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{6,7} )

inherit autotools bash-completion-r1 flag-o-matic linux-info distutils-r1 systemd toolchain-funcs udev usr-ldscript

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="https://github.com/openzfs/zfs"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 linux-mod
	EGIT_REPO_URI="https://github.com/openzfs/zfs.git"
else
	SRC_URI="https://github.com/openzfs/${PN}/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64"
fi

LICENSE="BSD-2 CDDL MIT"
SLOT="0"
IUSE="custom-cflags debug kernel-builtin libressl minimal nls python +rootfs test-suite static-libs"

DEPEND="
	net-libs/libtirpc[static-libs?]
	sys-apps/util-linux[static-libs?]
	sys-libs/zlib[static-libs(+)?]
	virtual/awk
	virtual/libudev[static-libs(-)?]
	libressl? ( dev-libs/libressl:0=[static-libs?] )
	!libressl? ( dev-libs/openssl:0=[static-libs?] )
	!minimal? ( ${PYTHON_DEPS} )
	python? (
		virtual/python-cffi[${PYTHON_USEDEP}]
	)
"

BDEPEND="virtual/awk
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

RDEPEND="${DEPEND}
	!kernel-builtin? ( ~sys-fs/zfs-kmod-${PV} )
	!prefix? ( virtual/udev )
	sys-fs/udev-init-scripts
	rootfs? (
		app-arch/cpio
		app-misc/pax-utils
		!<sys-kernel/genkernel-3.5.1.1
	)
	test-suite? (
		sys-apps/kmod[tools]
		sys-apps/util-linux
		sys-devel/bc
		sys-block/parted
		sys-fs/lsscsi
		sys-fs/mdadm
		sys-process/procps
	)
"

REQUIRED_USE="
	!minimal? ( ${PYTHON_REQUIRED_USE} )
	python? ( !minimal )
	test-suite? ( !minimal )
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/bash-completion-sudo.patch"
	"${FILESDIR}/${PV}-initconfdir.patch"
)

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

	if use python; then
		pushd contrib/pyzfs >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	fi

	# prevent errors showing up on zfs-mount stop, #647688
	# openrc will unmount all filesystems anyway.
	sed -i "/^ZFS_UNMOUNT=/ s/yes/no/" "etc/default/zfs.in" || die
}

src_configure() {
	use custom-cflags || strip-flags
	use minimal || python_setup

	local myconf=(
		--bindir="${EPREFIX}/bin"
		--enable-shared
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
		$(use_enable nls)
		$(use_enable python pyzfs)
		$(use_enable static-libs static)
		$(usex minimal --without-python --with-python="${EPYTHON}")
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

	if ! use static-libs; then
		find "${ED}/" -name '*.la' -delete || die
	fi

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
	use minimal || python_fix_shebang "${ED}/bin"
}

pkg_postinst() {
	if use rootfs; then
		if ! has_version sys-kernel/genkernel && ! has_version sys-kernel/dracut; then
			elog "root on zfs requires initramfs to boot"
			elog "the following packages known to provide one and tested on regular basis:"
			elog "  sys-kernel/dracut"
			elog "  sys-kernel/genkernel"
		fi
	fi

	if ! use kernel-builtin && [[ ${PV} = "9999" ]]; then
		einfo "Adding ${P} to the module database to ensure that the"
		einfo "kernel modules and userland utilities stay in sync."
		update_moduledb
	fi

	[[ -e "${EROOT}/etc/runlevels/boot/zfs-import" ]] || \
		einfo "You should add zfs-import to the boot runlevel."
	[[ -e "${EROOT}/etc/runlevels/boot/zfs-mount" ]]|| \
		einfo "You should add zfs-mount to the boot runlevel."
	[[ -e "${EROOT}/etc/runlevels/default/zfs-share" ]] || \
		einfo "You should add zfs-share to the default runlevel."
	[[ -e "${EROOT}/etc/runlevels/default/zfs-zed" ]] || \
		einfo "You should add zfs-zed to the default runlevel."
}

pkg_postrm() {
	if ! use kernel-builtin && [[ ${PV} == "9999" ]]; then
		remove_moduledb
	fi
}
