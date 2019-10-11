# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )
GNOME_ORG_MODULE="gnome-python-desktop"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 python-r1

# This ebuild does nothing -- we just want to get the pkgconfig file installed

DESCRIPTION="Provides python the base files for the Gnome Python Desktop bindings"
HOMEPAGE="http://pygtk.org/"

KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
LICENSE="LGPL-2.1"
SLOT="0"

# From the gnome-python-desktop eclass
RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygtk-2.10.3:2[${PYTHON_USEDEP}]
	>=dev-libs/glib-2.6.0:2
	>=x11-libs/gtk+-2.4.0:2
	!<dev-python/gnome-python-extras-2.13
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="test"

src_prepare() {
	gnome2_src_prepare
	python_setup
	python_fix_shebang .
}

src_configure() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
	gnome2_src_configure \
		--disable-allbindings
}
