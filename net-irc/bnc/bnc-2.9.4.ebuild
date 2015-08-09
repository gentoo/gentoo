# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=${P/-/}
DESCRIPTION="BNC (BouNCe) is used as a gateway to an IRC Server"
HOMEPAGE="http://gotbnc.com/"
SRC_URI="http://gotbnc.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ~s390 sparc x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:./mkpasswd:/usr/bin/bncmkpasswd:' bncsetup || die
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${PN}-2.9.3-64bit.patch
}

src_compile() {
	econf $(use_with ssl) || die "econf failed"
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	mv "${D}"/usr/bin/{,bnc}mkpasswd || die
	dodoc Changelog README example.conf motd
}

pkg_postinst() {
	einfo "You can find an example motd/conf file here:"
	einfo " /usr/share/doc/${PF}/"
}
