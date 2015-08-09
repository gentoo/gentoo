# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="https://launchpad.net/ssm"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=">=sci-libs/mmdb-1.23:0"
RDEPEND="${DEPEND}
	!<sci-libs/ccp4-libs-6.1.3-r10"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-mmdb.patch \
		"${FILESDIR}"/${P}-pc.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}
