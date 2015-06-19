# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/qfits/qfits-6.2.0.ebuild,v 1.5 2012/08/03 20:02:20 bicatali Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="ESO stand-alone C library offering easy access to FITS files"
HOMEPAGE="http://www.eso.org/projects/aot/qfits/"
SRC_URI="ftp://ftp.hq.eso.org/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"
DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-{ttest,open}.patch )

src_install() {
	autotools-utils_src_install
	use doc && dohtml html/*
}
