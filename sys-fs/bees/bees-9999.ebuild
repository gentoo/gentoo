# Copyright 1999-2018 Gentoo Foundation
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
	>=sys-fs/btrfs-progs-4.1
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
		elog "Bees recommends to run the latest current kernel for performance and"
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
