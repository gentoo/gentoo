# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME_TARBALL_SUFFIX="bz2"
GCONF_DEBUG="no"

inherit eutils gnome2 multilib-minimal

DESCRIPTION="CORBA tree builder"
HOMEPAGE="https://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.44.1-r1:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	virtual/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README"
G2CONF="--disable-static"

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	gnome2_src_configure
}

multilib_src_compile() {
	gnome2_src_compile
}

multilib_src_isntall() {
	gnome2_src_install
}
