# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/im-ja/im-ja-1.5-r3.ebuild,v 1.3 2014/06/22 19:54:25 pacho Exp $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit autotools gnome2 eutils multilib readme.gentoo

DESCRIPTION="A Japanese input module for GTK2 and XIM"
HOMEPAGE="http://im-ja.sourceforge.net/"
SRC_URI="http://im-ja.sourceforge.net/${P}.tar.gz
	http://im-ja.sourceforge.net/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="canna freewnn skk anthy"
# --enable-debug causes build failure with gtk+-2.4
#IUSE="${IUSE} debug"

RDEPEND="
	>=dev-libs/glib-2.4:2
	>=dev-libs/atk-1.6
	>=x11-libs/gtk+-2.4:2
	>=x11-libs/pango-1.2.1
	>=gnome-base/gconf-2.4:2
	>=gnome-base/libglade-2.4:2.0
	>=gnome-base/libgnomeui-2.4
	freewnn? ( app-i18n/freewnn )
	canna? ( app-i18n/canna )
	skk? ( virtual/skkserv )
	anthy? ( app-i18n/anthy )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	dev-perl/URI
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="This version of im-ja comes with experimental XIM support.
If you'd like to try it out, run im-ja-xim-server and set
environment variable XMODIFIERS to @im=im-ja-xim-server
e.g.)
$ export XMODIFIERS=@im=im-ja-xim-server (sh)
> setenv XMODIFIERS @im=im-ja-xim-server (csh)"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch" \
		"${FILESDIR}"/${P}-pofiles.patch \
		"${FILESDIR}/${P}-underlinking.patch"

	sed -ie 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.in || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local myconf
	# You cannot use `use_enable ...` here. im-ja's configure script
	# doesn't distinguish --enable-canna from --disable-canna, so
	# --enable-canna stands for --disable-canna in the script ;-(
	use canna || myconf="$myconf --disable-canna"
	use freewnn || myconf="$myconf --disable-wnn"
	use anthy || myconf="$myconf --disable-anthy"
	use skk || myconf="$myconf --disable-skk"
	#use debug && myconf="$myconf --enable-debug"

	gnome2_src_configure \
		--disable-gnome \
		$myconf
}

src_install() {
	gnome2_src_install

	sed -e "s:@EPREFIX@:${EPREFIX}:" "${FILESDIR}/xinput-${PN}" > "${T}/${PN}.conf" || die
	insinto /etc/X11/xinit/xinput.d
	doins "${T}/${PN}.conf"

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_query_immodules_gtk2
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
	gnome2_pkg_postrm
}
