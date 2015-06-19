# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/pisg/pisg-0.73-r1.ebuild,v 1.5 2014/11/10 22:50:24 dilfridge Exp $

EAPI=5

inherit perl-module

DESCRIPTION="Perl IRC Statistics Generator"
HOMEPAGE="http://pisg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

IUSE=""

RDEPEND="dev-perl/Text-Iconv"
DEPEND=">=sys-apps/sed-4"

src_prepare() {
	sed -i \
		-e 's!lang\.txt!/usr/share/pisg/lang.txt!' \
		-e 's!layout/!/usr/share/pisg/layout/!' \
		modules/Pisg.pm || die "sed failed"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	perl_set_version

	dobin pisg || die "dobin failed"

	insinto "${VENDOR_LIB}"
	doins -r modules/.

	insinto /usr/share/pisg
	doins -r gfx layout lang.txt

	dodoc docs/{FORMATS,pisg-doc.txt} \
		docs/dev/API pisg.cfg README
	doman docs/pisg.1
	dohtml docs/pisg-doc.html
}

pkg_postinst() {
	einfo "The pisg images have been installed in /usr/share/pisg/gfx"
}
