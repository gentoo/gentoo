# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Create BitTorrent files easily"
HOMEPAGE="http://www.createtorrent.com/"
SRC_URI="http://www.createtorrent.com/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:[[]ssl[]]:[crypto]:" configure.in || die "sed failed..."
	eapply_user
	eautoreconf
}
