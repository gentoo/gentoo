# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

DESCRIPTION="Log rotation software"
HOMEPAGE="https://github.com/fordmason/cronolog"
SRC_URI="http://cronolog.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README TODO )

src_prepare() {
	default
	epatch "${FILESDIR}/${PV}-patches"/*.txt "${FILESDIR}/${P}-umask.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
