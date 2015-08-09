# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools pam systemd versionator

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/fprintd/"
MY_PV="V_$(replace_all_version_separators _)"
SRC_URI="http://cgit.freedesktop.org/libfprint/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

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
	eautoreconf
}

src_configure() {
	econf --disable-silent-rules \
		$(use_enable pam) \
		$(use_enable static-libs static) \
		$(use_enable doc gtk-doc-html) \
		$(systemd_with_unitdir)
}

src_install() {
	emake DESTDIR="${D}" install \
		pammoddir=$(getpam_mod_dir)

	keepdir /var/lib/fprint

	find "${D}" -name "*.la" -delete || die

	dodoc AUTHORS NEWS README{,.transifex} TODO
	newdoc pam/README README.pam_fprintd
	if use doc ; then
		insinto /usr/share/doc/${PF}/html
		doins doc/{fprintd-docs,version}.xml
		insinto /usr/share/doc/${PF}/html/dbus
		doins doc/dbus/net.reactivated.Fprint.{Device,Manager}.ref.xml
	fi
}

pkg_postinst() {
	elog "Please take a look at README.pam_fprintd for integration docs."
}
