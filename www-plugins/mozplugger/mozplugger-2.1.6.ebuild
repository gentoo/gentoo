# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/mozplugger/mozplugger-2.1.6.ebuild,v 1.1 2015/03/10 15:18:34 xmw Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Streaming media plugin for Mozilla, based on netscape-plugger"
HOMEPAGE="http://mozplugger.mozdev.org/"
SRC_URI="http://${PN}.mozdev.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}-{helper,controller,linker,update}

	insinto /etc
	doins ${PN}rc

	insinto /usr/$(get_libdir)/nsbrowser/plugins
	doins ${PN}.so

	doman ${PN}.7
	dodoc ChangeLog README
}
