# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="Conversion tools for block devices"
HOMEPAGE="https://github.com/g2p/blocks"
SRC_URI=""
EGIT_REPO_URI="https://github.com/g2p/blocks.git"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS=""
IUSE="+minimal"

DEPEND="
	dev-python/maintboot
	>=dev-python/pyparted-3.10[${PYTHON_USEDEP}]
	>=dev-python/python-augeas-0.5.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	>=sys-block/parted-2.3
	!minimal? (
		sys-fs/btrfs-progs
		sys-fs/lvm2
		sys-fs/bcache-tools
		sys-fs/nilfs-utils
		sys-fs/cryptsetup
		sys-fs/reiserfsprogs
		sys-fs/xfsprogs
		sys-fs/e2fsprogs
	)
"

# NEVER, EVER run filesystem tests during build
RESTRICT="test"

python_test() {
	cd tests || die
	emake
}

pkg_postinst() {
	if use minimal; then
		einfo "For filesystem support you need to install:"
		echo
		einfo "btrfs:        sys-fs/btrfs-progs"
		einfo "LVM:          sys-fs/lvm2"
		einfo "bcache:       sys-fs/bcache-tools"
		einfo "NILFS:        sys-fs/nilfs-utils"
		einfo "crypted FS:   sys-fs/cryptsetup"
		einfo "reiser:       sys-fs/reiserfsprogs"
		einfo "XFS:          sys-fs/xfsprogs"
		einfo "EXT2/3/4:     sys-fs/e2fsprogs"
		echo
	fi
}
