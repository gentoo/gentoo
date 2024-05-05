# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dailystrips automatically downloads your favorite online comics from the web"
HOMEPAGE="https://dailystrips.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/dailystrips/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/DateTime
	dev-perl/TimeDate"

src_prepare() {
	default
	sed -i -e "s:/usr/share/dailystrips/strips.def:${EPREFIX}/etc/strips.def:" \
		dailystrips || die "sed dailystrips failed"
}

src_install() {
	dobin dailystrips dailystrips-clean dailystrips-update
	dodoc BUGS CHANGELOG CONTRIBUTORS README* TODO
	insinto /etc
	doins strips.def
}
