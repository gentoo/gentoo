# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="https://github.com/openzfs/zfs"

LICENSE="CDDL MIT"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~sparc"

RDEPEND=">=sys-fs/zfs-2.4.0_rc2-r1"
