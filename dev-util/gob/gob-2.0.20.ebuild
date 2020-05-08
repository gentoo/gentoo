# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="gob2"

inherit gnome2

DESCRIPTION="Preprocessor for making GTK+ objects with inline C code"
HOMEPAGE="https://www.jirka.org/gob.html"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~m68k ppc ~ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=dev-libs/glib-2.4:2"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"
