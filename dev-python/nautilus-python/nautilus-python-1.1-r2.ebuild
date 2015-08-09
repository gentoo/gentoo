# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-single-r1

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="http://projects.gnome.org/nautilus-python/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Depend on pygobject:3 for sanity, and because it's automagic
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-base/nautilus-2.32[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-libs/libxslt
		>=dev-util/gtk-doc-1.9 )
"

src_configure() {
	# FIXME: package does not ship pre-built documentation
	# and has broken logic for dealing with gtk-doc
	gnome2_src_configure $(use_enable doc gtk-doc)
}

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nautilus-python/extensions
	# Doesn't get installed by "make install" for some reason
	if use doc ; then
		insinto /usr/share/gtk-doc/html/nautilus-python # for dev-util/devhelp
		doins -r docs/html/.
	fi
}
