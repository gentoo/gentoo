# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools bash-completion-r1 dist-kernel-utils distutils-r1 flag-o-matic linux-info pam systemd toolchain-funcs udev usr-ldscript

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="https://github.com/openzfs/zfs"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3 linux-mod
	EGIT_REPO_URI="https://github.com/openzfs/zfs.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openzfs.asc
	inherit verify-sig

	MY_P="${P/_rc/-rc}"
	SRC_URI="https://github.com/openzfs/${PN}/releases/download/${MY_P}/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://github.com/openzfs/${PN}/releases/download/${MY_P}/${MY_P}.tar.gz.asc )"
	S="${WORKDIR}/${P%_rc?}"

	if [[ ${PV} != *_rc* ]]; then
		KEYWORDS="~amd64 ~arm64 ~ppc64"
	fi
fi

LICENSE="BSD-2 CDDL MIT"
# just libzfs soname major for now.
# possible candidates: libuutil, libzpool, libnvpair. Those do not provide stable abi, but are considered.
# see libsoversion_check() below as well
SLOT="0/5"
IUSE="custom-cflags debug dist-kernel kernel-builtin minimal nls pam python +rootfs test-suite static-libs"

DEPEND="
	net-libs/libtirpc[static-libs?]
	sys-apps/util-linux[static-libs?]
	sys-libs/zlib[static-libs(+)?]
	virtual/libudev[static-libs(-)?]
	dev-libs/openssl:0=[static-libs?]
	!minimal? ( ${PYTHON_DEPS} )
	pam? ( sys-libs/pam )
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

if [[ ${PV} != "9999" ]] ; then
	BDEPEND+=" verify-sig? ( app-crypt/openpgp-keys-openzfs )"
fi

# awk is used for some scripts, completions, and the Dracut module
RDEPEND="${DEPEND}
	!kernel-builtin? ( ~sys-fs/zfs-kmod-${PV}:=[dist-kernel?] )
	!prefix? ( virtual/udev )
	sys-fs/udev-init-scripts
	virtual/awk
	dist-kernel? ( virtual/dist-kernel:= )
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

pkg_pretend() {
	use rootfs || return 0

	if has_version virtual/dist-kernel && ! use dist-kernel; then
		ewarn "You have virtual/dist-kernel installed, but"
		ewarn "USE=\"dist-kernel\" is not enabled for ${CATEGORY}/${PN}"
		ewarn "It's recommended to globally enable dist-kernel USE flag"
		ewarn "to auto-trigger initrd rebuilds with kernel updates"
	fi
}

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup

		if ! linux_config_exists; then
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

libsoversion_check() {

	local bugurl libzfs_sover
	bugurl="https://bugs.gentoo.org/enter_bug.cgi?form_name=enter_bug&product=Gentoo+Linux&component=Current+packages"

	libzfs_sover="$(grep 'libzfs_la_LDFLAGS += -version-info' lib/libzfs/Makefile.am \
		| grep -Eo '[0-9]+:[0-9]+:[0-9]+')"
	libzfs_sover="${libzfs_sover%%:*}"

	if [[ ${libzfs_sover} -ne $(ver_cut 2 ${SLOT}) ]]; then
		echo
		eerror "BUG BUG BUG BUG BUG BUG BUG BUG"
		eerror "ebuild subslot does not match libzfs soversion!"
		eerror "libzfs soversion: ${libzfs_sover}"
		eerror "ebuild value: $(ver_cut 2 ${SLOT})"
		eerror "This is a bug in the ebuild, please use the following URL to report it"
		eerror "${bugurl}&short_desc=${CATEGORY}%2F${P}+update+subslot"
		echo
		# we want to abort for releases, but just print a warning for live ebuild
		# to keep package installable
		[[  ${PV} == "9999" ]] || die
	fi
}

src_prepare() {
	default
	libsoversion_check

	# Run unconditionally (bug #792627)
	eautoreconf

	if [[ ${PV} != "9999" ]]; then
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
		--with-pamconfigsdir="${EPREFIX}/unwanted_files"
		--with-pammoduledir="$(getpam_mod_dir)"
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		--with-systemdpresetdir="${EPREFIX}/lib/systemd/system-preset"
		--with-vendor=gentoo
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable pam)
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

	gen_usr_ldscript -a nvpair uutil zfsbootenv zfs zfs_core zpool

	use pam && { rm -rv "${ED}/unwanted_files" || die ; }

	use test-suite || { rm -r "${ED}/usr/share/zfs" || die ; }

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
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
	# we always need userspace utils in sync with zfs-kmod
	# so force initrd update for userspace as well, to avoid
	# situation when zfs-kmod trigger initrd rebuild before
	# userspace component is rebuilt
	# KV_* variables are provided by linux-info.eclass
	if [[ -z ${ROOT} ]] && use dist-kernel; then
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
	fi

	if use rootfs; then
		if ! has_version sys-kernel/genkernel && ! has_version sys-kernel/dracut; then
			elog "Root on zfs requires an initramfs to boot"
			elog "The following packages provide one and are tested on a regular basis:"
			elog "  sys-kernel/dracut"
			elog "  sys-kernel/genkernel"
		fi
	fi

	if ! use kernel-builtin && [[ ${PV} == "9999" ]]; then
		einfo "Adding ${P} to the module database to ensure that the"
		einfo "kernel modules and userland utilities stay in sync."
		update_moduledb
	fi

	if systemd_is_booted || has_version sys-apps/systemd; then
		einfo "Please refer to ${EROOT}/lib/systemd/system-preset/50-zfs.preset"
		einfo "for default zfs systemd service configuration"
	else
		[[ -e "${EROOT}/etc/runlevels/boot/zfs-import" ]] || \
			einfo "You should add zfs-import to the boot runlevel."
		[[ -e "${EROOT}/etc/runlevels/boot/zfs-mount" ]]|| \
			einfo "You should add zfs-mount to the boot runlevel."
		[[ -e "${EROOT}/etc/runlevels/default/zfs-share" ]] || \
			einfo "You should add zfs-share to the default runlevel."
		[[ -e "${EROOT}/etc/runlevels/default/zfs-zed" ]] || \
			einfo "You should add zfs-zed to the default runlevel."
	fi
}

pkg_postrm() {
	if ! use kernel-builtin && [[ ${PV} == "9999" ]]; then
		remove_moduledb
	fi
}
