# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="\"su\" wrapper which transfers X credentials"
HOMEPAGE="http://fgouget.free.fr/sux/sux-readme.shtml"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ~sparc x86"

RDEPEND="x11-apps/xauth"
DEPEND="${RDEPEND}"
PATCHES=(
	"${FILESDIR}"/${PN}-1.0-xauth-and-home.patch
)

src_install() {
	dobin ${PN}{,term}
	dodoc TODO
	newdoc debian/changelog Debian.changelog
	doman debian/${PN}{,term}.1
}
