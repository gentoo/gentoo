# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A small bundle of utilities to work with CVS repositories"
HOMEPAGE="https://www.red-bean.com/cvsutils/"
SRC_URI="https://www.red-bean.com/cvsutils/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README THANKS NEWS
}
