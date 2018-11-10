# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="https://launchpad.net/ssm"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+ccp4 static-libs"

DEPEND="
	sci-libs/mmdb:2
	ccp4? ( sci-libs/libccp4 )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=( $(use_enable ccp4) )
	autotools-utils_src_configure
}
