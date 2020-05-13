# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="gobject-introspection"

inherit gnome.org

DESCRIPTION="Build infrastructure for GObject Introspection"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="!<${CATEGORY}/${GNOME_ORG_MODULE}-${PV}"
# Use !<${PV} because mixing gobject-introspection with different version of -common can cause issues like:
# https://forums.gentoo.org/viewtopic-p-7421930.html

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins m4/introspection.m4

	insinto /usr/share/gobject-introspection-1.0
	doins Makefile.introspection
}
