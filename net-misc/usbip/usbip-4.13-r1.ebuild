# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE="sources"
K_NOUSENAME=1
inherit autotools kernel-2

DESCRIPTION="Userspace utilities for a general USB device sharing system over IP networks"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="${KERNEL_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpd"

RDEPEND="
	>=dev-libs/glib-2.6
	sys-apps/hwids
	>=sys-kernel/linux-headers-3.17
	virtual/libudev
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/linux-${PV}/tools/usb/${PN}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

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
		--disable-static \
		$(use tcpd || echo --without-tcp-wrappers) \
		--with-usbids-dir="${EPREFIX}"/usr/share/misc
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "For using USB/IP you need to enable USBIP_VHCI_HCD in the client"
	elog "machine's kernel config and USBIP_HOST on the server."
}
