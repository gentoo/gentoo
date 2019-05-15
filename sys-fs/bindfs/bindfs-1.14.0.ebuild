# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FUSE filesystem for bind mounting with altered permissions"
HOMEPAGE="https://bindfs.org/"
SRC_URI="https://bindfs.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=sys-fs/fuse-2.9:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="test"

src_configure() {
	econf $(use_enable debug debug-output)
}
