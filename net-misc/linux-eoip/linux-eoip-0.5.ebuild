# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vcs-clean

DESCRIPTION="Linux support for proprietary MIkrotik EoIP protocol"
HOMEPAGE="https://code.google.com/p/linux-eoip/"
SRC_URI="https://linux-eoip.googlecode.com/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/lzo:2"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-sbin-automake.patch )

src_prepare() {
	default
	esvn_clean
	eautoreconf
}

src_install() {
	default

	insinto /etc
	doins vip.cfg eoip.cfg
}
