# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Best-Effort Extent-Same, a btrfs dedup agent"
HOMEPAGE="https://github.com/Zygo/bees"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Zygo/bees.git"
else
	SRC_URI="https://github.com/Zygo/bees/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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

PATCHES=(
	"${FILESDIR}/0001-context-demote-abandoned-toxic-match-to-debug-log-le.patch"
	"${FILESDIR}/0002-HACK-crucible-Work-around-kernel-memory-fragmentatio_v2.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if kernel_is -lt 4 11; then
			ewarn "With kernel versions below 4.11, bees may severely degrade system performance"
			ewarn "and responsiveness. Especially, the kernel may deadlock while bees is"
			ewarn "running, it's recommended to run at least kernel 4.11."
			ewarn
		elif kernel_is -lt 4 14 29; then
			ewarn "With kernel versions below 4.14.29, bees may generate a lot of bogus WARN_ON()"
			ewarn "messages in the kernel log. These messages can be ignored and this is fixed"
			ewarn "with more recent kernels:"
			ewarn "# WARNING: CPU: 3 PID: 18172 at fs/btrfs/backref.c:1391 find_parent_nodes+0xc41/0x14e0"
			ewarn
		elif kernel_is -lt 5 7 0; then
			ewarn "With kernel versions below 5.4.96 and 5.7, the kernel may hold file system"
			ewarn "locks for a long time while at the same time CPU usage increases when bees is"
			ewarn "operating. bees tries to avoid this behavior by excluding very common extents"
			ewarn "from deduplication. This has only a minimal impact on dedupe effectiveness."
			ewarn
		fi
		if kernel_is -lt 5 1 0; then
			ewarn "IMPORTANT: With kernel versions below 5.1.0, you may experience data corruption"
			ewarn "due to bees using compression in btrfs. You are adviced to use a chronologically"
			ewarn "later kernel, that includes older LTS versions released after 5.0.4:"
			ewarn "Fixed in: 5.1+, 5.0.4+, 4.19.31+, 4.14.108+, 4.9.165+, 4.4.177+, 3.18.137+"
			ewarn "# commit 8e92821 btrfs: fix corruption reading shared and compressed extents after hole punching"
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

		elog "Bees recommends running the latest current kernel for performance and"
		elog "reliability reasons, see README.md."
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
		echo BEES_VERSION=v${PV} >>localconf || die
	fi
}

src_compile() {
	default
	# localconf quotes leak in the systemd unit but are still needed for spaces
	sed -i 's/"//g' scripts/beesd@.service || die
}
