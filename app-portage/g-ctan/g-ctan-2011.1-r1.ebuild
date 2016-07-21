# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Generate and install ebuilds from the TeXLive package manager"
HOMEPAGE="https://launchpad.net/g-ctan"
SRC_URI="https://launchpad.net/g-ctan/${PV/\.*/}/${PV}/+download/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

IUSE=""
DEPEND=""
RDEPEND="~app-text/texlive-2011
	app-arch/xz-utils
	>=dev-libs/libpcre-0.7.6"
