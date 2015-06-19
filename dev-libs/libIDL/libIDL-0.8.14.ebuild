# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libIDL/libIDL-0.8.14.ebuild,v 1.12 2013/03/03 14:59:34 pacho Exp $

EAPI=5
GNOME_TARBALL_SUFFIX="bz2"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="CORBA tree builder"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.4:2"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	virtual/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README"
G2CONF="--disable-static"
