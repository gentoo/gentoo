# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 python-single-r1

DESCRIPTION="Parser and analyzer for backtraces produced by GDB"
HOMEPAGE="https://fedorahosted.org/btparser/"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="amd64 ~x86"

IUSE="static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.21:2
"
DEPEND="${RDEPEND}"

# Incomplete tarball for tests
RESTRICT="test"

src_prepare() {
	eautoreconf # to prevent maintainer mode
	gnome2_src_prepare
}

src_configure() {
	export PYTHON_CFLAGS=$(python_get_CFLAGS)
	export PYTHON_LIBS=$(python_get_LIBS)

	gnome2_src_configure \
		$(use_enable static-libs static)
}
