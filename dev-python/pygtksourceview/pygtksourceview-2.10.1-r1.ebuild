# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtksourceview/pygtksourceview-2.10.1-r1.ebuild,v 1.12 2015/04/08 08:04:52 mgorny Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-r1

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/pygobject-2.15.2:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.8:2[${PYTHON_USEDEP}]
	>=x11-libs/gtksourceview-2.9.7:2.0
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	virtual/pkgconfig
	doc? (
		dev-libs/libxslt
		~app-text/docbook-xml-dtd-4.1.2
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
"

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome2_src_configure $(use_enable doc docs)
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README"
	python_foreach_impl run_in_build_dir gnome2_src_install
}
