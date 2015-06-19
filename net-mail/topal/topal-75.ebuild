# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/topal/topal-75.ebuild,v 1.5 2014/08/10 20:46:47 slyfox Exp $

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="Topal is a 'glue' program that links GnuPG and Pine/Alpine"
HOMEPAGE="http://homepage.ntlworld.com/phil.brooke/topal/"
SRC_URI="http://homepage.ntlworld.com/phil.brooke/topal/rel-${PV}/topal-package-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND=">=app-crypt/gnupg-2.0.7-r1
	|| ( net-mail/metamail app-misc/run-mailcap )
	|| ( app-text/dos2unix app-text/hd2u )
	sys-libs/ncurses
	sys-libs/readline"
DEPEND="${RDEPEND}
	virtual/ada
	doc? ( app-text/texlive )"

src_prepare() {
	rm "${S}"/MIME-tool/mime-tool || die
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	use doc || sed -i -e '/pdflatex/s/^/#/' Makefile
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake install \
		INSTALLPATH="${D}"/usr \
		INSTALLPATHDOC="${D}/usr/share/doc/${PF}"
	dohtml "${S}"/*.html
}
