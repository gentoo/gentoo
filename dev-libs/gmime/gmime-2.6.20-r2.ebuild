# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit eutils mono-env gnome2 vala

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/ https://developer.gnome.org/gmime/stable/"

SLOT="2.6"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc mono smime static-libs vala"

RDEPEND="
	>=dev-libs/glib-2.18:2
	sys-libs/zlib
	mono? (
		dev-lang/mono
		>=dev-dotnet/glib-sharp-2.4.0:2 )
	smime? ( >=app-crypt/gpgme-1.1.6 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	mono? ( dev-dotnet/gtk-sharp-gapi:2 )
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.30.0 )
"

pkg_setup() {
	use mono && mono-env_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-cryptography \
		--disable-strict-parser \
		$(use_enable mono) \
		$(use_enable smime) \
		$(use_enable static-libs static) \
		$(use_enable vala)
}

src_compile() {
	MONO_PATH="${S}" gnome2_src_compile
	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	GACUTIL_FLAGS="/root '${ED}/usr/$(get_libdir)' /gacdir '${EPREFIX}/usr/$(get_libdir)' /package ${PN}" \
		gnome2_src_install

	if use doc ; then
		docinto tutorial
		dodoc docs/tutorial/html/*
	fi
}
