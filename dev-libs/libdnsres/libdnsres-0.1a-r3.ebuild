# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A non-blocking DNS resolver library"
HOMEPAGE="https://www.monkey.org/~provos/libdnsres/"
SRC_URI="https://www.monkey.org/~provos/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

DOCS=( README )
PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
