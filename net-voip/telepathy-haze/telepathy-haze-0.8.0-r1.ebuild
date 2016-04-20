# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Telepathy connection manager providing libpurple supported protocols"
HOMEPAGE="http://developer.pidgin.im/wiki/TelepathyHaze"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
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

src_prepare() {
	# contact-list: Don't crash if a contact is already in the roster
	# (fixed in next version)
	epatch "${FILESDIR}"/${P}-crash.patch

	# Fix compat with newer pidgin versions, bug #572296
	epatch "${FILESDIR}"/${P}-pidgin-2.10.12-compat.patch
}
