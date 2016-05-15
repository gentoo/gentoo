# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils multilib readme.gentoo-r1

DESCRIPTION="Gtk+-2.0 Hangul Input Modules"
HOMEPAGE="https://code.google.com/p/imhangul/"
SRC_URI="https://imhangul.googlecode.com/files/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=app-i18n/libhangul-0.0.12
	>=x11-libs/gtk+-2.2:2
	virtual/libintl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
If you want to use one of the module as a default input method,

export GTK_IM_MODULE=hangul2  # 2 input type
export GTK_IM_MODULE=hangul3f # 3 input type
"

get_gtk_confdir() {
	# bug #366889
	if has_version '>=x11-libs/gtk+-2.22.1-r1:2' || has_multilib_profile ; then
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0/$(get_abi_CHOST)}"
	else
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0}"
	fi
	echo ${GTK2_CONFDIR}
}

src_prepare() {
	default
	gnome2_environment_reset
	gnome2_disable_deprecation_warning
}

src_configure() {
	econf \
		--with-gtk-im-module-dir="${EPREFIX}/usr/$(get_libdir)/gtk-2.0/immodules" \
		--with-gtk-im-module-file="$(get_gtk_confdir)"
}

src_install() {
	default
	prune_libtool_files --modules

	insinto /etc/X11/xinit/xinput.d
	newins "${FILESDIR}/xinput-imhangul2" imhangul2.conf
	newins "${FILESDIR}/xinput-imhangul2y" imhangul2y.conf
	newins "${FILESDIR}/xinput-imhangul32" imhangul32.conf
	newins "${FILESDIR}/xinput-imhangul39" imhangul39.conf
	newins "${FILESDIR}/xinput-imhangul3f" imhangul3f.conf
	newins "${FILESDIR}/xinput-imhangul3s" imhangul3s.conf
	newins "${FILESDIR}/xinput-imhangul3y" imhangul3y.conf
	newins "${FILESDIR}/xinput-imhangulahn" imhangulahn.conf
	newins "${FILESDIR}/xinput-imhangulro" imhangulro.conf

	dodoc imhangul.conf
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_query_immodules_gtk2
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
}
