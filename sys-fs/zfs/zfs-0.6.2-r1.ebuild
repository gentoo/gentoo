# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

if [ ${PV} == "9999" ] ; then
	inherit git-2 linux-mod
	EGIT_REPO_URI="git://github.com/zfsonlinux/${PN}.git"
else
	inherit eutils versionator
	MY_PV=$(replace_version_separator 3 '-')
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/${PN}-${MY_PV}.tar.gz
		https://dev.gentoo.org/~ryao/dist/${PN}-kmod-${MY_PV}-p0.tar.xz"
	S="${WORKDIR}/${PN}-${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

inherit bash-completion-r1 flag-o-matic toolchain-funcs autotools-utils udev systemd

DESCRIPTION="Userland utilities for ZFS Linux kernel module"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="BSD-2 CDDL MIT"
SLOT="0"
IUSE="bash-completion custom-cflags kernel-builtin +rootfs selinux test-suite static-libs"
RESTRICT="test"

COMMON_DEPEND="
	selinux? ( sys-libs/libselinux )
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
"

pkg_setup() {
	:
}

src_prepare() {
	if [ ${PV} != "9999" ]
	then
		# Apply patch set
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		epatch "${WORKDIR}/${PN}-kmod-${MY_PV}-patches"
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
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-udevdir="$(get_udevdir)"
		--with-blkid
		$(use_with selinux)
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
	gen_usr_ldscript -a uutil nvpair zpool zfs
	rm -rf "${ED}usr/lib/dracut"
	use test-suite || rm -rf "${ED}usr/share/zfs"

	use bash-completion && newbashcomp "${FILESDIR}/bash-completion" zfs

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

	[ -e "${EROOT}etc/runlevels/boot/zfs" ] \
		|| ewarn 'You should add zfs to the boot runlevel.'

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
