# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="A high level C++ network packet sniffing and crafting library"
HOMEPAGE="https://github.com/pellegre/libcrafter"
EGIT_REPO_URI="https://github.com/pellegre/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.3_p20171019-libpcap.patch
)
S=${WORKDIR}/${P}/${PN}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	dodoc "${WORKDIR}"/${P}/README

	find "${ED}" -name '*.la' -delete || die
}
