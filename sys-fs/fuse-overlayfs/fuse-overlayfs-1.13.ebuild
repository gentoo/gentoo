# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="FUSE implementation for overlayfs"
HOMEPAGE="https://github.com/containers/fuse-overlayfs"
SRC_URI="https://github.com/containers/fuse-overlayfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

DEPEND="sys-fs/fuse:3"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
