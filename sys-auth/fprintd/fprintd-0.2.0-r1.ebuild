# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/fprintd/fprintd-0.2.0-r1.ebuild,v 1.4 2012/05/15 07:15:40 xmw Exp $

EAPI=4

inherit autotools toolchain-funcs versionator

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/fprintd/"
MY_PV="V_$(replace_all_version_separators _)"
SRC_URI="http://cgit.freedesktop.org/libfprint/${PN}/snapshot/${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc pam static-libs"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	sys-auth/libfprint
	sys-auth/polkit
	pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	dev-util/intltool
	doc? ( dev-libs/libxml2 dev-libs/libxslt )"

S=${WORKDIR}/${MY_PV}

src_prepare() {
	cp /usr/share/gtk-doc/data/gtk-doc.make . || die
	sed -e '/SUBDIRS/s: po::' -i Makefile.am || die
	eautoreconf
	intltoolize || die
}

src_configure() {
	econf $(use_enable pam) \
		$(use_enable static-libs static) \
		$(use_enable doc gtk-doc-html)
}

src_install() {
	emake DESTDIR="${D}" install \
		pammoddir=/$(get_libdir)/security

	keepdir /var/lib/fprint

	find "${D}" -name "*.la" -delete || die

	dodoc AUTHORS ChangeLog NEWS README TODO
	if use doc ; then
		insinto /usr/share/doc/${PF}/html
		doins doc/{fprintd-docs,version}.xml
		insinto /usr/share/doc/${PF}/html/dbus
		doins doc/dbus/net.reactivated.Fprint.{Device,Manager}.ref.xml
	fi
}

pkg_postinst() {
	elog "Please take a look at the upstream documentation for integration"
	elog "Example: add following line to your /etc/pam.d/system-local-login"
	einfo
	elog "    auth    sufficient      pam_fprintd.so"
	einfo
}
