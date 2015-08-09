# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base

DESCRIPTION="C library implementing client support for CalDAV"
HOMEPAGE="http://libcaldav.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcaldav/${P}.tar.gz"

LICENSE="GPL-3"
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
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)
"

src_configure() {
	econf $(use_enable doc)
}
