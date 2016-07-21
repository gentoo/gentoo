# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${PN}-${PV:0:3}-${PV:4}"
DESCRIPTION="bash source code debugging"
HOMEPAGE="http://bashdb.sourceforge.net/"
SRC_URI="mirror://sourceforge/bashdb/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="!>=app-shells/bash-${PV:0:1}.$((${PV:2:1}+1))"

S="${WORKDIR}/${MY_P}"

# Unfortunately, not all tests pass.
RESTRICT="test"

src_prepare() {
	default
	# We don't install this, so don't bother building it. #468044
	sed -i 's:texi2html:true:' doc/Makefile.in || die
}
