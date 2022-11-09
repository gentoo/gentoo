# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"
inherit gnome2

DESCRIPTION="CORBA tree builder"
HOMEPAGE="https://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

RDEPEND=">=dev-libs/glib-2.44.1-r1:2"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/yacc
	virtual/pkgconfig"
