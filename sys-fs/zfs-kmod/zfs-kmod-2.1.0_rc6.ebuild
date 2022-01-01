# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools dist-kernel-utils flag-o-matic linux-mod toolchain-funcs

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="https://github.com/openzfs/zfs"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openzfs/zfs.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openzfs.asc
	inherit verify-sig

	MY_PV="${PV/_rc/-rc}"
	SRC_URI="https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz"
	SRC_URI+=" verify-sig? ( https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz.asc )"
	S="${WORKDIR}/zfs-${PV%_rc?}"
	ZFS_KERNEL_COMPAT="5.12"

	if [[ ${PV} != *_rc* ]]; then
		KEYWORDS="~amd64 ~arm64 ~ppc64"
	fi
fi

LICENSE="CDDL MIT debug? ( GPL-2+ )"
SLOT="0/${PVR}"
IUSE="custom-cflags debug +rootfs"

RDEPEND="${DEPEND}
	!sys-kernel/spl
"

BDEPEND="
	dev-lang/perl
	virtual/awk
"

if [[ ${PV} != "9999" ]] ; then
	BDEPEND+=" verify-sig? ( app-crypt/openpgp-keys-openzfs )"
fi

# PDEPEND in this form is needed to trick portage suggest
# enabling dist-kernel if only 1 package have it set
PDEPEND="dist-kernel? ( ~sys-fs/zfs-${PV}[dist-kernel] )"

RESTRICT="debug? ( strip ) test"

DOCS=( AUTHORS COPYRIGHT META README.md )

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
	CONFIG_CHECK="
		!DEBUG_LOCK_ALLOC
		EFI_PARTITION
		MODULES
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		!TRIM_UNUSED_KSYMS
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	use debug && CONFIG_CHECK="${CONFIG_CHECK}
		FRAME_POINTER
		DEBUG_INFO
		!DEBUG_INFO_REDUCED
	"

	use rootfs && \
		CONFIG_CHECK="${CONFIG_CHECK}
			BLK_DEV_INITRD
			DEVTMPFS
	"

	kernel_is -lt 5 && CONFIG_CHECK="${CONFIG_CHECK} IOSCHED_NOOP"

	if [[ ${PV} != "9999" ]]; then
		local kv_major_max kv_minor_max zcompat
		zcompat="${ZFS_KERNEL_COMPAT_OVERRIDE:-${ZFS_KERNEL_COMPAT}}"
		kv_major_max="${zcompat%%.*}"
		zcompat="${zcompat#*.}"
		kv_minor_max="${zcompat%%.*}"
		kernel_is -le "${kv_major_max}" "${kv_minor_max}" || die \
			"Linux ${kv_major_max}.${kv_minor_max} is the latest supported version"

	fi

	kernel_is -ge 3 10 || die "Linux 3.10 or newer required"

	linux-mod_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} == "9999" ]]; then
		eautoreconf
	else
		# Set module revision number
		sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" META || die "Could not set Gentoo release"
	fi
}

src_configure() {
	set_arch_to_kernel

	use custom-cflags || strip-flags

	filter-ldflags -Wl,*

	local myconf=(
		CROSS_COMPILE="${CHOST}-"
		HOSTCC="$(tc-getBUILD_CC)"
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
	)

	econf "${myconf[@]}"
}

src_compile() {
	set_arch_to_kernel

	myemakeargs=(
		CROSS_COMPILE="${CHOST}-"
		HOSTCC="$(tc-getBUILD_CC)"
		V=1
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	set_arch_to_kernel

	myemakeargs+=(
		DEPMOD=:
		DESTDIR="${D}"
		INSTALL_MOD_PATH="${EPREFIX:-/}" # lib/modules/<kver> added by KBUILD
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# Remove old modules
	if [[ -d "${EROOT}/lib/modules/${KV_FULL}/addon/zfs" ]]; then
		ewarn "${PN} now installs modules in ${EROOT}/lib/modules/${KV_FULL}/extra/zfs"
		ewarn "Old modules were detected in ${EROOT}/lib/modules/${KV_FULL}/addon/zfs"
		ewarn "Automatically removing old modules to avoid problems."
		rm -r "${EROOT}/lib/modules/${KV_FULL}/addon/zfs" || die "Cannot remove modules"
		rmdir --ignore-fail-on-non-empty "${EROOT}/lib/modules/${KV_FULL}/addon"
	fi

	if [[ -z ${ROOT} ]] && use dist-kernel; then
		set_arch_to_portage
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
	fi

	if use x86 || use arm; then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	ewarn "This version of OpenZFS includes support for new feature flags"
	ewarn "that are incompatible with previous versions. GRUB2 support for"
	ewarn "/boot with the new feature flags is not yet available."
	ewarn "Do *NOT* upgrade root pools to use the new feature flags."
	ewarn "Any new pools will be created with the new feature flags by default"
	ewarn "and will not be compatible with older versions of ZFSOnLinux. To"
	ewarn "create a newpool that is backward compatible wih GRUB2, use "
	ewarn
	ewarn "zpool create -d -o feature@async_destroy=enabled "
	ewarn "	-o feature@empty_bpobj=enabled -o feature@lz4_compress=enabled"
	ewarn "	-o feature@spacemap_histogram=enabled"
	ewarn "	-o feature@enabled_txg=enabled "
	ewarn "	-o feature@extensible_dataset=enabled -o feature@bookmarks=enabled"
	ewarn "	..."
	ewarn
	ewarn "GRUB2 support will be updated as soon as either the GRUB2"
	ewarn "developers do a tag or the Gentoo developers find time to backport"
	ewarn "support from GRUB2 HEAD."
}
