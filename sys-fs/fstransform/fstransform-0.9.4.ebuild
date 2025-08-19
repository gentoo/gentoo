# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Tool for in-place filesystem conversion "
HOMEPAGE="https://github.com/cosmos72/fstransform"

SRC_URI="https://github.com/cosmos72/fstransform/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

pkg_postinst() {
	optfeature_header "fstransform requires these optional tools for the file system you wish to convert:"
	optfeature "btrfs_fsck" sys-fs/btrfs-progs
	optfeature "e2fsck" sys-fs/e2fsprogs
	optfeature "jfs_fsck" sys-fs/jfsutils
	optfeature "ntfsfix" sys-fs/ntfs3f[ntfsprog]
	optfeature "reiserfsck" sys-fs/reiserfsprogs
	optfeature "xfs_repair" sys-fs/xfsprogs
}
