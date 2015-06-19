# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ifenslave/ifenslave-1.1.0-r6.ebuild,v 1.8 2014/08/28 09:19:42 kumba Exp $

EAPI=4

MY_PN="ifenslave-2.6" # this is NOT an error
DEBIAN_PV="17"
DEBIANPKG_TARBALL="${MY_PN}_${PV}.orig.tar.gz"
DEBIANPKG_PATCH="${MY_PN}_${PV}-${DEBIAN_PV}.debian.tar.gz"
DEBIANPKG_BASE="mirror://debian/pool/main/${MY_PN:0:1}/${MY_PN}"

inherit toolchain-funcs linux-info

DESCRIPTION="Attach and detach slave interfaces to a bonding device"
HOMEPAGE="http://sf.net/projects/bonding/"
SRC_URI="${DEBIANPKG_BASE}/${DEBIANPKG_TARBALL}
	${DEBIANPKG_BASE}/${DEBIANPKG_PATCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gcc
	>=sys-kernel/linux-headers-2.4.22
	${RDEPEND}"

CONFIG_CHECK="~BONDING"
WARNING_BONDING="CONFIG_BONDING is required to get bond devices in the kernel"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} ${PN}.c -o ${PN} || die "Failed to compile!"
}

src_install() {
	into /
	dosbin ${PN}
	into

	# there really is no better documentation than the sourcecode :-)
	dodoc ${PN}.c

	doman "${WORKDIR}/debian/${PN}.8"
}

pkg_preinst() {
	if [[ -f /etc/modules.d/bond ]] || [[ -f /etc/modprobe.d/bond ]]; then
		elog "You may want to remove /etc/modules.d/bond and/or /etc/modprobe.d/bond"
		elog "because it likely causes some deprecation warnings like:"
		elog "Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-bond0 instead"
		elog "It may also cause unexpected behaviour."
	fi
}
