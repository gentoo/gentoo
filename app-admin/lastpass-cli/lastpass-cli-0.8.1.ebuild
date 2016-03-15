# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Interfaces with LastPass.com from the command line."
HOMEPAGE="https://github.com/lastpass/lastpass-cli"
SRC_URI="https://github.com/lastpass/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
IUSE="libressl X +pinentry"

RDEPEND="
	X? ( || ( x11-misc/xclip x11-misc/xsel ) )
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	net-misc/curl
	dev-libs/libxml2
	pinentry? ( app-crypt/pinentry )
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
"

src_prepare() {
	tc-export CC
}

src_compile() {
	emake PREFIX="${EPREFIX}/usr"
	emake PREFIX="${EPREFIX}/usr" doc-man
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install-doc
}
