# Copyright 2003-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Copies DVD .vob files to harddisk, decrypting them on the way"
HOMEPAGE="https://github.com/barak/vobcopy"
SRC_URI="https://github.com/barak/vobcopy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="media-libs/libdvdread:0="

src_configure() {
	eautoreconf
	econf
}
