# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools multilib

MY_PN="dxsamples"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Samples for IBM Data Explorer"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${MY_P}.tar.gz
	mirror://gentoo/${P}-install.patch.bz2"
LICENSE="IBM"
SLOT="0"

S="${WORKDIR}/${MY_P}"

KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=sci-visualization/opendx-4.4.4-r2"
DEPEND="${RDEPEND}"

src_prepare() {
	#absolutely no javadx for now
	epatch "${FILESDIR}/${P}-nojava.patch"
	epatch "${WORKDIR}/${P}-install.patch"
	eautoreconf
}
