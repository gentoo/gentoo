# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Perl IRC Statistics Generator"
HOMEPAGE="http://pisg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-perl/Text-Iconv"

src_prepare() {
	default

	sed -i \
		-e 's!lang\.txt!/usr/share/pisg/lang.txt!' \
		-e 's!layout/!/usr/share/pisg/layout/!' \
		modules/Pisg.pm || die "sed failed"
}

src_install() {
	perl_set_version

	dobin pisg

	insinto "${VENDOR_LIB}"
	doins -r modules/.

	insinto /usr/share/pisg
	doins -r gfx layout lang.txt

	dodoc docs/{FORMATS,pisg-doc.txt} \
		docs/dev/API pisg.cfg README
	doman docs/pisg.1

	docinto html
	dodoc docs/pisg-doc.html
}

pkg_postinst() {
	einfo "The pisg images have been installed in /usr/share/pisg/gfx"
}
