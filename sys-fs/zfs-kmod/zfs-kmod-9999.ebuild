# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools dist-kernel-utils flag-o-matic linux-mod toolchain-funcs

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="https://github.com/openzfs/zfs"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openzfs/zfs.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/openzfs.asc
	inherit verify-sig

	MY_PV="${PV/_rc/-rc}"
	SRC_URI="https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz"
	SRC_URI+=" verify-sig? ( https://github.com/openzfs/zfs/releases/download/zfs-${MY_PV}/zfs-${MY_PV}.tar.gz.asc )"
	S="${WORKDIR}/zfs-${PV%_rc?}"
	ZFS_KERNEL_COMPAT="6.0"

	#  increments minor eg 5.14 -> 5.15, and still supports override.
	ZFS_KERNEL_DEP="${ZFS_KERNEL_COMPAT_OVERRIDE:-${ZFS_KERNEL_COMPAT}}"
	ZFS_KERNEL_DEP="${ZFS_KERNEL_DEP%%.*}.$(( ${ZFS_KERNEL_DEP##*.} + 1))"

	if [[ ${PV} != *_rc* ]]; then
		KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
	fi
fi

LICENSE="CDDL MIT debug? ( GPL-2+ )"
SLOT="0/${PVR}"
IUSE="custom-cflags debug +rootfs"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-lang/perl
	virtual/awk
"

# we want dist-kernel block in BDEPEND because of portage resolver.
# since linux-mod.eclass already sets version-unbounded dep, portage
# will pull new versions. So we set it in BDEPEND which takes priority.
# and we don't need in in git ebuild.
if [[ ${PV} != "9999" ]] ; then
	BDEPEND+="
		verify-sig? ( sec-keys/openpgp-keys-openzfs )
		dist-kernel? ( <virtual/dist-kernel-${ZFS_KERNEL_DEP}:= )
	"
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

	# Run unconditionally (bug #792627)
	eautoreconf

	if [[ ${PV} != "9999" ]]; then
		# Set module revision number
		sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" META || die "Could not set Gentoo release"
	fi
}

src_configure() {
	set_arch_to_kernel

	use custom-cflags || strip-flags

	filter-ldflags -Wl,*

	# Set CROSS_COMPILE in the environment.
	# This allows the user to override it via make.conf or via a local Makefile.
	# https://bugs.gentoo.org/811600
	export CROSS_COMPILE=${CROSS_COMPILE-${CHOST}-}

	local myconf=(
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
		HOSTCC="$(tc-getBUILD_CC)"
		V=1
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	set_arch_to_kernel

	myemakeargs+=(
		DEPMOD=:
		# INSTALL_MOD_PATH ?= $(DESTDIR) in module/Makefile
		DESTDIR="${D}"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if [[ -z ${ROOT} ]] && use dist-kernel; then
		set_arch_to_pkgmgr
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
	fi

	if use x86 || use arm; then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	if has_version sys-boot/grub; then
		ewarn "This version of OpenZFS includes support for new feature flags"
		ewarn "that are incompatible with previous versions. GRUB2 support for"
		ewarn "/boot with the new feature flags is not yet available."
		ewarn "Do *NOT* upgrade root pools to use the new feature flags."
		ewarn "Any new pools will be created with the new feature flags by default"
		ewarn "and will not be compatible with older versions of OpenZFS. To"
		ewarn "create a newpool that is backward compatible wih GRUB2, use "
		ewarn
		ewarn "zpool create -o compatibility=grub2 ..."
		ewarn
		ewarn "Refer to /usr/share/zfs/compatibility.d/grub2 for list of features."
	fi
}
