# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is NOT an error, Debian's 2.x is a rewrite using ifupdown instead.
MY_PN="ifenslave-2.6"
DEBIAN_PV="17"
DEBIANPKG_TARBALL="${MY_PN}_${PV}.orig.tar.gz"
DEBIANPKG_PATCH="${MY_PN}_${PV}-${DEBIAN_PV}.debian.tar.gz"
DEBIANPKG_BASE="mirror://debian/pool/main/${MY_PN:0:1}/${MY_PN}"

inherit toolchain-funcs linux-info

DESCRIPTION="Attach and detach slave interfaces to a bonding device"
HOMEPAGE="https://sf.net/projects/bonding/"
SRC_URI="
	${DEBIANPKG_BASE}/${DEBIANPKG_TARBALL}
	${DEBIANPKG_BASE}/${DEBIANPKG_PATCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ppc sparc x86"

DEPEND=">=sys-kernel/linux-headers-2.4.22"

CONFIG_CHECK="~BONDING"
WARNING_BONDING="CONFIG_BONDING is required to get bond devices in the kernel"

src_configure() {
	tc-export CC
}

src_compile() {
	emake ifenslave
}

src_install() {
	into /
	dosbin ifenslave

	# there really is no better documentation than the sourcecode :-)
	dodoc ifenslave.c

	doman "${WORKDIR}"/debian/ifenslave.8
}

pkg_preinst() {
	if [[ -f /etc/modules.d/bond ]] || [[ -f /etc/modprobe.d/bond ]]; then
		elog "You may want to remove /etc/modules.d/bond and/or /etc/modprobe.d/bond"
		elog "because it likely causes some deprecation warnings like:"
		elog "Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-bond0 instead"
		elog "It may also cause unexpected behaviour."
	fi
}
