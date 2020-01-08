# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="http://linux-ima.sourceforge.net"
EGIT_REPO_URI="git://git.code.sf.net/p/linux-ima/ima-evm-utils"

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/keyutils:="
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

src_prepare() {
	default

	sed -i '/^MANPAGE_DOCBOOK_XSL/s:/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl:/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl:' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}
