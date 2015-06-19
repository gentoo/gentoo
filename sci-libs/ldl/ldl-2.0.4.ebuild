# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ldl/ldl-2.0.4.ebuild,v 1.2 2015/02/22 00:46:04 mattst88 Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils

MY_PN=LDL

DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/ldl"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"
DEPEND="sci-libs/ufconfig"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-2.0.3-autotools.patch )
DOCS=( README.txt Doc/ChangeLog )

S="${WORKDIR}/${MY_PN}"

src_install() {
	autotools-utils_src_install
	use doc && dodoc Doc/ldl_userguide.pdf
}
