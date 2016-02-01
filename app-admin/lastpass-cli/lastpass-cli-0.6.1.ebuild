# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Interfaces with LastPass.com from the command line."
SRC_URI="https://github.com/lastpass/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/lastpass/lastpass-cli"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="libressl X +pinentry"

RDEPEND="
	X? ( || ( x11-misc/xclip x11-misc/xsel ) )
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	net-misc/curl
	dev-libs/libxml2
	pinentry? ( app-crypt/pinentry )
"
DEPEND="${RDEPEND} app-text/asciidoc"

src_prepare() {
	sed -i 's/install -s/install/' Makefile || die "Could not remove stripping"
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
