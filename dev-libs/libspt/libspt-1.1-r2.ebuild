# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Library for handling root privilege"
#HOMEPAGE="http://www.j10n.org/libspt/index.html"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="+libtirpc"
RESTRICT="test"

RDEPEND="!libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
	libtirpc? ( net-libs/libtirpc )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch"
	"${FILESDIR}/${PN}-rpc.patch"
)

src_prepare() {
	rm aclocal.m4

	default
	eautoreconf
}

src_configure() {
	econf $(use_with libtirpc)
}
