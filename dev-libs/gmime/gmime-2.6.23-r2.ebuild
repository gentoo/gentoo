# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_USE_DEPEND="vapigen"
inherit flag-o-matic gnome2 vala

DESCRIPTION="Library for creating and parsing MIME messages"
HOMEPAGE="http://spruce.sourceforge.net/gmime/"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="doc smime test vala"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	sys-libs/zlib
	smime? ( >=app-crypt/gpgme-1.1.6:= )
	vala? ( >=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}
	virtual/libiconv
"
BDEPEND="
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	test? ( app-crypt/gnupg )
	vala? ( $(vala_depend) )
"
# gnupg is needed for tests if --enable-cryptography is enabled, which we do unconditionally

src_configure() {
	use vala && vala_setup

	[[ ${CHOST} == *-solaris* ]] && append-libs iconv
	gnome2_src_configure \
		--enable-cryptography \
		--disable-strict-parser \
		--disable-mono \
		$(use_enable smime) \
		$(use_enable vala)
}

src_compile() {
	gnome2_src_compile

	if use doc; then
		emake -C docs/tutorial html
		HTML_DOCS=( docs/tutorial/html/. )
	fi
}
