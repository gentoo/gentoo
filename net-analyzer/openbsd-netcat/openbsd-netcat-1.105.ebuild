# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="the OpenBSD network swiss army knife"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/src/usr.bin/nc/"
SRC_URI="http://http.debian.net/debian/pool/main/n/netcat-openbsd/netcat-openbsd_${PV}.orig.tar.gz
	http://http.debian.net/debian/pool/main/n/netcat-openbsd/netcat-openbsd_${PV}-7.debian.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x64-macos"

DEPEND="virtual/pkgconfig"
RDEPEND="dev-libs/libbsd"

S=${WORKDIR}/netcat-openbsd-${PV}

PATCHES=( "${WORKDIR}/debian/patches" )

src_install() {
	# avoid name conflict against net-analyzer/netcat
	newbin nc nc.openbsd
	newman nc.1 nc.openbsd.1
	cd "${WORKDIR}/debian"
	newdoc netcat-openbsd.README.Debian README
	dodoc -r examples
}

pkg_postinst() {
	if [[ ${KERNEL} = "linux" ]]; then
		ewarn "FO_REUSEPORT is introduced in linux 3.9. If your running kernel is older"
		ewarn "and kernel header is newer, nc will not listen correctly. Matching the header"
		ewarn "to the running kernel will do. See bug #490246 for details."
	fi
}
