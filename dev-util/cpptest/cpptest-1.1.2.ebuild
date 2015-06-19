# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cpptest/cpptest-1.1.2.ebuild,v 1.6 2012/12/16 15:14:49 armin76 Exp $

EAPI=4
inherit eutils

DESCRIPTION="Simple but powerful unit testing framework for C++"
HOMEPAGE="http://cpptest.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

DOCS=( AUTHORS BUGS NEWS README )

src_configure() {
	econf \
		$(use_enable doc) \
		--htmldir=/usr/share/doc/${PF}/html/
}

src_install() {
	default
	prune_libtool_files
}
