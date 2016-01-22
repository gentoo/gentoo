# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic linux-info linux-mod multilib readme.gentoo toolchain-funcs

AUFS_VERSION="${PV%%_p*}"
# highest branch version
PATCH_MAX_VER=19
# highest supported version
KERN_MAX_VER=20
# lowest supported version
KERN_MIN_VER=14

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/aufs3-standalone-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fuse hfs inotify kernel-patch nfs pax_kernel ramfs"

DEPEND="
	dev-util/patchutils
	dev-vcs/git"
RDEPEND="
	sys-fs/aufs-util
	!sys-fs/aufs
	!sys-fs/aufs2
	!sys-fs/aufs4"

S="${WORKDIR}"/${PN}-standalone

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK+=" !AUFS_FS"
	use inotify && CONFIG_CHECK+=" ~FSNOTIFY"
	use nfs && CONFIG_CHECK+=" EXPORTFS"
	use fuse && CONFIG_CHECK+=" ~FUSE_FS"
	use hfs && CONFIG_CHECK+=" ~HFSPLUS_FS"
	use pax_kernel && CONFIG_CHECK+=" PAX" && ERROR_PAX="Please use hardened sources"

	# this is needed so merging a binpkg ${PN} is possible w/out a kernel unpacked on the system
	[ -n "$PKG_SETUP_HAS_BEEN_RAN" ] && return

	get_version
	kernel_is lt 3 ${KERN_MIN_VER} 0 && die "the kernel version isn't supported by upstream anymore. Please upgrade."
	kernel_is gt 3 ${KERN_MAX_VER} 99 && die "kernel too new"

	linux-mod_pkg_setup

	if [[ "${KV_MINOR}" -gt "${PATCH_MAX_VER}" ]]; then
		PATCH_BRANCH="x-rcN"
	elif [[ "${KV_MINOR}" == "14" ]] && [[ "${KV_PATCH}" -ge "21" ]]; then
		PATCH_BRANCH="${KV_MINOR}".21+
	elif [[ "${KV_MINOR}" == "18" ]] && [[ "${KV_PATCH}" -ge "1" ]]; then
		PATCH_BRANCH="${KV_MINOR}".1+
	else
		PATCH_BRANCH="${KV_MINOR}"
	fi

	case ${KV_EXTRA} in
			"")
				elog "It seems you are using vanilla-sources with aufs3"
				elog "Please use sys-kernel/aufs-sources with USE=vanilla"
				elog "This will save you the nasty reemerge of sys-fs/aufs3 on every kernel upgrade"
			;;
			"-gentoo")
				elog "It seems you are using gentoo-sources with aufs3"
				elog "Please use sys-kernel/aufs-sources"
				elog "This will save you the nasty reemerge of sys-fs/aufs3 on every kernel upgrade"
			;;
	esac

	pushd "${T}" &> /dev/null
	unpack ${A}
	cd ${PN}-standalone || die
	local module_branch=origin/${PN}.${PATCH_BRANCH}
	einfo "Using ${module_branch} as patch source"
	git checkout -q -b local-${PN}.${PATCH_BRANCH} ${module_branch} || die
	combinediff ${PN}-base.patch ${PN}-standalone.patch  > "${T}"/combined-1.patch
	combinediff "${T}"/combined-1.patch ${PN}-mmap.patch > ${PN}-standalone-base-mmap-combined.patch
	if ! ( patch -p1 --dry-run --force -R -d ${KV_DIR} < ${PN}-standalone-base-mmap-combined.patch > /dev/null ); then
		if use kernel-patch; then
			cd ${KV_DIR}
			ewarn "Patching your kernel..."
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} < "${T}"/${PN}-standalone/${PN}-standalone-base-mmap-combined.patch >/dev/null
			epatch "${T}"/${PN}-standalone/${PN}-standalone-base-mmap-combined.patch
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "You need to apply a patch to your kernel to compile and run the ${PN} module"
			eerror "Either enable the kernel-patch useflag to do it with this ebuild"
			eerror "or apply "${T}"/${PN}-standalone/${PN}-standalone-base-mmap-combined.patch by hand"
			die "missing kernel patch, please apply it first"
		fi
	fi
	popd &> /dev/null
	export PKG_SETUP_HAS_BEEN_RAN=1
}

set_config() {
	for option in $*; do
		grep -q "^CONFIG_AUFS_${option} =" config.mk || die "${option} is not a valid config option"
		sed "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die
	done
}

src_prepare() {
	local module_branch=origin/${PN}.${PATCH_BRANCH}

	einfo "Using for module creation branch ${module_branch}"
	git checkout -q -b local-gentoo ${module_branch} || die

	# All config options to off
	sed "s:= y:=:g" -i config.mk || die

	set_config RDU BRANCH_MAX_127 SBILIST

	use debug && set_config DEBUG
	use fuse && set_config BR_FUSE POLL
	use hfs && set_config BR_HFSPLUS
	use inotify && set_config HNOTIFY HFSNOTIFY
	use nfs && set_config EXPORT
	use nfs && ( use amd64 || use ppc64 ) && set_config INO_T_64
	use ramfs && set_config BR_RAMFS

	if use pax_kernel; then
		if kernel_is ge 3 11; then
			epatch "${FILESDIR}"/pax-3.11.patch
		else
			epatch "${FILESDIR}"/pax-3.patch
		fi
	fi

	sed -i "s:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g" Makefile || die
}

src_compile() {
	local ARCH=x86

	emake \
		CC=$(tc-getCC) \
		LD=$(tc-getLD) \
		LDFLAGS="$(raw-ldflags)" \
		ARCH=$(tc-arch-kernel) \
		CONFIG_AUFS_FS=m \
		KDIR="${KV_OUT_DIR}"
}

src_install() {
	linux-mod_src_install

	insinto /usr/share/doc/${PF}

	use doc && doins -r Documentation

	use kernel-patch || doins "${T}"/${PN}-standalone/${PN}-standalone-base-mmap-combined.patch

	dodoc Documentation/filesystems/aufs/README "${T}"/${PN}-standalone/{aufs3-loopback,vfs-ino,tmpfs-idr}.patch

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	linux-mod_pkg_postinst
}
