# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic gkrellm-plugin toolchain-funcs

DESCRIPTION="Get Stock quotes plugin for Gkrellm2"
HOMEPAGE="http://gkrellstock.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellstock/${P}.tar.gz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	dev-perl/libwww-perl
	dev-perl/Finance-Quote"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P/s/S}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5-ldflags.patch
	append-cppflags $($(tc-getPKG_CONFIG) --cflags gtk+-2.0)
	append-flags -fPIC
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install () {
	gkrellm-plugin_src_install

	dobin GetQuote2
}
