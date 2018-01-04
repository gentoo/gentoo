# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic gkrellm-plugin toolchain-funcs

DESCRIPTION="Get Stock quotes plugin for Gkrellm2"
HOMEPAGE="http://gkrellstock.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellstock/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	app-admin/gkrellm:2[X]
	dev-libs/glib:2
	x11-libs/gtk+:2
	dev-perl/libwww-perl
	dev-perl/Finance-Quote"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P/s/S}"
PATCHES=( "${FILESDIR}"/${PN}-0.5-ldflags.patch )

src_configure() {
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
