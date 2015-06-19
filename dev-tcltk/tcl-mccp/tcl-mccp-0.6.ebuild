# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tcl-mccp/tcl-mccp-0.6.ebuild,v 1.5 2015/03/20 10:38:19 jlec Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="mccp extension to TCL"
HOMEPAGE="http://tcl-mccp.sf.net/"
SRC_URI="mirror://sourceforge/tcl-mccp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs"

DEPEND="dev-lang/tcl:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-flags.patch )
