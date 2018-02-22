# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="dailystrips automatically downloads your favorite online comics from the web"
HOMEPAGE="http://dailystrips.sourceforge.net/"
SRC_URI="mirror://sourceforge/dailystrips/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-perl/libwww-perl-5.50
	dev-perl/DateTime
	dev-perl/TimeDate"

src_prepare() {
	sed -i -e "s:/usr/share/dailystrips/strips.def:/etc/strips.def:" \
		dailystrips || die "sed dailystrips failed"
	default
}

src_install() {
	dobin dailystrips dailystrips-clean dailystrips-update
	dodoc BUGS CHANGELOG CONTRIBUTORS README* TODO
	insinto /etc
	doins strips.def
}
