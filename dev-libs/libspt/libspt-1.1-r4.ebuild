# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for handling root privilege"
HOMEPAGE="http://www.j10n.org/libspt/"
SRC_URI="http://www.j10n.org/${PN}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ~ppc64 sparc x86"
IUSE="suid"
RESTRICT="test"

RDEPEND="net-libs/libtirpc"
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
		--disable-static \
		--with-libtirpc
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die

	if use suid; then
		fperms 4755 /usr/libexec/sptagent
	fi
}
