# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libservicelog/libservicelog-1.1.15.ebuild,v 1.1 2015/06/04 05:54:26 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="Provides a library for logging service-related events"
SRC_URI="mirror://sourceforge/linux-diag/${P}.tar.gz"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE="static-libs"

DEPEND="
	dev-db/sqlite:=
	sys-libs/librtas
"
RDEPEND="
	${DEPEND}
	virtual/logger
"

DOCS=( ChangeLog )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
