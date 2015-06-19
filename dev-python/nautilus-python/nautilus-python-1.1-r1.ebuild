# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nautilus-python/nautilus-python-1.1-r1.ebuild,v 1.4 2012/08/11 12:45:33 maekke Exp $

EAPI="4"

PYTHON_DEPEND="2"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 python

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="http://projects.gnome.org/nautilus-python/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="doc"

# Depend on pygobject:3 for sanity, and because it's automagic
RDEPEND="dev-python/pygobject:3
	>=gnome-base/nautilus-2.32[introspection]"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nautilus-python/extensions/
	# Doesn't get installed by "make install" for some reason
	if use doc; then
		insinto /usr/share/gtk-doc/html/nautilus-python # for dev-util/devhelp
		doins -r docs/html/*
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_need_rebuild
}
