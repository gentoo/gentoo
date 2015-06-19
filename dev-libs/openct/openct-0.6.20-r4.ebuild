# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openct/openct-0.6.20-r4.ebuild,v 1.3 2015/04/02 18:21:41 mr_bones_ Exp $

EAPI=5

inherit eutils flag-o-matic multilib udev user

DESCRIPTION="library for accessing smart card terminals"
HOMEPAGE="https://github.com/OpenSC/openct/wiki"

SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.gz"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc pcsc-lite usb debug +udev"

# Drop the libtool dep once libltdl goes stable.
RDEPEND="pcsc-lite? ( >=sys-apps/pcsc-lite-1.7.2-r1 )
	usb? ( virtual/libusb:0 )
	|| ( dev-libs/libltdl:0 <sys-devel/libtool-2.4.3-r2:2 )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# udev is not required at all at build-time as it's only a matter of
# installing the rules; add openrc for the checkpath used in the new
# init script
RDEPEND="${RDEPEND}
	udev? ( virtual/udev )
	sys-apps/openrc"

pkg_setup() {
	enewgroup openct
	enewuser openctd
}

src_configure() {
	use debug && append-cppflags -DDEBUG_IFDH

	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		--localstatedir=/var \
		--with-udev="$(get_udevdir)" \
		--enable-non-privileged \
		--with-daemon-user=openctd \
		--with-daemon-groups=usb \
		--enable-shared --disable-static \
		$(use_enable doc) \
		$(use_enable doc api-doc) \
		$(use_enable pcsc-lite pcsc) \
		$(use_with pcsc-lite bundle /usr/$(get_libdir)/readers/usb) \
		$(use_enable usb)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all
	rm "${D}"/usr/$(get_libdir)/openct-ifd.*

	use udev && udev_newrules etc/openct.udev 70-openct.rules

	newinitd "${FILESDIR}"/openct.rc.2 openct
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
