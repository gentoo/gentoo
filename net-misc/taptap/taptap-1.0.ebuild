# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/taptap/taptap-1.0.ebuild,v 1.1 2010/11/07 20:31:13 ssuominen Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="A program to link two /dev/net/tun to form virtual ethernet"
HOMEPAGE="http://www.munted.org.uk/programming/taptap/"
SRC_URI="http://www.munted.org.uk/programming/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e 's:= -Wall -s:+= -Wall:' \
		-e 's:$(CFLAGS):$(LDFLAGS) &:' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
