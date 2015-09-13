# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-r1

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

if [ ${PV} == "9999" ] ; then
	inherit git-2 linux-mod
	EGIT_REPO_URI="git://github.com/zfsonlinux/${PN}.git"
else
	inherit eutils versionator
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

inherit bash-completion-r1 flag-o-matic toolchain-funcs autotools-utils udev systemd

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="BSD-2 CDDL bash-completion? ( MIT )"
SLOT="0"
IUSE="bash-completion custom-cflags debug kernel-builtin +rootfs test-suite static-libs"
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
	!kernel-builtin? ( =sys-fs/zfs-kmod-${PV}* )
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

pkg_setup() {
	:
}

src_prepare() {
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
	rm -rf "${ED}usr/lib/dracut"
	use test-suite || rm -rf "${ED}usr/share/zfs"

	use bash-completion && newbashcomp "${FILESDIR}/bash-completion-r1" zfs

	exeinto /usr/libexec
	doexe "${T}/zfs-init.sh"
	systemd_dounit "${T}/zfs.service"
	doinitd "${FILESDIR}/zed"
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
		einfo 'zfs-mount and zfs-share scripts, with zed being added in the'
		einfo 'form of a fourth script.'
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

	[ -e "${EROOT}etc/runlevels/default/zfs-zed" ] || \
		einfo "You should add zfs-zed to the default runlevel."

	if [ -e "${EROOT}etc/runlevels/shutdown/zfs-shutdown" ]
	then
		einfo "The zfs-shutdown script is obsolete. Removing it from runlevel."
		rm "${EROOT}etc/runlevels/shutdown/zfs-shutdown"
	fi

}

pkg_postrm() {
	if ! use kernel-builtin && [ ${PV} = "9999" ]
	then
		remove_moduledb
	fi
}
