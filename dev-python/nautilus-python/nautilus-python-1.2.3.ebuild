# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit gnome2 python-single-r1

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="https://projects.gnome.org/nautilus-python/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Require pygobject:3 and USE=introspection on nautilus for sanity,
# because no (user) plugins could work without them; configure itself
# requires pygobject:3 or :2 and >=nautilus-2.32
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	>=gnome-base/nautilus-3[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nautilus-python/extensions
}
