# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit gkrellm-plugin toolchain-funcs

IUSE=""
S="${WORKDIR}/${PN}"
DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellmwireless.php"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc x86"

PLUGIN_SO=wireless.so

src_prepare() {
	sed -i \
		-e '/^CC =/s:gcc $(CFLAGS) $(FLAGS):'"$(tc-getCC)"' $(FLAGS) $(CFLAGS):' \
		-e '/-o wireless.so/s: : $(LDFLAGS) :' \
		Makefile
}
