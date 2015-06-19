# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/imhangul/imhangul-0.9.16.ebuild,v 1.3 2012/05/03 19:24:27 jdhore Exp $

EAPI="3"
inherit multilib

DESCRIPTION="Gtk+-2.0 Hangul Input Modules"
HOMEPAGE="http://kldp.net/projects/imhangul/"
SRC_URI="http://kldp.net/frs/download.php/5856/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-i18n/libhangul-0.0.12
	>=x11-libs/gtk+-2.2:2
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

get_gtk_confdir() {
	if has_multilib_profile ; then
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0/${CHOST}}"
	else
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0}"
	fi
	echo ${GTK2_CONFDIR}
}

update_gtk_immodules() {
	local GTK2_CONFDIR=$(get_gtk_confdir)

	mkdir -p "${GTK2_CONFDIR}"

	if [ -x "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" ] ; then
		"${EPREFIX}/usr/bin/gtk-query-immodules-2.0" > "${GTK2_CONFDIR}/gtk.immodules"
	fi
}

src_configure() {
	econf \
		--with-gtk-im-module-dir="${EPREFIX}/usr/$(get_libdir)/gtk-2.0/immodules" \
		--with-gtk-im-module-file="$(get_gtk_confdir)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /etc/X11/xinit/xinput.d
	newins "${FILESDIR}/xinput-imhangul2" imhangul2.conf || die
	newins "${FILESDIR}/xinput-imhangul2y" imhangul2y.conf || die
	newins "${FILESDIR}/xinput-imhangul32" imhangul32.conf || die
	newins "${FILESDIR}/xinput-imhangul39" imhangul39.conf || die
	newins "${FILESDIR}/xinput-imhangul3f" imhangul3f.conf || die
	newins "${FILESDIR}/xinput-imhangul3s" imhangul3s.conf || die
	newins "${FILESDIR}/xinput-imhangul3y" imhangul3y.conf || die
	newins "${FILESDIR}/xinput-imhangulahn" imhangulahn.conf || die
	newins "${FILESDIR}/xinput-imhangulro" imhangulro.conf || die

	dodoc AUTHORS ChangeLog NEWS README TODO imhangul.conf || die
}

pkg_postinst() {
	update_gtk_immodules

	elog ""
	elog "If you want to use one of the module as a default input method, "
	elog ""
	elog "export GTK_IM_MODULE=hangul2  # 2 input type"
	elog "export GTK_IM_MODULE=hangul3f # 3 input type"
	elog ""
}

pkg_postrm() {
	update_gtk_immodules
}
