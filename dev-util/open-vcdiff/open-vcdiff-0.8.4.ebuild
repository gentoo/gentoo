# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/open-vcdiff/open-vcdiff-0.8.4.ebuild,v 1.1 2014/07/15 01:42:21 floppym Exp $

EAPI=5

inherit eutils

DESCRIPTION="An encoder/decoder for the VCDIFF (RFC3284) format"
HOMEPAGE="http://code.google.com/p/open-vcdiff/"
SRC_URI="http://dev.gentoo.org/~floppym/dist/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}
