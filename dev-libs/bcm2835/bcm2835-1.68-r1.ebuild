# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Provides access to GPIO and other IO functions on the Broadcom BCM2835"
HOMEPAGE="https://www.airspayce.com/mikem/bcm2835/"
SRC_URI="https://www.airspayce.com/mikem/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="doc examples"

BDEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	default
}
