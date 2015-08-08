# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A voice enabled application to bring your desktop under your command"
HOMEPAGE="http://perlbox.sourceforge.net/"
SRC_URI="mirror://sourceforge/perlbox/${P}.noarch.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/perl
	 dev-perl/perl-tk
	 app-accessibility/sphinx2
	 app-accessibility/festival
	 app-accessibility/mbrola"

src_install() {
	tar xvf perlbox-voice.ss -C "${D}" || die "tar failed"
	dodoc ${PN}.readme
}
