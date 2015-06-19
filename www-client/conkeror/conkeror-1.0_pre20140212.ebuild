# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/conkeror/conkeror-1.0_pre20140212.ebuild,v 1.3 2014/06/14 10:31:35 phajdan.jr Exp $

EAPI=5

inherit eutils toolchain-funcs fdo-mime

DESCRIPTION="A Mozilla-based web browser whose design is inspired by GNU Emacs"
HOMEPAGE="http://conkeror.org/"
# snapshot from http://repo.or.cz/w/conkeror.git
# conkeror.png is derived from http://commons.wikimedia.org/wiki/File:Conker.jpg
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.gz
	http://dev.gentoo.org/~ulm/distfiles/${PN}.png"

# CC-BY-SA-3.0 for conkeror.png
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 ) CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="|| ( >=www-client/firefox-5.0 >=www-client/firefox-bin-23.0 )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${P}.tar.gz
	cp "${DISTDIR}/${PN}.png" . || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	insinto /usr/share/${PN}
	doins -r branding chrome components content defaults help locale modules \
		search-engines style tests
	doins application.ini *.manifest Info.plist

	exeinto /usr/libexec/${PN}
	doexe conkeror-spawn-helper
	dosym ../../libexec/${PN}/conkeror-spawn-helper \
		/usr/share/${PN}/conkeror-spawn-helper

	newbin "${FILESDIR}/conkeror-r2.sh" conkeror
	domenu "${FILESDIR}/conkeror.desktop"
	doicon "${WORKDIR}/conkeror.png"

	doman contrib/man/conkeror.1
	dodoc CREDITS
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
