# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Best-Effort Extent-Same, a btrfs dedup agent"
HOMEPAGE="https://github.com/Zygo/bees"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Zygo/bees.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Zygo/bees/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="tools"

DEPEND="
	>=sys-apps/util-linux-2.30.2
	>=sys-fs/btrfs-progs-4.20.2
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~BTRFS_FS"
ERROR_BTRFS_FS="CONFIG_BTRFS_FS: bees does currently only work with btrfs"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if kernel_is -lt 4 4 3; then
			ewarn "Kernel versions below 4.4.3 lack critical features needed for bees to"
			ewarn "properly operate, so it won't work. It's recommended to run at least"
			ewarn "kernel version 4.11 for best performance and reliability."
			ewarn
		elif kernel_is -lt 4 11; then
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
		fi

		if kernel_is -lt 5 3 4; then
			ewarn "With kernel versions below 5.3.4, bees may trigger a btrfs bug when running"
			ewarn "btrfs-balance in parallel. This may lead to meta-data corruption in the worst"
			ewarn "case. Especially, kernels 5.1.21 and 5.2.21 should be avoided. Kernels 5.0.x"
			ewarn "after 5.0.21 should be safe. In the best case, affected kernels may force"
			ewarn "the device RO without writing corrupted meta-data. More details:"
			ewarn "https://github.com/Zygo/bees/blob/master/docs/btrfs-kernel.md"
			ewarn
		fi

		if kernel_is -lt 5 0 4; then
			ewarn "IMPORTANT: With kernel versions below 5.0.4, you may experience data corruption"
			ewarn "due to bees using compression in btrfs. You are adviced to use a chronologically"
			ewarn "later kernel, that includes older LTS versions released after 5.0.4:"
			ewarn "Fixed in: 5.1+, 5.0.4+, 4.19.31+, 4.14.108+, 4.9.165+, 4.4.177+, 3.18.137+"
			ewarn "# commit 8e92821 btrfs: fix corruption reading shared and compressed extents after hole punching"
			ewarn
		fi

		elog "Bees recommends running the latest current kernel for performance and"
		elog "reliability reasons, see README.md."
	fi
}

src_configure() {
	cat >localconf <<-EOF || die
		LIBEXEC_PREFIX=/usr/libexec
		PREFIX=/usr
		LIBDIR=$(get_libdir)
		DEFAULT_MAKE_TARGET=all
	EOF
	if [[ ${PV} != "9999" ]] ; then
		cat >>localconf <<-EOF || die
			BEES_VERSION=v${PV}
		EOF
	fi
	if use tools; then
		echo OPTIONAL_INSTALL_TARGETS=install_tools >>localconf || die
	fi
}
