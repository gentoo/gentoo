# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

MY_P="wireless-regdb-${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Binary regulatory database for CRDA"
HOMEPAGE="http://wireless.kernel.org/en/developers/Regulatory"
SRC_URI="https://www.kernel.org/pub/software/network/${PN}/${MY_P}.tar.xz"
LICENSE="ISC"
SLOT="0"

KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	einfo "Recompiling regulatory.bin from db.txt would break CRDA verify. Installing untouched binary version."
}

src_install() {
	insinto /usr/$(get_libdir)/crda/
	doins regulatory.bin

	insinto /etc/wireless-regdb/pubkeys
	doins linville.key.pub.pem

	doman regulatory.bin.5
	dodoc README db.txt
}
