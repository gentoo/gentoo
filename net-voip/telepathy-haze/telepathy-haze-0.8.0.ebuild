# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/telepathy-haze/telepathy-haze-0.8.0.ebuild,v 1.7 2015/04/08 18:20:12 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Telepathy connection manager providing libpurple supported protocols"
HOMEPAGE="http://developer.pidgin.im/wiki/TelepathyHaze"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
#IUSE="test"
IUSE=""

# Tests failing, see upstream: https://bugs.freedesktop.org/34577
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	>=net-im/pidgin-2.7
	>=net-libs/telepathy-glib-0.15.1[${PYTHON_USEDEP}]
	>=dev-libs/glib-2.30:2
	>=dev-libs/dbus-glib-0.73
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
#	test? ( dev-python/twisted-words )"
