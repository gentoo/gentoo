# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bashdb/bashdb-4.2.0.8.ebuild,v 1.2 2013/05/05 23:23:05 vapier Exp $

EAPI="4"

MY_P="${PN}-${PV:0:3}-${PV:4}"
DESCRIPTION="bash source code debugging"
HOMEPAGE="http://bashdb.sourceforge.net/"
SRC_URI="mirror://sourceforge/bashdb/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!>=app-shells/bash-${PV:0:1}.$((${PV:2:1}+1))"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# We don't install this, so don't bother building it. #468044
	sed -i 's:texi2html:true:' doc/Makefile.in || die
}
