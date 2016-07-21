# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Shout is a program for creating mp3 stream for use with icecast or shoutcast"
HOMEPAGE="http://www.icecast.org"
SRC_URI="http://icecast.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~ppc sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/variables.diff \
		"${FILESDIR}"/ldflags.patch \
		"${FILESDIR}"/implicitdecls.patch \
		"${FILESDIR}"/${P}-overflow.patch
	rm -f sock.o
	sed -i -e "s/-ansi//" configure
}

src_compile() {
	tc-export CC
	econf --sysconfdir=/etc/shout \
		--localstatedir=/var
	emake || die "emake failed."
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."
	keepdir /var/log/shout
	fowners root:audio /var/log/shout
	fperms 775 /var/log/shout
	fperms 755 /etc/shout
	fperms 644 /etc/shout/shout.conf.dist
	dodoc BUGS CREDITS README.shout TODO
}
