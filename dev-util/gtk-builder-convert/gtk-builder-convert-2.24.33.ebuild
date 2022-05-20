# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME_ORG_MODULE="gtk+"
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml"

inherit gnome.org python-single-r1

DESCRIPTION="Converts Glade files to GtkBuilder XML format"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.3
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
"

src_configure() { :; }

src_compile() {
	xsltproc -nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl docs/reference/gtk/gtk-builder-convert.xml || die
}

src_install() {
	doman gtk-builder-convert.1
	python_doscript gtk/gtk-builder-convert
}
