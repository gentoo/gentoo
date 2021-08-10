# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Use structural criteria to grep and index text, SGML, XML and HTML and filter"
SRC_URI="ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/${P}.tar.gz"
HOMEPAGE="https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	default
	sed -i -e "s:/usr/lib:/etc:g" sgrep.1 || die
}

src_configure() {
	econf --datadir="${EPREFIX}"/etc
}

src_install() {
	dobin sgrep
	doman sgrep.1
	dodoc AUTHORS ChangeLog NEWS README sample.sgreprc
	insinto /etc
	newins sample.sgreprc sgreprc
}
