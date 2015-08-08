# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="https://launchpad.net/ssm"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+ccp4 static-libs"

DEPEND="
	>=sci-libs/mmdb-1.23:2
	ccp4? ( >=sci-libs/ccp4-libs-6.1.3-r10 )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=( $(use_enable ccp4) )
	autotools-utils_src_configure
}
