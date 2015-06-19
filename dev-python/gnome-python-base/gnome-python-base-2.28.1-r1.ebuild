# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-base/gnome-python-base-2.28.1-r1.ebuild,v 1.10 2014/10/11 11:48:21 maekke Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit versionator eutils gnome2 python-any-r1

# This ebuild does nothing -- we just want to get the pkgconfig file installed

MY_PN="gnome-python"
DESCRIPTION="Provides the base files for the gnome-python bindings"
HOMEPAGE="http://pygtk.org/"
PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="2"
RESTRICT="${RESTRICT} test"

# From the gnome-python eclass
RDEPEND=">=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.6:2
	$(python_gen_any_dep '
		>=dev-python/pygtk-2.14.0:2[${PYTHON_USEDEP}]
		>=dev-python/pygobject-2.17:2[${PYTHON_USEDEP}]
	')
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	gnome2_src_configure \
		--disable-allbindings
}
