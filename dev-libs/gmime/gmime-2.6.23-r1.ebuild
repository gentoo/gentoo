# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala flag-o-matic

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/ https://developer.gnome.org/gmime/stable/"

SLOT="2.6"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc smime static-libs test vala"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.32.0:2
	sys-libs/zlib
	smime? ( >=app-crypt/gpgme-1.1.6:1= )
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/libiconv
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	test? ( app-crypt/gnupg )
"
# gnupg is needed for tests if --enable-cryptography is enabled, which we do unconditionally

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs iconv
	gnome2_src_configure \
		--enable-cryptography \
		--disable-strict-parser \
		--disable-mono \
		$(use_enable smime) \
		$(use_enable static-libs static) \
		$(use_enable vala)
}

src_compile() {
	gnome2_src_compile
	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	gnome2_src_install

	if use doc ; then
		docinto tutorial
		dodoc -r docs/tutorial/html/
	fi
}
