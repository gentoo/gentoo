# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils gkrellm-plugin toolchain-funcs

MY_P=${P/-/_}

DESCRIPTION="an Image-Watcher-Plugin for GKrellM2"
SRC_URI="mirror://sourceforge/gkrellkam/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellkam.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 ppc sparc alpha amd64"

RDEPEND="net-misc/wget
	 app-admin/gkrellm[X]"
DEPEND="${RDEPEND}"

PLUGIN_SO=gkrellkam2.so
PLUGIN_DOCS="example.list"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install () {
	gkrellm-plugin_src_install
	doman gkrellkam-list.5
}
