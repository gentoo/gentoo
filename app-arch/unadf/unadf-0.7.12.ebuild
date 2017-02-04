# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_PN="adflib"

DESCRIPTION="Extract files from Amiga adf disk images"
SRC_URI="http://lclevy.free.fr/${MY_PN}/${MY_PN}-${PV}.tar.bz2"
HOMEPAGE="http://lclevy.free.fr/adflib/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"
DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
