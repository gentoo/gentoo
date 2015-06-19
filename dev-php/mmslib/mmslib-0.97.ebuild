# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mmslib/mmslib-0.97.ebuild,v 1.2 2012/01/28 14:06:34 mabi Exp $

EAPI=4

DESCRIPTION="library for encoding, decoding, and sending MMSes"
HOMEPAGE="http://www.hellkvist.org/software/#MMSLIB"
SRC_URI="http://www.hellkvist.org/software/mmslib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="dev-lang/php"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins mmslib.php

	dodoc README
	use examples && dodoc -r samples content
}
