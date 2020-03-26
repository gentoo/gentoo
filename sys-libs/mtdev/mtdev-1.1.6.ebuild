# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multitouch Protocol Translation Library"
HOMEPAGE="https://bitmath.org/code/mtdev/"
SRC_URI="https://bitmath.org/code/mtdev/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND=">=sys-kernel/linux-headers-2.6.31"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
