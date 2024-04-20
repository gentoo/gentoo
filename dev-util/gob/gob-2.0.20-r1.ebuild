# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="gob2"

inherit gnome2

DESCRIPTION="Preprocessor for making GTK+ objects with inline C code"
HOMEPAGE="https://www.jirka.org/gob.html"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=dev-libs/glib-2.4:2"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	virtual/pkgconfig
	app-alternatives/yacc"
