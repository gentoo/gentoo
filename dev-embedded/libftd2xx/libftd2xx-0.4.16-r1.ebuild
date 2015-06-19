# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/libftd2xx/libftd2xx-0.4.16-r1.ebuild,v 1.4 2013/04/12 22:53:34 ulm Exp $

EAPI=5
inherit multilib

MY_P="${PN}${PV}"

DESCRIPTION="Library that allows a direct access to a USB device"
HOMEPAGE="http://www.ftdichip.com/Drivers/D2XX.htm"
SRC_URI="amd64? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${MY_P}_x86_64.tar.gz )
	x86? ( http://www.ftdichip.com/Drivers/D2XX/Linux/${MY_P}.tar.gz )"

LICENSE="FTDI LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

QA_PREBUILT="*"

S=${WORKDIR}

src_install() {
	use x86 && cd ${MY_P}
	use amd64 && cd ${MY_P}_x86_64

	into /opt
	dolib.so ${PN}.so.${PV}
	dosym ${PN}.so.${PV} /opt/$(get_libdir)/${PN}.so.${PV:0:1}
	dosym ${PN}.so.${PV:0:1} /opt/$(get_libdir)/${PN}.so
	insinto /usr/include
	doins ftd2xx.h WinTypes.h

	dodir /etc/env.d
	echo "LDPATH=\"/opt/$(get_libdir)\"" > ${D}/etc/env.d/50libftd2xx || die
	if use examples ; then
		find sample lib_table '(' -name '*.so' -o -name '*.[oa]' ')' -exec rm -f {} +
		insinto /usr/share/doc/${PF}
		doins -r sample
		insinto /usr/share/doc/${PF}/sample
		doins -r lib_table
	fi

	dodoc Config.txt
	use x86 && dodoc faq.txt readme.dat
	use amd64 && dodoc FAQ.txt README.dat
}
