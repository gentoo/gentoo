# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library that allows a direct access to a USB device"
HOMEPAGE="https://www.ftdichip.com/drivers/d2xx-drivers/"
# NOTE: We could include other arm versions here too.
MY_URI="https://ftdichip.com/wp-content/uploads/2025/03"
SRC_URI="
	amd64? ( ${MY_URI}/${PN}-linux-x86_64-${PV}.tgz -> ${PN}-x86_64-${PV}.tar.gz )
	arm? ( ${MY_URI}/${PN}-linux-arm-v6-hf-${PV}.tgz -> ${PN}-arm-v6-hf-${PV}.tar.gz )
	x86? ( ${MY_URI}/${PN}-linux-x86_32-${PV}.tgz -> ${PN}-x86_32-${PV}.tar.gz )
"
S="${WORKDIR}"

LICENSE="FTDI LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples"

QA_PREBUILT="*"

src_install() {
	local myarch
	if use amd64 ; then
		myarch="linux-x86_64"
	elif use x86 ; then
		myarch="linux-x86_32"
	elif use arm ; then
		myarch="linux-arm-v6-hf"
	fi

	cd "${myarch}" || die

	dolib.so ${PN}.so
	dosym ${PN}.so /usr/$(get_libdir)/${PN}.so.${PV:0:1}
	dosym ${PN}.so.${PV:0:1} /usr/$(get_libdir)/${PN}.so.${PV}
	insinto /usr/include
	doins ftd2xx.h WinTypes.h

	if use examples ; then
		docinto sample
		dodoc -r examples
	fi

	dodoc release-notes.txt
}
