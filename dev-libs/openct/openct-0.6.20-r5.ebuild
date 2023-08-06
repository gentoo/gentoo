# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic udev

DESCRIPTION="library for accessing smart card terminals"
HOMEPAGE="https://github.com/OpenSC/openct/wiki"
SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc debug pcsc-lite selinux usb"

DEPEND="
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.7.2-r1:= )
	usb? ( virtual/libusb:0 )
	dev-libs/libltdl:0=
"
RDEPEND="
	${DEPEND}
	acct-group/openct
	acct-user/openctd
	selinux? ( sec-policy/selinux-openct )
"
BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-slibtool.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use debug && append-cppflags -DDEBUG_IFDH

	econf \
		--localstatedir=/var \
		--with-udev="$(get_udevdir)" \
		--enable-non-privileged \
		--with-daemon-user=openctd \
		--with-daemon-groups=usb \
		--enable-shared \
		--disable-static \
		$(use_enable doc) \
		$(use_enable doc api-doc) \
		$(use_enable pcsc-lite pcsc) \
		$(use_with pcsc-lite bundle /usr/$(get_libdir)/readers/usb) \
		$(use_enable usb)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	rm -f "${ED}"/usr/$(get_libdir)/openct-ifd.* || die

	udev_newrules etc/openct.udev 70-openct.rules

	newinitd "${FILESDIR}"/openct.initd openct
}

pkg_postinst() {
	elog
	elog "You need to edit /etc/openct.conf to enable serial readers."
	elog
	elog "You should add \"openct\" to your default runlevel. To do so"
	elog "type \"rc-update add openct default\"."
	elog
	elog "You need to be a member of the (newly created) group openct to"
	elog "access smart card readers connected to this system. Set users'"
	elog "groups with usermod -G.  root always has access."
	elog
}
