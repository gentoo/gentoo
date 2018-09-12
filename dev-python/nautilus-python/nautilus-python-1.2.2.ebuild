# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit eutils gnome2 python-single-r1

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="https://projects.gnome.org/nautilus-python/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Depend on pygobject:3 for sanity, and because it's automagic
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-base/nautilus-3.20[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
"

src_configure() {
	python_setup
	# FIXME: package does not ship pre-built documentation
	# and has broken logic for dealing with gtk-doc
	gnome2_src_configure $(use_enable doc gtk-doc)
}

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nautilus-python/extensions
}
