# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/netboot/netboot-0.10.2.ebuild,v 1.2 2011/11/28 11:54:00 phajdan.jr Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="netbooting utility"
HOMEPAGE="http://netboot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-libs/lzo-2
		>=sys-libs/db-4"
RDEPEND="${DEPEND}
		!net-misc/mknbi"

src_prepare() {
	cp -av make.config.in{,.org}
	epatch "${FILESDIR}"/${P}-ldflags.patch
	find "${S}" -name \*.lo -exec rm {} \;
}

src_configure() {
	econf --enable-bootrom --with-gnu-cc86="$(tc-getCC)" \
		--with-gnu-as86="$(tc-getAS)" --with-gnu-ld86="$(tc-getCC)"|| die 'cannot configure'
	# --enable-config-file
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README doc/*
	docinto FlashCard
	dodoc FlashCard/README FlashCard/*.ps
	mv "${D}"/usr/share/misc "${D}"/usr/share/${PN}
	rm -rf "${D}"/usr/lib/netboot/utils

	dodoc "${S}"/mknbi-dos/utils/mntnbi.pl

	insinto /usr/share/vim/vimfiles/syntax
	doins "${S}"/mknbi-mgl/misc/mgl.vim
}
