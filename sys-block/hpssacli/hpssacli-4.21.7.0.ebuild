# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV=$(ver_rs 2 '-')

DESCRIPTION="HPE Smart Storage Administrator (HPE SSA) CLI (HPSSACLI, formerly HPACUCLI)"
HOMEPAGE="https://support.hpe.com/hpesc/public/swd/detail?swItemId=MTX_8484363847dd4e5ca2970188b7"
SRC_URI="https://downloads.hpe.com/pub/softlib2/software1/pubsw-linux/p1857046646/v183344/ssacli-${MY_PV}.x86_64.rpm"

LICENSE="hp-proliant-essentials"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="mirror bindist"

S="${WORKDIR}"

src_install() {
	local -r ssacli_bindir="opt/smartstorageadmin/ssacli/bin"

	dosbin "${ssacli_bindir}"/ssacli
	dosbin "${ssacli_bindir}"/ssascripting
	dosbin "${ssacli_bindir}"/rmstr

	dodoc "${ssacli_bindir}/ssacli-${MY_PV}.x86_64.txt"

	gunzip usr/man/man8/ssacli.8.gz || die
	doman usr/man/man8/ssacli.8
}
