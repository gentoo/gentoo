# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="WorldForge library primarily aimed at terrain"
HOMEPAGE="https://www.worldforge.org/index.php/components/mercator/"
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
