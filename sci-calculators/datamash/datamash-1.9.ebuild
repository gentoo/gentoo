# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line program for basic numeric, textual and statistical operations"
HOMEPAGE="https://www.gnu.org/software/datamash/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls openssl"

RDEPEND="
	nls? ( virtual/libintl )
	openssl? ( dev-libs/openssl:= )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	openssl? ( dev-libs/openssl:= )
"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with openssl)
}
