# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit autotools eapi7-ver eutils gnome2 python-r1

# This ebuild does nothing -- we just want to get the pkgconfig file installed
MY_PN="gnome-python-extras"
DESCRIPTION="Provides python the base files for the Gnome Python Desktop bindings"
HOMEPAGE="http://pygtk.org/"
PVP="$(ver_cut 1-2)"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
LICENSE="LGPL-2.1"
SLOT="0"
RESTRICT="test"

# From the gnome-python-extras eclass
RDEPEND=">=x11-libs/gtk+-2.4:2
	>=dev-libs/glib-2.6:2
	${PYTHON_DEPS}
	>=dev-python/pygtk-2.10.3:2[${PYTHON_USEDEP}]
	!<=dev-python/gnome-python-extras-2.19.1-r2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common"
# eautoreconf needs gnome-base/gnome-common

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

src_prepare() {
	epatch "${FILESDIR}/${P}-python-libs.patch" #344231
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
	python_setup
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-allbindings
}
