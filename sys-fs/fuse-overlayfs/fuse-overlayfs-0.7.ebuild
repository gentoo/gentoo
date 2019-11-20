# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="FUSE implementation for overlayfs"
HOMEPAGE="https://github.com/containers/fuse-overlayfs"
SRC_URI="https://github.com/containers/fuse-overlayfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=sys-fs/fuse-3:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
