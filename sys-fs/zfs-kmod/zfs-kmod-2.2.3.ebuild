# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dist-kernel-utils flag-o-matic linux-mod-r1 multiprocessing

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="https://github.com/openzfs/zfs"

MODULES_KERNEL_MAX=6.7
MODULES_KERNEL_MIN=3.10

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/openzfs/zfs.git"
	inherit git-r3
	unset MODULES_KERNEL_MAX
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openzfs.asc
	inherit verify-sig

	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz"
	SRC_URI+=" verify-sig? ( https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz.asc )"
	S="${WORKDIR}/zfs-${MY_PV}"

	ZFS_KERNEL_COMPAT="${MODULES_KERNEL_MAX}"
	# Increments minor eg 5.14 -> 5.15, and still supports override.
	ZFS_KERNEL_DEP="${ZFS_KERNEL_COMPAT_OVERRIDE:-${ZFS_KERNEL_COMPAT}}"
	ZFS_KERNEL_DEP="${ZFS_KERNEL_DEP%%.*}.$(( ${ZFS_KERNEL_DEP##*.} + 1))"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~sparc"
	fi
fi

LICENSE="CDDL MIT debug? ( GPL-2+ )"
SLOT="0/${PVR}"
IUSE="custom-cflags debug +rootfs"
RESTRICT="test"

BDEPEND="
	app-alternatives/awk
	dev-lang/perl
"

if [[ ${PV} != 9999 ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-openzfs )"

	IUSE+=" +dist-kernel-cap"
	RDEPEND="
		dist-kernel-cap? ( dist-kernel? (
			<virtual/dist-kernel-${ZFS_KERNEL_DEP}
		) )
	"
fi

# Used to suggest matching USE, but without suggesting to disable
PDEPEND="dist-kernel? ( ~sys-fs/zfs-${PV}[dist-kernel] )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.11-gentoo.patch
)

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
	local CONFIG_CHECK="
		EFI_PARTITION
		ZLIB_DEFLATE
		ZLIB_INFLATE
		!DEBUG_LOCK_ALLOC
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
	"
	use debug && CONFIG_CHECK+="
		DEBUG_INFO
		FRAME_POINTER
		!DEBUG_INFO_REDUCED
	"
	use rootfs && CONFIG_CHECK+="
		BLK_DEV_INITRD
		DEVTMPFS
	"

	kernel_is -lt 5 && CONFIG_CHECK+=" IOSCHED_NOOP"

	if [[ ${PV} != 9999 ]] ; then
		local kv_major_max kv_minor_max zcompat
		zcompat="${ZFS_KERNEL_COMPAT_OVERRIDE:-${ZFS_KERNEL_COMPAT}}"
		kv_major_max="${zcompat%%.*}"
		zcompat="${zcompat#*.}"
		kv_minor_max="${zcompat%%.*}"
		kernel_is -le "${kv_major_max}" "${kv_minor_max}" || die \
			"Linux ${kv_major_max}.${kv_minor_max} is the latest supported version"
	fi

	linux-mod-r1_pkg_setup
}

src_prepare() {
	default

	# Run unconditionally (bug #792627)
	eautoreconf

	if [[ ${PV} != 9999 ]] ; then
		# Set module revision number
		sed -Ei "s/(Release:.*)1/\1${PR}-gentoo/" META || die
	fi
}

src_configure() {
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	local myconf=(
		--bindir="${EPREFIX}"/bin
		--sbindir="${EPREFIX}"/sbin
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)

		# See gentoo.patch
		GENTOO_MAKEARGS_EVAL="${MODULES_MAKEARGS[*]@Q}"
		TEST_JOBS="$(makeopts_jobs)"
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake "${MODULES_MAKEARGS[@]}"
}

src_install() {
	emake "${MODULES_MAKEARGS[@]}" DESTDIR="${ED}" install
	modules_post_process

	dodoc AUTHORS COPYRIGHT META README.md
}

_old_layout_cleanup() {
	# new files are just extra/{spl,zfs}.ko with no subdirs.
	local olddir=(
		avl/zavl
		icp/icp
		lua/zlua
		nvpair/znvpair
		spl/spl
		unicode/zunicode
		zcommon/zcommon
		zfs/zfs
		zstd/zzstd
	)

	# kernel/module/Kconfig contains possible compressed extentions.
	local kext kextfiles
		for kext in .ko{,.{gz,xz,zst}}; do
		kextfiles+=( "${olddir[@]/%/${kext}}" )
	done

	local oldfile oldpath
	for oldfile in "${kextfiles[@]}"; do
		oldpath="${EROOT}/lib/modules/${KV_FULL}/extra/${oldfile}"
		if [[ -f "${oldpath}" ]]; then
			ewarn "Found obsolete zfs module ${oldfile} for current kernel ${KV_FULL}, removing."
			rm -rv "${oldpath}" || die
			# we do not remove non-empty directories just for safety in case there's something else.
			# also it may fail if there are both compressed and uncompressed modules installed.
			rmdir -v --ignore-fail-on-non-empty "${oldpath%/*.*}" || die
		fi
	done
}

pkg_postinst() {
	# Check for old module layout before doing anything else.
	# only attempt layout cleanup if new .ko location is used.
	local newko=( "${EROOT}/lib/modules/${KV_FULL}/extra"/{zfs,spl}.ko* )
	# We check first array member, if glob above did not exand, it will be "zfs.ko*" and -f will return false.
	# if glob expanded -f will do correct file precense check.
	[[ -f ${newko[0]} ]] && _old_layout_cleanup

	linux-mod-r1_pkg_postinst

	if [[ -z ${ROOT} ]] && use dist-kernel ; then
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
	fi

	if use x86 || use arm ; then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	if has_version sys-boot/grub ; then
		ewarn "This version of OpenZFS includes support for new feature flags"
		ewarn "that are incompatible with previous versions. GRUB2 support for"
		ewarn "/boot with the new feature flags is not yet available."
		ewarn "Do *NOT* upgrade root pools to use the new feature flags."
		ewarn "Any new pools will be created with the new feature flags by default"
		ewarn "and will not be compatible with older versions of OpenZFS. To"
		ewarn "create a new pool that is backward compatible wih GRUB2, use "
		ewarn
		ewarn "zpool create -o compatibility=grub2 ..."
		ewarn
		ewarn "Refer to /usr/share/zfs/compatibility.d/grub2 for list of features."
	fi
}
