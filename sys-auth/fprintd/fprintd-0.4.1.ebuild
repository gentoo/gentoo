# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools toolchain-funcs versionator

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://cgit.freedesktop.org/libfprint/fprintd/"
MY_PV="V_$(replace_all_version_separators _)"
SRC_URI="https://cgit.freedesktop.org/libfprint/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
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

	dodoc AUTHORS ChangeLog NEWS README{,.transifex} TODO
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
