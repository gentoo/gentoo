# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/telepathy-idle/telepathy-idle-0.2.0.ebuild,v 1.5 2015/04/08 18:01:55 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Full-featured IRC connection manager for Telepathy"
HOMEPAGE="http://cgit.freedesktop.org/telepathy/telepathy-idle"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/glib-2.32:2
	>=net-libs/telepathy-glib-0.21[${PYTHON_USEDEP}]
	sys-apps/dbus
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/twisted-words )
"

src_prepare() {
	# Failed in 0.1.16 and code has not moved since october
	# Upstream is working on 1.0
	sed -e 's:connect/server-quit-ignore.py::' \
		-e 's:connect/server-quit-noclose.py::' \
		-i tests/twisted/Makefile.{am,in} || die
}
