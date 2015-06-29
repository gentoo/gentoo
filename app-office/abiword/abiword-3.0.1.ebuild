# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/abiword/abiword-3.0.1.ebuild,v 1.6 2015/06/29 18:37:33 pacho Exp $

EAPI=5
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Fully featured yet light and fast cross platform word processor"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="calendar collab cups eds +goffice grammar +introspection latex map math ots +plugins readline redland spell wordperfect wmf thesaurus"

# You need 'plugins' enabled if want to enable the extra plugins
REQUIRED_USE="!plugins? ( !collab !grammar !latex !math !ots !readline !thesaurus !wordperfect !wmf )"

RDEPEND="
	>=app-text/wv-1.2
	>=dev-libs/fribidi-0.10.4
	>=dev-libs/glib-2.16:2
	>=dev-libs/libgcrypt-1.4.5:0
	dev-libs/libxslt
	>=gnome-base/librsvg-2.16:2
	>=gnome-extra/libgsf-1.14.18
	>=media-libs/libpng-1.2:0=
	virtual/jpeg:0
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-3.0.8:3[cups?]
	calendar? ( >=dev-libs/libical-0.46:= )
	eds? ( >=gnome-extra/evolution-data-server-3.6.0:= )
	goffice? ( >=x11-libs/goffice-0.10.2:0.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.0.0 )
	map? ( >=media-libs/libchamplain-0.12 )
	plugins? (
		collab? (
			>=dev-libs/libxml2-2.4
			>=net-libs/loudmouth-1
			net-libs/libsoup:2.4
			net-libs/gnutls )
		grammar? ( >=dev-libs/link-grammar-4.2.1 )
		math? ( >=x11-libs/gtkmathview-0.7.5 )
		ots? ( >=app-text/ots-0.5-r1 )
		readline? ( sys-libs/readline:* )
		thesaurus? ( >=app-text/aiksaurus-1.2[gtk] )
		wordperfect? (
			app-text/libwpd:0.9
			app-text/libwpg:0.2 )
		wmf? ( >=media-libs/libwmf-0.2.8 )
	)
	redland? (
		>=dev-libs/redland-1.0.10
		>=dev-libs/rasqal-0.9.17 )
	spell? ( >=app-text/enchant-1.2 )
	!<app-office/abiword-plugins-2.8
"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-libs/boost-1.40.0
	virtual/pkgconfig
	collab? ( dev-cpp/asio )
"

src_prepare() {
	# readme.txt will be installed using dodoc
	sed '/readme\.txt\|abw/d' \
		-i user/wp/Makefile.am user/wp/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	local plugins=""

	if use plugins; then
		# Plugins depending on libgsf
		plugins="t602 docbook clarisworks wml kword hancom openwriter pdf
			loadbindings mswrite garble pdb applix opendocument sdw xslfo"

		# Plugins depending on librsvg
		plugins="${plugins} svg"

		# Plugins not depending on anything
		plugins="${plugins} gimp bmp freetranslation iscii s5 babelfish opml eml
			wikipedia gdict passepartout google presentation urldict hrtext mif
			openxml"

		# inter7eps: eps.h
		# libtidy: gsf + tidy.h
		# paint: windows only ?
		use collab && plugins="${plugins} collab"
		use goffice && plugins="${plugins} goffice"
		use latex && plugins="${plugins} latex"
		use math && plugins="${plugins} mathview"
		use ots && plugins="${plugins} ots"
		# psion: >=psiconv-0.9.4
		use readline && plugins="${plugins} command"
		use thesaurus && plugins="${plugins} aiksaurus"
		use wmf && plugins="${plugins} wmf"
		# wordperfect: >=wpd-0.9 >=wpg-0.2
		use wordperfect && plugins="${plugins} wpg"
	fi

	gnome2_src_configure \
		--enable-plugins="$(echo ${plugins})" \
		--disable-static \
		--disable-default-plugins \
		--disable-builtin-plugins \
		--disable-collab-backend-telepathy \
		--enable-clipart \
		--enable-statusbar \
		--enable-templates \
		--with-gio \
		--without-gnomevfs \
		--without-gtk2 \
		$(use_with goffice goffice) \
		$(use_with calendar libical) \
		$(use_enable cups print) \
		$(use_enable collab collab-backend-xmpp) \
		$(use_enable collab collab-backend-tcp) \
		$(use_enable collab collab-backend-service) \
		$(use_with eds evolution-data-server) \
		$(use_enable introspection) \
		$(use_with map champlain) \
		$(use_with redland) \
		$(use_enable spell)
}

src_compile() {
	# Parallel build fails, bug #488462
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile
}

src_install() {
	gnome2_src_install
	dodoc user/wp/readme.txt
}
