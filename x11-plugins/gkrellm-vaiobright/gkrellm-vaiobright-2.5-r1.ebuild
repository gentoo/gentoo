# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-vaiobright/gkrellm-vaiobright-2.5-r1.ebuild,v 1.5 2010/07/22 14:29:35 ssuominen Exp $

inherit gkrellm-plugin

IUSE=""

MY_P=${P/gkrellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Superslim VAIO LCD Brightness Control Plugin for Gkrellm"
SRC_URI="http://nerv-un.net/~dragorn/code/${MY_P}.tar.gz"
HOMEPAGE="http://nerv-un.net/~dragorn/"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="-* x86"

PLUGIN_SO=vaiobright.so

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-textrel.patch \
		"${FILESDIR}"/${P}-fixinfo.patch
}
