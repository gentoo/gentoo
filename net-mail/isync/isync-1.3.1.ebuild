# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MailDir mailbox synchronizer"
HOMEPAGE="http://isync.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
fi

IUSE="libressl sasl ssl zlib"

RDEPEND="
	>=sys-libs/db-4.2:=
	sasl?	( dev-libs/cyrus-sasl )
	ssl?	(
			!libressl?	( >=dev-libs/openssl-0.9.6:0= )
			libressl?	( dev-libs/libressl:0= )
		)
	zlib?	( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND}
	dev-lang/perl
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_with ssl) \
		$(use_with sasl) \
		$(use_with zlib)
}
