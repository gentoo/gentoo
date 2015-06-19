# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-mailwatch/gkrellm-mailwatch-2.4.3-r1.ebuild,v 1.2 2010/11/01 14:19:46 lack Exp $

EAPI="3"
inherit gkrellm-plugin toolchain-funcs eutils

IUSE=""
S=${WORKDIR}/${PN}
DESCRIPTION="A GKrellM2 plugin that shows the status of additional mail boxes"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/mailwatch.php"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

PLUGIN_SO=mailwatch.so

src_prepare() {
	epatch "${FILESDIR}"/${PV}-*
}

src_compile() {
	tc-export CC
	default_src_compile
}
