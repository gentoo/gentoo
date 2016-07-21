# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic

DESCRIPTION="This is p0f version 3 dlfunc library for Exim"
HOMEPAGE="http://dist.epipe.com/exim/"
SRC_URI="http://dist.epipe.com/exim/exim-p0f3-dlfunc-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="mail-mta/exim[dlfunc]"
RDEPEND=">=net-analyzer/p0f-3.05_beta
	${DEPEND}"
S="${WORKDIR}/exim-p0f3-dlfunc-${PV}"

src_configure()	{
	append-cppflags "-I/usr/include/exim"
	econf
}

src_install()	{
	default
	prune_libtool_files --all
}
