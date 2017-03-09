# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="command-line program for basic numeric, textual and statistical operations"
HOMEPAGE="http://www.gnu.org/software/datamash/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

CDEPEND="
	nls? ( sys-devel/gettext )
"
RDEPEND="
	nls? ( virtual/libintl )
"
DEPEND="
	${CDEPEND}
	${RDEPEND}
"

src_configure() {
	econf $(use_enable nls) --with-openssl=no
}
