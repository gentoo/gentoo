# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unadf/unadf-0.7.12.ebuild,v 1.1 2013/12/29 00:26:30 robbat2 Exp $

EAPI=5

inherit autotools eutils

MY_PN="adflib"

DESCRIPTION="Extract files from Amiga adf disk images"
SRC_URI="http://lclevy.free.fr/${MY_PN}/${MY_PN}-${PV}.tar.bz2"
HOMEPAGE="http://lclevy.free.fr/adflib/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc-macos ~sparc-solaris ~x86 ~x86-interix ~x86-linux ~x86-solaris"
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
