# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Interfaces with LastPass.com from the command line."
HOMEPAGE="https://github.com/lastpass/lastpass-cli"
SRC_URI="https://github.com/lastpass/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="libressl X +pinentry"

RDEPEND="
	X? ( || ( x11-misc/xclip x11-misc/xsel ) )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-misc/curl
	dev-libs/libxml2
	pinentry? ( app-crypt/pinentry )
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
"

src_prepare() {
	# Do not include headers from /usr/local/include
	sed -i -e 's:-I/usr/local/include::' Makefile || die
	default
	tc-export CC
}

src_compile() {
	emake PREFIX="${EPREFIX}/usr" COMPDIR="$(get_bashcompdir)" all doc-man
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install install-doc
}
