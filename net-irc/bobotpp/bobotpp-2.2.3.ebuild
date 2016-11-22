# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A flexible IRC bot scriptable in scheme"
HOMEPAGE="http://unknownlamer.org/code/bobot.html"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="guile"

DEPEND="guile? ( dev-scheme/guile )"
RDEPEND="${DEPEND}"

HTML_DOCS=( documentation/index.html )
PATCHES=(
	"${FILESDIR}"/${PN}-2.2.2-asneeded.patch
	"${FILESDIR}"/${PN}-2.2.3-stdout.patch
	"${FILESDIR}"/${PN}-2.2.3-fix-c++14.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-crypt \
		$(use_enable guile scripting)
}

src_install() {
	default
	docinto examples
	dodoc -r examples/config examples/scripts

	dosym bobot++.info /usr/share/info/bobotpp.info
}

pkg_postinst() {
	elog "You can find a sample configuration file set in"
	elog "${EPREFIX}/usr/share/doc/${PF}/example-config"
}
