# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rpm versionator pax-utils

MY_PV=$(replace_version_separator 2 '-')

SRC_URI_BASE="ftp://ftp.hp.com/pub/softlib2/software1/pubsw-linux"
AMD64_PID="1257348637"
AMD64_VID="80070"
X86_PID="414707558"
X86_VID="80071"

DESCRIPTION="HP Array Configuration Utility Command Line Interface (HPACUCLI, formerly CPQACUXE)"
HOMEPAGE="http://h18000.www1.hp.com/products/servers/linux/documentation.html"
SRC_URI="
	amd64? ( ${SRC_URI_BASE}/p${AMD64_PID}/v${AMD64_VID}/${PN}-${MY_PV}.x86_64.rpm )
	x86? ( ${SRC_URI_BASE}/p${X86_PID}/v${X86_VID}/${PN}-${MY_PV}.i386.rpm )"

LICENSE="hp-proliant-essentials"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/coreutils
	sys-process/procps
	>=sys-apps/util-linux-2.20.1"

S="${WORKDIR}"

HPACUCLI_BASEDIR="/opt/hp/hpacucli"
QA_PREBUILT="${HPACUCLI_BASEDIR:1}/*"
QA_EXECSTACK="${HPACUCLI_BASEDIR:1}/libcpqimgr*.so"

src_install() {
	local MY_S="${S}/opt/compaq/${PN}/bld"

	newsbin "${FILESDIR}"/"${PN}-wrapper-r1" hpacucli
	dosym /usr/sbin/hpacucli /usr/sbin/hpacuscripting

	exeinto "${HPACUCLI_BASEDIR}"
	for bin in "${MY_S}"/.hp*; do
		local basename=$(basename "${bin}")
		newexe "${bin}" ${basename#.}.bin
	done

	insinto "${HPACUCLI_BASEDIR}"
	doins "${MY_S}"/*.so

	dodoc "${MY_S}"/*.txt
	doman "${S}"/usr/man/man*/*

	cat <<-EOF >"${T}"/45${PN}
		LDPATH=${HPACUCLI_BASEDIR}
		EOF
	doenvd "${T}"/45${PN}

	pax-mark m "${D}opt/hp/hpacucli/"*
}
