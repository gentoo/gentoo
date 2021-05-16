# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="Tk based dictionary (German-English) (incl. dictionary itself)"
HOMEPAGE="https://www-user.tu-chemnitz.de/~fri/ding/"
SRC_URI="http://wftp.tu-chemnitz.de/pub/Local/urz/ding/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND=">=dev-lang/tk-8.3"

src_install() {
	dobin ding
	insinto /usr/share/dict
	doins de-en.txt
	doman ding.1
	dodoc CHANGES README

	doicon ding.png
	domenu ding.desktop
}
