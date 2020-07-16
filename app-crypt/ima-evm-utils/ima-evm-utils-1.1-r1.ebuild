# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="http://linux-ima.sourceforge.net"
SRC_URI="mirror://sourceforge/linux-ima/${P}.tar.gz"

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/keyutils:="
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-configure-use-sys-xattr-bug-649790.patch"
)

src_prepare() {
	default

	sed -i '/^MANPAGE_DOCBOOK_XSL/s:/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl:/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl:' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}
