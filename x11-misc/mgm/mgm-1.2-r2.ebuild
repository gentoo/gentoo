# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Moaning Goat Meter: load and status meter written in Perl"
HOMEPAGE="http://www.linuxmafia.com/mgm"
SRC_URI="http://downloads.xiph.org/releases/mgm/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Tk"

HTML_DOCS=( doc/. )

src_install() {
	exeinto /usr/share/mgm
	doexe mgm
	dosym ../share/mgm/mgm /usr/bin/mgm

	insinto /usr/share/mgm
	doins -r lib modules

	einstalldocs
}
