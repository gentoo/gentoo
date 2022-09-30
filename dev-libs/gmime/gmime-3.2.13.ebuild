# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome2 vala

DESCRIPTION="Library for creating and parsing MIME messages"
HOMEPAGE="https://github.com/jstedfast/gmime http://spruce.sourceforge.net/gmime/"
SRC_URI="https://github.com/jstedfast/${PN}/releases/download/${PV}/${P}.tar.xz"

SLOT="3.0"
LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="crypt doc idn test +vala"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.68.0:2
	sys-libs/zlib
	crypt? ( >=app-crypt/gpgme-1.8.0:= )
	idn? ( net-dns/libidn2:= )
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.30.0:=
	)
"
DEPEND="${RDEPEND}
	virtual/libiconv
"
BDEPEND="
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
"

src_prepare() {
	gnome2_src_prepare
	use vala && vala_setup
}

src_configure() {
	if [[ ${CHOST} == *-solaris* ]]; then
		# bug #???, why not use --with-libiconv
		append-libs iconv
	fi

	gnome2_src_configure \
		--enable-largefile \
		$(use_enable crypt crypto) \
		$(use_enable vala) \
		$(use_with idn libidn) \
		$(usex doc "" DB2HTML=)
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
