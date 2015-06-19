# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/usbip/usbip-3.19.ebuild,v 1.2 2015/04/08 10:08:46 chithanh Exp $

EAPI=5
ETYPE="sources"
K_NOUSENAME=1
inherit autotools eutils kernel-2

DESCRIPTION="Userspace utilities for a general USB device sharing system over IP networks"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="${KERNEL_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs tcpd"
RESTRICT=""

RDEPEND=">=dev-libs/glib-2.6
	sys-apps/hwids
	>=sys-kernel/linux-headers-3.17
	virtual/libudev
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README ../../../drivers/usb/usbip/usbip_protocol.txt"

S=${WORKDIR}/linux-${PV}/tools/usb/${PN}

src_prepare() {
	# remove -Werror from build, bug #545398
	sed -i 's/-Werror[^ ]* //g' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use tcpd || echo --without-tcp-wrappers) \
		--with-usbids-dir=/usr/share/misc
}

src_install() {
	default
	prune_libtool_files
}

pkg_postinst() {
	elog "For using USB/IP you need to enable USBIP_VHCI_HCD in the client"
	elog "machine's kernel config and USBIP_HOST on the server."
}
