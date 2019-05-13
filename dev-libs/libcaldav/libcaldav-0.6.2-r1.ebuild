# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library implementing client support for CalDAV"
HOMEPAGE="http://libcaldav.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcaldav/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/glib
	net-misc/curl[ssl,gnutls(+),curl_ssl_gnutls(+)]
"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"

src_configure() {
	econf $(use_enable doc)
}
