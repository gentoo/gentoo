# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command-line program for basic numeric, textual and statistical operations"
HOMEPAGE="https://www.gnu.org/software/datamash/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linux-crypto nls openssl"

CDEPEND="
	openssl? ( dev-libs/openssl )
"
RDEPEND="
	${CDEPEND}
	nls? ( virtual/libintl )
"
BDEPEND="
	${CDEPEND}
	nls? ( sys-devel/gettext )
"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with openssl) \
		$(use_with linux-crypto)
}
