# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/adifmerg/adifmerg-31-r1.ebuild,v 1.3 2014/12/28 10:07:42 ago Exp $

EAPI=5

MY_P=${P/-}

DESCRIPTION="A small conversion and check utility for ADIF files"
HOMEPAGE="http://jaakko.home.cern.ch/jaakko/Soft/"
SRC_URI="http://jaakko.home.cern.ch/jaakko/Soft/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND="dev-lang/perl"

S=${WORKDIR}/${MY_P}

src_install() {
	dobin adifmerg
	doman doc/adifmerg.1
	dodoc CHANGELOG README

	if use examples; then
		insinto /usr/share/${PN}
		doins -r script
	fi
}
