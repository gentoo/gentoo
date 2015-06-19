# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-extras-base/gnome-python-extras-base-2.25.3-r1.ebuild,v 1.11 2014/10/11 11:49:01 maekke Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit versionator autotools eutils gnome2 python-any-r1

# This ebuild does nothing -- we just want to get the pkgconfig file installed
MY_PN="gnome-python-extras"
DESCRIPTION="Provides python the base files for the Gnome Python Desktop bindings"
HOMEPAGE="http://pygtk.org/"
PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="0"
RESTRICT="test"

# From the gnome-python-extras eclass
RDEPEND=">=x11-libs/gtk+-2.4:2
	>=dev-libs/glib-2.6:2
	$(python_gen_any_dep '>=dev-python/pygtk-2.10.3:2[${PYTHON_USEDEP}]')
	!<=dev-python/gnome-python-extras-2.19.1-r2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common"
# eautoreconf needs gnome-base/gnome-common

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

src_prepare() {
	epatch "${FILESDIR}/${P}-python-libs.patch" #344231
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-allbindings
}
