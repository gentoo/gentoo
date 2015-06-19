# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mpage/mpage-2.5.6-r1.ebuild,v 1.5 2012/07/29 17:10:04 armin76 Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Many to one page printing utility"
HOMEPAGE="http://www.mesa.nl/"
SRC_URI="http://www.mesa.nl/pub/${PN}/${P}.tgz"

KEYWORDS="amd64 ppc x86"
LICENSE="freedist"
SLOT="0"
IUSE=""

src_prepare() {
	sed -i Makefile \
		-e '/^CFLAGS/s|=.*| += $(DEFS)|g' \
		-e 's|$(CFLAGS) -o|$(LDFLAGS) &|g' \
		|| die "sed Makefile"
	EPATCH_SOURCE="${FILESDIR}" epatch \
		01_previous_changes.patch 10_bts354935_fix_fontdefs.patch \
		20_bts416573_manpage_fixes.patch 30_bts443280_libdir_manpage.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PREFIX=/usr \
		MANDIR=/usr/share/man/man1
}

src_install () {
	emake \
		PREFIX="${D}/usr" \
		MANDIR="${D}/usr/share/man/man1" install
	dodoc CHANGES Encoding.format FAQ NEWS README TODO
}
