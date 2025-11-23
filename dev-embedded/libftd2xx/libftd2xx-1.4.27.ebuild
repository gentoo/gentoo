# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library that allows a direct access to a USB device"
HOMEPAGE="https://ftdichip.com/drivers/d2xx-drivers/"
# NOTE: We could include other arm versions here too.
SRC_URI="
	amd64? ( https://ftdichip.com/wp-content/uploads/2022/07/${PN}-x86_64-${PV}.tgz -> ${PN}-x86_64-${PV}.tar.gz )
	arm? ( https://ftdichip.com/wp-content/uploads/2022/07/${PN}-arm-v6-hf-${PV}.tgz -> ${PN}-arm-v6-hf-${PV}.tar.gz )
	x86? ( https://ftdichip.com/wp-content/uploads/2022/07/${PN}-x86_32-${PV}.tgz -> ${PN}-x86_32-${PV}.tar.gz )
"
S="${WORKDIR}"

LICENSE="FTDI LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples"

QA_PREBUILT="*"

src_install() {
	cd release/build || die

	dolib.so ${PN}.so.${PV}
	dosym ${PN}.so.${PV} /usr/$(get_libdir)/${PN}.so.${PV:0:1}
	dosym ${PN}.so.${PV:0:1} /usr/$(get_libdir)/${PN}.so
	insinto /usr/include
	doins "${S}"/release/ftd2xx.h "${S}"/release/WinTypes.h

	if use examples ; then
		docinto sample
		dodoc -r "${S}"/release/examples
	fi

	dodoc "${S}"/release/ReadMe.txt
}
