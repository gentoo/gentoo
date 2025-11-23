# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Best-Effort Extent-Same, a btrfs dedup agent"
HOMEPAGE="https://github.com/Zygo/bees"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Zygo/bees.git"
else
	MY_PV=${PV/_/-}
	MY_P=${P/_/-}
	S=${WORKDIR}/${MY_P}

	SRC_URI="https://github.com/Zygo/bees/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	>=sys-apps/util-linux-2.30.2
	>=sys-fs/btrfs-progs-4.20.2
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~BTRFS_FS"
ERROR_BTRFS_FS="CONFIG_BTRFS_FS: bees does currently only work with btrfs"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if kernel_is -lt 5 7; then
			ewarn "With kernel versions below 5.4.96 and 5.7, the kernel may hold file system"
			ewarn "locks for a long time while at the same time CPU usage increases when bees is"
			ewarn "operating. bees tries to avoid this behavior by excluding very common extents"
			ewarn "from deduplication. This has only a minimal impact on dedupe effectiveness."
			ewarn
		fi
		if kernel_is -lt 5 4 19; then
			ewarn "With kernel versions below 5.4.19, bees may trigger a btrfs bug when running"
			ewarn "btrfs-balance in parallel. This may lead to meta-data corruption in the worst"
			ewarn "case. Especially, kernels 5.1.21 and 5.2.21 should be avoided. Kernels 5.0.x"
			ewarn "after 5.0.21 should be safe. In the best case, affected kernels may force"
			ewarn "the device RO without writing corrupted meta-data. More details:"
			ewarn "https://github.com/Zygo/bees/blob/master/docs/btrfs-kernel.md"
			ewarn
		fi
		if kernel_is -gt 5 15 106; then
			if kernel_is -lt 6 3 10; then
				ewarn "With kernel versions 5.15.107 or later, there is a memory fragmentation"
				ewarn "issue with LOGICAL_INO which can lead to cache thrashing and cause IO"
				ewarn "latency spikes. This version ships with a work-around at the cost of not"
				ewarn "handling highly duplicated filesystems that well. More details:"
				ewarn "https://github.com/Zygo/bees/issues/260"
				ewarn
			fi
		fi
		if kernel_is -lt 5.7; then
			ewarn "WARNING: Starting with bees v0.11, kernel versions below 5.7 (except 5.4 LTS)"
			ewarn "are no longer supported. Using bees with such kernels may introduce kernel"
			ewarn "crashes, system hangs, or data corruption. Please DO NOT runs bees with such"
			ewarn "kernels. You will be using bees AT YOUR OWN RISK!"
			ewarn
		fi
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		elog "Bees recommends running the latest current kernel for performance and"
		elog "reliability reasons, see README.md."
		elog
		elog "NEWS: bees now defaults to a much improved extent-based scanner. It is compatible"
		elog "with your existing state database in \`\$BEESHOME\` but it may start over from the"
		elog "beginning. However, it will keep the state of the old scanner, so you can switch"
		elog "back and forth. To actually use the new scanner, use scan mode 4 or remove the"
		elog "scan mode parameter from your init script. Requires kernel 4.14 or higher!"
	fi
}

src_prepare() {
	default
	sed -i 's/ -Werror//' makeflags || die
}

src_configure() {
	tc-export CC CXX AR
	cat >localconf <<-EOF || die
		ETC_PREFIX="${EPREFIX}/etc"
		LIBEXEC_PREFIX="${EPREFIX}/usr/libexec"
		PREFIX="${EPREFIX}/usr"
		SYSTEMD_SYSTEM_UNIT_DIR="$(systemd_get_systemunitdir)"
		DEFAULT_MAKE_TARGET=all
	EOF
	if [[ ${PV} != "9999" ]] ; then
		echo BEES_VERSION=v${MY_PV} >>localconf || die
	fi
}

src_compile() {
	default
	# localconf quotes leak in the systemd unit but are still needed for spaces
	sed -i 's/"//g' scripts/beesd@.service || die
}
