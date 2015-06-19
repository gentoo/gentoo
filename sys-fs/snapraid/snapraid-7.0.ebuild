# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/snapraid/snapraid-7.0.ebuild,v 1.1 2014/12/21 23:25:52 ottxor Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="a backup program for disk array for home media centers"
HOMEPAGE="http://snapraid.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( "AUTHORS" "HISTORY" "README" "TODO" "snapraid.conf.example" )

AUTOTOOLS_IN_SOURCE_BUILD=1
