# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools

DESCRIPTION="A DNA sequencing data management framework - C/C++ API"
HOMEPAGE="http://campagnelab.org/software/goby/"
SRC_URI="http://chagall.med.cornell.edu/goby/releases/archive/release-goby_${PV}/goby_${PV}-cpp.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/protobuf-2.4.1
	>=dev-libs/libpcre-8.12"
RDEPEND="${DEPEND}"

S="${WORKDIR}/goby_${PV}/cpp"

src_prepare() {
	eautoreconf
}
