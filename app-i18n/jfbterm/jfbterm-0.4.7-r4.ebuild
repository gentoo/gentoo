# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic eutils autotools

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support"
HOMEPAGE="http://jfbterm.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/13501/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="debug"

DEPEND=">=sys-libs/ncurses-5.6"
RDEPEND="media-fonts/unifont
	media-fonts/font-misc-misc
	media-fonts/intlfonts"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-sigchld-debian.patch"
	epatch "${FILESDIR}/${P}-no-kernel-headers.patch"
	epatch "${FILESDIR}/${P}-gentoo.patch"

	eautoreconf
}

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /etc /usr/share/fonts/jfbterm
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	mv "${D}"/etc/jfbterm.conf{.sample,}

	doman jfbterm.1 jfbterm.conf.5 || die "doman failed"

	dodoc AUTHORS ChangeLog NEWS README* jfbterm.conf.sample* \
		|| die "dodoc failed"
}
