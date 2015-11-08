# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Provides access to GPIO and other IO functions on the Broadcom BCM2835"
HOMEPAGE="http://www.airspayce.com/mikem/bcm2835/"
SRC_URI="http://www.airspayce.com/mikem/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_install() {
	default
	if use examples; then
		dodoc -r examples
	fi
	if use doc; then
		dohtml -r doc/html/.
	fi
}
