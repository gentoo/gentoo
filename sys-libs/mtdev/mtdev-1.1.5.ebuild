# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Multitouch Protocol Translation Library"
HOMEPAGE="http://bitmath.org/code/mtdev/"
SRC_URI="http://bitmath.org/code/mtdev/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="static-libs"

DEPEND=">=sys-kernel/linux-headers-2.6.31"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
