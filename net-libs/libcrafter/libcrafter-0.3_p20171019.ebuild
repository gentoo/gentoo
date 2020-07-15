# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A high level C++ network packet sniffing and crafting library"
HOMEPAGE="https://github.com/pellegre/libcrafter"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"
S=${WORKDIR}/${PN}
PATCHES=(
	"${FILESDIR}"/${PN}-0.3_p20171019-libpcap.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
