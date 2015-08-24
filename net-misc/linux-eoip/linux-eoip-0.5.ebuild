# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils

DESCRIPTION="Linux support for proprietary MIkrotik EoIP protocol"
HOMEPAGE="https://code.google.com/p/linux-eoip/"
SRC_URI="https://linux-eoip.googlecode.com/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/lzo:2
	"

RDEPEND="${DEPEND}"
DOCS=( README )

src_prepare() {
	esvn_clean
	sed -e 's/bin_PROGRAMS/sbin_PROGRAMS/g' -i Makefile.am
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	insinto /etc
	doins vip.cfg eoip.cfg
}
