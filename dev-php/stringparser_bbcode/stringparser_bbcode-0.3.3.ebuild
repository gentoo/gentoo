# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/stringparser_bbcode/stringparser_bbcode-0.3.3.ebuild,v 1.3 2014/08/10 21:05:52 slyfox Exp $

EAPI="4"

DESCRIPTION="A PHP class to parse BB codes"
HOMEPAGE="http://christian-seiler.de/projekte/php/bbcode/index_en.html"
SRC_URI="http://christian-seiler.de/projekte/php/bbcode/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/php"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins -r src/*

	dodoc AUTHORS ChangeLog THANKS
	if use doc ; then
		dohtml -r doc/*
	fi
}
