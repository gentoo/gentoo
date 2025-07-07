# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Userspace utilities for a general USB device sharing system over IP networks"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v5.x/linux-${PV}.tar.xz"
S="${WORKDIR}/linux-${PV}/tools/usb/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpd"

RDEPEND="
	>=dev-libs/glib-2.6
	sys-apps/hwdata
	>=sys-kernel/linux-headers-3.17
	virtual/libudev
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	tar xJf "${DISTDIR}"/${A} linux-${PV}/tools/usb/${PN} || die
}

src_prepare() {
	default
	# remove -Werror from build, bug #545398
	sed -i 's/-Werror[^ ]* //g' configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		$(usev !tcpd --without-tcp-wrappers) \
		--with-usbids-dir="${EPREFIX}"/usr/share/hwdata
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "For using USB/IP you need to enable USBIP_VHCI_HCD in the client"
	elog "machine's kernel config and USBIP_HOST on the server."
}
