# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-builder-convert/gtk-builder-convert-2.24.27.ebuild,v 1.8 2015/06/07 10:33:12 maekke Exp $

EAPI="5"
GNOME_ORG_MODULE="gtk+"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit gnome.org python-single-r1

DESCRIPTION="Converts Glade files to GtkBuilder XML format"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# gtk-builder-convert was part of gtk+ until 2.24.10-r1
COMMON_DEPEND="${PYTHON_DEPS}"

RDEPEND="${COMMON_DEPEND}
	!<=x11-libs/gtk+-2.24.10:2
"

DEPEND="${COMMON_DEPEND}"

src_configure() { :; }

src_compile() { :; }

src_install() {
	cd gtk || die
	python_doscript gtk-builder-convert
}
