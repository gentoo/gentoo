# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="HTML parsing library. It takes HTML tags, text, and calls callbacks for each type of token"
HOMEPAGE="http://msalem.translator.cx/libhtmlparse.html"
SRC_URI="http://msalem.translator.cx/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="static-libs"

DOCS=( AUTHORS BUGS INSTALL ChangeLog NEWS README TODO )

src_unpack() {
	# for some reason, we get a "this does not look like a tar archive" error
	# but the following works... go figure.
	gunzip -c "${DISTDIR}"/${P}.tar.gz > ${P}.tar || die 'gunzip failed'
	tar xf ${P}.tar || die "failed to unpack ${P}.tar"
	rm ${P}.tar || die "rm failed"
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
