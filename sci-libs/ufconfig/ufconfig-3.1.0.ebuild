# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ufconfig/ufconfig-3.1.0.ebuild,v 1.13 2010/07/09 10:04:36 ssuominen Exp $

MY_PN=UFconfig

DESCRIPTION="Common configuration scripts for the SuiteSparse libraries"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/UFconfig"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${MY_PN}"

src_install() {
	insinto /usr/include
	doins UFconfig.h || die "failed to install include file"
	dodoc README.txt || die
}
