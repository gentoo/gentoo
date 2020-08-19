# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Library for handling root privilege"
HOMEPAGE="http://www.j10n.org/libspt/"
SRC_URI="http://www.j10n.org/${PN}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE="+libtirpc static-libs"
RESTRICT="test"

RDEPEND="!libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
	libtirpc? ( net-libs/libtirpc )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch"
	"${FILESDIR}/${PN}-glibc-2.30.patch"
	"${FILESDIR}/${PN}-rpc.patch"
)

src_prepare() {
	rm aclocal.m4

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with libtirpc)
}
