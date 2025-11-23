# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A FUSE and libmtp based filesystem for accessing MTP devices"
HOMEPAGE="https://github.com/JasonFerrara/jmtpfs"
SRC_URI="https://github.com/JasonFerrara/jmtpfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=media-libs/libmtp-1.1.0
	>=sys-fs/fuse-2.6:0
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default
	eautoreconf
}
