# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

MY_PV=$(ver_rs 2 '-')

DESCRIPTION="HPE Smart Storage Administrator (HPE SSA) CLI (HPSSACLI, formerly HPACUCLI)"
HOMEPAGE="https://support.hpe.com/connect/s/softwaredetails?language=es&softwareId=MTX_95c2c88d976c467ab58c30279f"
SRC_URI="https://downloads.hpe.com/pub/softlib2/software1/pubsw-linux/p1736097809/v211181/ssacli-${MY_PV}.x86_64.rpm"

LICENSE="hp-proliant-essentials"
SLOT="0"
KEYWORDS="-* amd64"

S="${WORKDIR}"

RDEPEND="sys-libs/glibc"

QA_FLAGS_IGNORED="
	usr/sbin/ssacli
	usr/sbin/ssascripting
	usr/sbin/rmstr
"

src_install() {
	local -r ssacli_bindir="opt/smartstorageadmin/ssacli/bin"

	dosbin "${ssacli_bindir}"/ssacli
	dosbin "${ssacli_bindir}"/ssascripting
	dosbin "${ssacli_bindir}"/rmstr

	dodoc "${ssacli_bindir}/ssacli-${MY_PV}.x86_64.txt"

	gunzip usr/man/man8/ssacli.8.gz || die
	doman usr/man/man8/ssacli.8
}
