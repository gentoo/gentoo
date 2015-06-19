# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/mercator/mercator-0.3.3.ebuild,v 1.5 2015/01/27 07:57:32 mr_bones_ Exp $

EAPI=5
inherit eutils

DESCRIPTION="WorldForge library primarily aimed at terrain"
HOMEPAGE="http://www.worldforge.org/index.php/components/mercator/"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="doc"
SLOT="0"

RDEPEND=">=dev-games/wfmath-1"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default
	use doc && dohtml -r doc/html/*
	prune_libtool_files
}
