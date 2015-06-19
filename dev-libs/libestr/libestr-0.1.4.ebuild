# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libestr/libestr-0.1.4.ebuild,v 1.5 2012/11/20 20:49:40 ago Exp $

EAPI=4

inherit eutils

DESCRIPTION="Library for some string essentials"
HOMEPAGE="http://libestr.adiscon.com/"
SRC_URI="http://libestr.adiscon.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~hppa x86"
IUSE="debug static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure()	{
	econf $(use_enable debug) $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
