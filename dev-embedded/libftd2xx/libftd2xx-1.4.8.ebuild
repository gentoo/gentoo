# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library that allows a direct access to a USB device"
HOMEPAGE="http://www.ftdichip.com/Drivers/D2XX.htm"
# NOTE: We could include other arm versions here too.
SRC_URI="
	amd64? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${PN}-x86_64-${PV}.gz -> ${PN}-x86_64-${PV}.tar.gz )
	arm? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${PN}-arm-v6-hf-${PV}.gz -> ${PN}-arm-v6-hf-${PV}.tar.gz )
	x86? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${PN}-i386-${PV}.gz -> ${PN}-i386-${PV}.tar.gz )
"
S="${WORKDIR}"

LICENSE="FTDI LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples"

QA_PREBUILT="*"

src_install() {
	cd release/build || die

	into /opt
	dolib.so ${PN}.so.${PV}
	dosym ${PN}.so.${PV} /opt/$(get_libdir)/${PN}.so.${PV:0:1}
	dosym ${PN}.so.${PV:0:1} /opt/$(get_libdir)/${PN}.so
	insinto /usr/include
	doins "${S}"/release/ftd2xx.h "${S}"/release/WinTypes.h

	dodir /etc/env.d
	echo "LDPATH=\"/opt/$(get_libdir)\"" > "${ED}"/etc/env.d/50libftd2xx || die

	if use examples ; then
		docinto sample
		dodoc -r "${S}"/release/examples
	fi

	dodoc "${S}"/release/ReadMe.txt
}
