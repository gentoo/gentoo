# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"
inherit gnome2

DESCRIPTION="CORBA tree builder"
HOMEPAGE="https://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=">=dev-libs/glib-2.44.1-r1:2"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	virtual/pkgconfig"
