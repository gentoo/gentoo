# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

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
	use doc && HTML_DOCS=( doc/html/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	default
}
