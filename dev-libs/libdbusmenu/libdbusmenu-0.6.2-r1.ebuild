# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu/libdbusmenu-0.6.2-r1.ebuild,v 1.1 2015/04/05 16:09:44 mgorny Exp $

EAPI=4
VALA_MIN_API_VERSION=0.16
VALA_USE_DEPEND=vapigen

inherit eutils flag-o-matic vala

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="http://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/${PN/lib}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="debug gtk3 +introspection"

RDEPEND=">=dev-libs/glib-2.32
	>=dev-libs/dbus-glib-0.100
	dev-libs/libxml2
	gtk3? ( >=x11-libs/gtk+-3.2:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	!<${CATEGORY}/${PN}-0.5.1-r200"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig
	introspection? ( $(vala_depend) )"

src_prepare() {
	if use introspection; then
		vala_src_prepare
		export VALA_API_GEN="${VAPIGEN}"
	fi
}

src_configure() {
	append-flags -Wno-error #414323

	# dumper extra tool is only for GTK+-2.x, tests use valgrind which is stupid
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-static \
		--disable-silent-rules \
		--disable-scrollkeeper \
		$(use_enable gtk3 gtk) \
		--disable-dumper \
		--disable-tests \
		$(use_enable introspection) \
		$(use_enable introspection vala) \
		$(use_enable debug massivedebugging) \
		--with-html-dir=/usr/share/doc/${PF}/html \
		--with-gtk=3
}

src_test() { :; } #440192

src_install() {
	emake -j1 DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README

	local a b
	for a in ${PN}-{glib,gtk}; do
		b=/usr/share/doc/${PF}/html/${a}
		[[ -d ${ED}/${b} ]] && dosym ${b} /usr/share/gtk-doc/html/${a}
	done

	prune_libtool_files
}
